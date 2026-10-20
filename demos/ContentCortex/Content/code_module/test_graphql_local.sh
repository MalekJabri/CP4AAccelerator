#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────────
# test_graphql_local.sh
#
# Local smoke-test for the CodeModule deployment and GenAI Classification
# configuration GraphQL mutations.
#
# Usage:
#   chmod +x test_graphql_local.sh
#   ./test_graphql_local.sh \
#       --host  <cpe-host>        \   # e.g. cpd-myns.apps.cluster.example.com
#       --user  <username>        \   # e.g. cp4admin
#       --pass  <password>        \   # plaintext, used only locally
#       --os    <object-store>    \   # default: OS1
#       --step  <1|2|3|4|5|6|all>    # which test(s) to run (default: all)
#
# Steps:
#   1  - Verify connectivity  (GET /content-services-graphql/graphql)
#   2  - Check /CodeModules folder exists (query)
#   3  - Create CodeModule stub (no JARs — pure schema check)
#   4  - Create EventAction  (depends on step 3 output)
#   5  - Create Subscription (depends on step 4 output)
#   6  - GenAIClassificationConfig property templates + class + instance
# ──────────────────────────────────────────────────────────────────────────────

set -euo pipefail

# ── Defaults ──────────────────────────────────────────────────────────────────
HOST="cpd-cp4ba.apps.itz-w49k89.infra01-lb.lon04.techzone.ibm.com"
USER="cpmanager"
PASS='baKTu-vVsAJ-dOOBI-ujMto'
OS="OS1"
STEP="all"

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --host)  HOST="$2"; shift 2 ;;
    --user)  USER="$2"; shift 2 ;;
    --pass)  PASS="$2"; shift 2 ;;
    --os)    OS="$2";   shift 2 ;;
    --step)  STEP="$2"; shift 2 ;;
    *) echo "Unknown argument: $1"; exit 1 ;;
  esac
done

if [[ -z "$HOST" || -z "$USER" || -z "$PASS" ]]; then
  echo "Usage: $0 --host <host> --user <user> --pass <password> [--os <OS1>] [--step <all|1-6>]"
  exit 1
fi

ENDPOINT="https://${HOST}/content-services-graphql/graphql"
AUTH_HEADER="Authorization: Basic $(printf '%s:%s' "$USER" "$PASS" | base64)"

# Shared state — populated by steps and consumed by later steps
CODE_MODULE_ID=""
EVENT_ACTION_ID=""

# ── Helpers ───────────────────────────────────────────────────────────────────

run_step() { [[ "$STEP" == "all" || "$STEP" == "$1" ]]; }

pretty() {
  # Pretty-print JSON if jq is available, otherwise cat
  if command -v jq &>/dev/null; then
    echo "$1" | jq .
  else
    echo "$1"
  fi
}

gql_post() {
  # $1 = label, $2 = mutation body (plain GraphQL, not JSON-wrapped)
  # Display output goes to stderr; only raw JSON response is written to stdout
  # so that callers can capture the return value cleanly with $().
  local label="$1"
  local mutation="$2"
  # Wrap the mutation in {"query":"..."} — escape inline
  local escaped
  escaped=$(printf '%s' "$mutation" \
    | sed 's/\\/\\\\/g' \
    | sed 's/"/\\"/g' \
    | tr '\n' ' ' \
    | sed 's/\t/ /g')
  local payload="{\"query\":\"${escaped}\"}"

  echo "" >&2
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
  echo "▶ ${label}" >&2
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2

  local response
  response=$(curl -sk \
    -X POST "$ENDPOINT" \
    -H "$AUTH_HEADER" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -d "$payload")

  # Pretty-print to stderr for the operator to read
  if command -v jq &>/dev/null; then
    echo "$response" | jq . >&2 2>/dev/null || echo "$response" >&2
  else
    echo "$response" >&2
  fi

  # Return raw JSON on stdout for callers
  echo "$response"
}

extract_id() {
  # $1 = raw JSON response
  # Returns the first "id" field inside "data" using jq (or grep fallback)
  local json="$1"
  if command -v jq &>/dev/null; then
    echo "$json" | jq -r '.data | to_entries[0].value.id // empty' 2>/dev/null
  else
    # grep fallback — picks first "id":"<value>"
    echo "$json" | grep -o '"id":"[^"]*"' | head -1 | sed 's/"id":"//;s/"//'
  fi
}

# ── Step 1: Connectivity check ────────────────────────────────────────────────
if run_step 1; then
  echo ""
  echo "════════════════════════════════════════════════════════════════════"
  echo "  STEP 1 — Connectivity check"
  echo "════════════════════════════════════════════════════════════════════"
  echo "Endpoint: ${ENDPOINT}"
  # Use a minimal POST introspection query — GraphQL endpoints reject plain GET with 400/405
  # Separate body from status code: curl appends the code on its own line via -w
  ping_body=$(curl -sk \
    -X POST "$ENDPOINT" \
    -H "$AUTH_HEADER" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -d '{"query":"{ __typename }"}')
  http_code=$(curl -sk -o /dev/null -w "%{http_code}" \
    -X POST "$ENDPOINT" \
    -H "$AUTH_HEADER" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -d '{"query":"{ __typename }"}')
  body="$ping_body"
  echo "HTTP status: ${http_code}"
  echo "Response:    ${body}"
  if [[ "$http_code" == "200" ]]; then
    echo "✔  Server reachable and accepting requests"
  elif [[ "$http_code" == "401" || "$http_code" == "403" ]]; then
    echo "✘  HTTP ${http_code} — authentication failed, check --user / --pass"
    exit 1
  else
    echo "⚠  HTTP ${http_code} — server responded (may still work for mutations)"
  fi
fi

# ── Step 2: Check /CodeModules folder ─────────────────────────────────────────
if run_step 2; then
  echo ""
  echo "════════════════════════════════════════════════════════════════════"
  echo "  STEP 2 — Check /CodeModules folder exists"
  echo "════════════════════════════════════════════════════════════════════"

  QUERY='query CheckCodeModulesFolder {
  folder(
    repositoryIdentifier: "'"${OS}"'"
    identifier: "/CodeModules"
  ) {
    id
    pathName
  }
}'

  raw=$(gql_post "query: CheckCodeModulesFolder" "$QUERY")

  folder_id=""
  if command -v jq &>/dev/null; then
    folder_id=$(echo "$raw" | jq -r '.data.folder.id // empty' 2>/dev/null)
  else
    folder_id=$(echo "$raw" | grep -o '"id":"[^"]*"' | head -1 | sed 's/"id":"//;s/"//')
  fi

  if [[ -n "$folder_id" ]]; then
    echo "✔  /CodeModules folder exists (id=${folder_id})"
  else
    echo "✘  /CodeModules folder NOT found — create it first!"
    echo "   Run the mutation below manually in ACCE or GraphQL Explorer:"
    cat <<'EOF'
mutation CreateCodeModulesFolder {
  createFolder(
    repositoryIdentifier: "OS1"
    folderProperties: {
      name: "CodeModules"
      parent: { identifier: "/" }
    }
    classIdentifier: "Folder"
  ) {
    id
    pathName
  }
}
EOF
    echo ""
    echo "Continuing anyway (step 3 will also fail if folder is missing)..."
  fi
fi

# ── Step 3: Create CodeModule stub (no real JAR content) ──────────────────────
if run_step 3; then
  echo ""
  echo "════════════════════════════════════════════════════════════════════"
  echo "  STEP 3 — Create CodeModule stub (no JAR content)"
  echo "════════════════════════════════════════════════════════════════════"
  echo "  This is a content-less stub to validate the schema/permissions."
  echo "  The real deployment (CodeModuleService) embeds base64 JAR bytes."

  # filing goes in fileInFolderIdentifier (top-level arg), NOT inside documentProperties
  # versionSeriesId / versionLabel are not on the Document type in this schema version
  MUTATION_STUB='mutation CreateCodeModuleStub {
  createDocument(
    repositoryIdentifier: "'"${OS}"'"
    classIdentifier: "CodeModule"
    fileInFolderIdentifier: "/CodeModules"
    documentProperties: {
      name: "Core-MJ Module (STUB)"
    }
    checkinAction: {
      autoClassify: false
      checkinMinorVersion: false
    }
  ) {
    id
    name
    contentSize
  }
}'

  raw3=$(gql_post "mutation: CreateCodeModuleStub" "$MUTATION_STUB")
  CODE_MODULE_ID=$(extract_id "$raw3")

  if [[ -n "$CODE_MODULE_ID" ]]; then
    echo ""
    echo "✔  CodeModule stub created with id=${CODE_MODULE_ID}"
  else
    echo ""
    echo "✘  CodeModule creation failed — see response above"
    echo "   Common causes:"
    echo "     - /CodeModules folder does not exist"
    echo "     - User lacks CREATE permission on the object store"
    echo "     - 'CodeModule' class is not in this object store"
    [[ "$STEP" == "all" ]] && exit 1
  fi
fi

# ── Step 4: Create EventAction ────────────────────────────────────────────────
if run_step 4; then
  echo ""
  echo "════════════════════════════════════════════════════════════════════"
  echo "  STEP 4 — Create EventAction"
  echo "════════════════════════════════════════════════════════════════════"

  if [[ -z "$CODE_MODULE_ID" ]]; then
    echo "  ⚠  CODE_MODULE_ID not set — did step 3 run?"
    echo "  Set it manually: CODE_MODULE_ID=<id from step 3>"
    if [[ "$STEP" == "all" ]]; then
      echo "  Skipping step 4."
    fi
  else
    MUTATION_EA='mutation CreateEventAction_GenAIClassification {
  createEventAction(
    repositoryIdentifier: "'"${OS}"'"
    eventActionProperties: {
      displayName: "GenAI Classification Action"
      progId: "com.ibm.mj.core.eventHandler.GenAIClassificationDocEventHandler"
      isEnabled: true
      codeModule: { identifier: "'"${CODE_MODULE_ID}"'" }
    }
  ) {
    id
    displayName
    progId
    isEnabled
    codeModule {
      id
      name
    }
  }
}'

    raw4=$(gql_post "mutation: CreateEventAction_GenAIClassification" "$MUTATION_EA")
    EVENT_ACTION_ID=$(extract_id "$raw4")

    if [[ -n "$EVENT_ACTION_ID" ]]; then
      echo ""
      echo "✔  EventAction created with id=${EVENT_ACTION_ID}"
    else
      echo ""
      echo "✘  EventAction creation failed — see response above"
      [[ "$STEP" == "all" ]] && exit 1
    fi
  fi
fi

# ── Step 5: Create Subscription ───────────────────────────────────────────────
if run_step 5; then
  echo ""
  echo "════════════════════════════════════════════════════════════════════"
  echo "  STEP 5 — Create Subscription"
  echo "════════════════════════════════════════════════════════════════════"

  if [[ -z "$EVENT_ACTION_ID" ]]; then
    echo "  ⚠  EVENT_ACTION_ID not set — did step 4 run?"
    echo "  Set it manually: EVENT_ACTION_ID=<id from step 4>"
    if [[ "$STEP" == "all" ]]; then
      echo "  Skipping step 5."
    fi
  else
    MUTATION_SUB='mutation CreateSubscription_GenAIClassification {
  createSubscription(
    repositoryIdentifier: "'"${OS}"'"
    subscriptionProperties: {
      displayName: "GenAI Classification Subscription"
      subscribedClass: { identifier: "ToBeClassified" }
      subscribedEvent: UpdateEvent
      includeSubclasses: false
      isSynchronous: false
      isEnabled: true
      filterExpression: "[GenaiDateIndexed] IS NOT NULL"
      eventActions: {
        replace: [{ identifier: "'"${EVENT_ACTION_ID}"'" }]
      }
    }
  ) {
    id
    displayName
    subscribedClass { symbolicName }
    subscribedEvent
    includeSubclasses
    isSynchronous
    isEnabled
    filterExpression
    eventActions { id displayName }
  }
}'

    raw5=$(gql_post "mutation: CreateSubscription_GenAIClassification" "$MUTATION_SUB")
    SUB_ID=$(extract_id "$raw5")

    if [[ -n "$SUB_ID" ]]; then
      echo ""
      echo "✔  Subscription created with id=${SUB_ID}"
    else
      echo ""
      echo "✘  Subscription creation failed — see response above"
      echo "   Common causes:"
      echo "     - 'ToBeClassified' class does not exist"
      echo "     - 'GenaiDateIndexed' property template does not exist"
    fi
  fi
fi

# ── Step 6: GenAIClassificationConfig mutations ───────────────────────────────
if run_step 6; then
  echo ""
  echo "════════════════════════════════════════════════════════════════════"
  echo "  STEP 6 — GenAIClassificationConfig (property templates + class + instance)"
  echo "════════════════════════════════════════════════════════════════════"
  echo "  Running all mutations from GenAIClassificationConfig.graphql"
  echo "  Failures are non-fatal (template may already exist)."

  MUTATIONS_CONFIG=(
    'mutation CreatePT_GAI_IsEnabled { admCreatePropertyTemplate(repositoryIdentifier: "'"${OS}"'" dataType: BOOLEAN propertyTemplateProperties: { symbolicName: "GAI_IsEnabled" cardinality: SINGLE displayNames: { replace: [{ localeName: "en-us" localizedText: "Is Enabled" }] } subPropertyTemplateBooleanProperties: {} }) { id symbolicName } }'
    'mutation CreatePT_GAI_Verbose { admCreatePropertyTemplate(repositoryIdentifier: "'"${OS}"'" dataType: BOOLEAN propertyTemplateProperties: { symbolicName: "GAI_Verbose" cardinality: SINGLE displayNames: { replace: [{ localeName: "en-us" localizedText: "Verbose" }] } subPropertyTemplateBooleanProperties: {} }) { id symbolicName } }'
    'mutation CreatePT_GAI_LLMModel { admCreatePropertyTemplate(repositoryIdentifier: "'"${OS}"'" dataType: STRING propertyTemplateProperties: { symbolicName: "GAI_LLMModel" cardinality: SINGLE displayNames: { replace: [{ localeName: "en-us" localizedText: "LLM Model" }] } subPropertyTemplateStringProperties: {} }) { id symbolicName } }'
    'mutation CreatePT_GAI_MaxChunks { admCreatePropertyTemplate(repositoryIdentifier: "'"${OS}"'" dataType: LONG propertyTemplateProperties: { symbolicName: "GAI_MaxChunks" cardinality: SINGLE displayNames: { replace: [{ localeName: "en-us" localizedText: "Max Chunks" }] } subPropertyTemplateInteger32Properties: {} }) { id symbolicName } }'
    'mutation CreatePT_GAI_PromptPrefix { admCreatePropertyTemplate(repositoryIdentifier: "'"${OS}"'" dataType: STRING propertyTemplateProperties: { symbolicName: "GAI_PromptPrefix" cardinality: SINGLE displayNames: { replace: [{ localeName: "en-us" localizedText: "Prompt Prefix" }] } subPropertyTemplateStringProperties: { maximumLengthString: 4000 } }) { id symbolicName } }'
    'mutation CreatePT_GAI_AllowedClasses { admCreatePropertyTemplate(repositoryIdentifier: "'"${OS}"'" dataType: STRING propertyTemplateProperties: { symbolicName: "GAI_AllowedClasses" cardinality: SINGLE displayNames: { replace: [{ localeName: "en-us" localizedText: "Allowed Classes" }] } subPropertyTemplateStringProperties: {} }) { id symbolicName } }'
    'mutation CreatePT_GAI_BaseClass { admCreatePropertyTemplate(repositoryIdentifier: "'"${OS}"'" dataType: STRING propertyTemplateProperties: { symbolicName: "GAI_BaseClass" cardinality: SINGLE displayNames: { replace: [{ localeName: "en-us" localizedText: "Base Class" }] } subPropertyTemplateStringProperties: {} }) { id symbolicName } }'
    'mutation CreatePT_GAI_FallbackClass { admCreatePropertyTemplate(repositoryIdentifier: "'"${OS}"'" dataType: STRING propertyTemplateProperties: { symbolicName: "GAI_FallbackClass" cardinality: SINGLE displayNames: { replace: [{ localeName: "en-us" localizedText: "Fallback Class" }] } subPropertyTemplateStringProperties: {} }) { id symbolicName } }'
    'mutation CreatePT_GAI_RelevancyFilterLevel { admCreatePropertyTemplate(repositoryIdentifier: "'"${OS}"'" dataType: DOUBLE propertyTemplateProperties: { symbolicName: "GAI_RelevancyFilterLevel" cardinality: SINGLE displayNames: { replace: [{ localeName: "en-us" localizedText: "Relevancy Filter Level" }] } subPropertyTemplateFloat64Properties: {} }) { id symbolicName } }'
    'mutation CreatePT_GAI_ExcludedProperties { admCreatePropertyTemplate(repositoryIdentifier: "'"${OS}"'" dataType: STRING propertyTemplateProperties: { symbolicName: "GAI_ExcludedProperties" cardinality: LIST displayNames: { replace: [{ localeName: "en-us" localizedText: "Excluded Properties" }] } subPropertyTemplateStringProperties: { maximumLengthString: 1000 } }) { id symbolicName } }'
  )

  for m in "${MUTATIONS_CONFIG[@]}"; do
    name=$(echo "$m" | grep -o 'mutation [A-Za-z_]*' | head -1 | awk '{print $2}')
    gql_post "mutation: ${name}" "$m" || true
  done

  echo ""
  echo "  → Creating class GenAIClassificationConfig..."
  MUTATION_CLASS='mutation CreateClass_GenAIClassificationConfig {
  admCreateClassDefinition(
    repositoryIdentifier: "'"${OS}"'"
    superclassIdentifier: "CmAbstractPersistable"
    classDefinitionProperties: {
      symbolicName: "GenAIClassificationConfig"
      displayNames: { replace: [{ localeName: "en-us" localizedText: "GenAI Classification Config" }] }
      descriptiveTexts: { replace: [{ localeName: "en-us" localizedText: "GenAI Classification Config" }] }
      propertyDefinitions: {
        modify: [
          { insertAction: {} propertyTemplate: { identifier: "GAI_IsEnabled" } isValueRequired: false isHidden: false }
          { insertAction: {} propertyTemplate: { identifier: "GAI_Verbose" } isValueRequired: false isHidden: false }
          { insertAction: {} propertyTemplate: { identifier: "GAI_LLMModel" } isValueRequired: false isHidden: false }
          { insertAction: {} propertyTemplate: { identifier: "GAI_MaxChunks" } isValueRequired: false isHidden: false }
          { insertAction: {} propertyTemplate: { identifier: "GAI_PromptPrefix" } isValueRequired: false isHidden: false }
          { insertAction: {} propertyTemplate: { identifier: "GAI_AllowedClasses" } isValueRequired: false isHidden: false }
          { insertAction: {} propertyTemplate: { identifier: "GAI_BaseClass" } isValueRequired: false isHidden: false }
          { insertAction: {} propertyTemplate: { identifier: "GAI_FallbackClass" } isValueRequired: false isHidden: false }
          { insertAction: {} propertyTemplate: { identifier: "GAI_RelevancyFilterLevel" } isValueRequired: false isHidden: false }
          { insertAction: {} propertyTemplate: { identifier: "GAI_ExcludedProperties" } isValueRequired: false isHidden: false }
        ]
      }
    }
  ) { className id symbolicName displayName }
}'

  gql_post "mutation: CreateClass_GenAIClassificationConfig" "$MUTATION_CLASS" || true

  echo ""
  echo "  → Creating default GenAIClassificationConfig instance..."
  MUTATION_INST='mutation CreateInstance_GenAIClassificationConfig {
  createCmAbstractPersistable(
    repositoryIdentifier: "'"${OS}"'"
    classIdentifier: "GenAIClassificationConfig"
    cmAbstractPersistableProperties: {
      properties: [
        { GAI_IsEnabled: true }
        { GAI_Verbose: false }
        { GAI_LLMModel: "meta-llama/llama-4-maverick-17b-128e-instruct-fp8" }
        { GAI_MaxChunks: 6 }
        { GAI_BaseClass: "ToBeClassified" }
        { GAI_FallbackClass: "" }
        { GAI_RelevancyFilterLevel: 0.5 }
      ]
    }
  ) {
    id
    className
    properties(includes: ["GAI_IsEnabled","GAI_Verbose","GAI_LLMModel","GAI_MaxChunks","GAI_BaseClass","GAI_FallbackClass","GAI_RelevancyFilterLevel"]) {
      alias
      value
    }
  }
}'

  gql_post "mutation: CreateInstance_GenAIClassificationConfig" "$MUTATION_INST" || true
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════════════════════════════════"
echo "  DONE"
echo "  CODE_MODULE_ID  = ${CODE_MODULE_ID:-<not captured>}"
echo "  EVENT_ACTION_ID = ${EVENT_ACTION_ID:-<not captured>}"
echo "════════════════════════════════════════════════════════════════════"
