# IBK ECM Data Model — GraphQL Queries

This directory contains the FileNet Content Services GraphQL mutations required to configure the complete **IBK ECM Data Model** in repository `OS1`, based on [`ibk-ecm-data-model.html`](../../ibk-ecm-data-model.html).

---

## Execution Order

The GraphQL mutations must be executed in strict dependency order:

1. **`01_choice_lists/`** — Choice lists must exist prior to referencing them in property templates.
2. **`02_property_templates/`** — Property templates must exist prior to binding them to document and folder classes.
3. **`03_document_classes/`** — Base class `IBKDocument` must be created first before its subclasses.
4. **`04_folder_classes/`** — Base class `IBKFolder` must be created first before its subclasses.

---

## Directory & File Structure

```
graphql_query/
├── 01_choice_lists/
│   ├── 01_shared_choice_lists.graphql         (9 shared choice lists)
│   ├── 02_retail_choice_lists.graphql         (4 retail choice lists)
│   ├── 03_corporate_choice_lists.graphql      (4 corporate choice lists)
│   ├── 04_wealth_choice_lists.graphql         (4 wealth management choice lists)
│   ├── 05_insurance_choice_lists.graphql      (5 insurance choice lists)
│   ├── 06_compliance_choice_lists.graphql     (4 compliance & risk choice lists)
│   └── 07_operations_choice_lists.graphql     (3 operations choice lists)
│
├── 02_property_templates/
│   ├── 01_shared_property_templates.graphql     (19 shared property templates)
│   ├── 02_retail_property_templates.graphql     (13 retail property templates)
│   ├── 03_corporate_property_templates.graphql  (15 corporate property templates)
│   ├── 04_wealth_property_templates.graphql     (12 wealth property templates)
│   ├── 05_insurance_property_templates.graphql  (17 insurance property templates)
│   ├── 06_compliance_property_templates.graphql (10 compliance property templates)
│   └── 07_operations_property_templates.graphql (13 operations property templates)
│
├── 03_document_classes/
│   ├── 01_IBKDocument.graphql           (Parent: Document, binds 19 shared properties)
│   ├── 02_IBKRetailDocument.graphql     (Parent: IBKDocument, binds 13 retail properties)
│   ├── 03_IBKCorporateDocument.graphql  (Parent: IBKDocument, binds 15 corporate properties)
│   ├── 04_IBKWealthDocument.graphql     (Parent: IBKDocument, binds 12 wealth properties)
│   ├── 05_IBKInsuranceDocument.graphql  (Parent: IBKDocument, binds 17 insurance properties)
│   ├── 06_IBKComplianceDocument.graphql (Parent: IBKDocument, binds 10 compliance properties)
│   └── 07_IBKOperationsDocument.graphql (Parent: IBKDocument, binds 13 operations properties)
│
└── 04_folder_classes/
    ├── 01_IBKFolder.graphql                 (Parent: Folder, binds 4 shared properties)
    ├── 02_IBKRetailCustomerFolder.graphql   (Parent: IBKFolder, binds 3 properties)
    ├── 03_IBKCorporateClientFolder.graphql  (Parent: IBKFolder, binds 4 properties)
    ├── 04_IBKWealthClientFolder.graphql     (Parent: IBKFolder, binds 4 properties)
    ├── 05_IBKPolicyFolder.graphql           (Parent: IBKFolder, binds 5 properties)
    ├── 06_IBKClaimFolder.graphql            (Parent: IBKFolder, binds 4 properties)
    ├── 07_IBKComplianceCaseFolder.graphql   (Parent: IBKFolder, binds 4 properties)
    ├── 08_IBKVendorFolder.graphql           (Parent: IBKFolder, binds 3 properties)
    └── 09_IBKEmployeeFolder.graphql         (Parent: IBKFolder, binds 3 properties)
```

---

## Summary of Data Model Artifacts

| Artifact Category | Count | Details |
|-------------------|-------|---------|
| **Choice Lists** | 33 | 9 Shared, 4 Retail, 4 Corporate, 4 Wealth, 5 Insurance, 4 Compliance, 3 Operations |
| **Property Templates** | 99 | 19 Shared, 13 Retail, 15 Corporate, 12 Wealth, 17 Insurance, 10 Compliance, 13 Operations |
| **Document Classes** | 7 | 1 Base (`IBKDocument`), 6 Subclasses (`IBKRetailDocument`, `IBKCorporateDocument`, `IBKWealthDocument`, `IBKInsuranceDocument`, `IBKComplianceDocument`, `IBKOperationsDocument`) |
| **Folder Classes** | 9 | 1 Base (`IBKFolder`), 8 Subclasses (`IBKRetailCustomerFolder`, `IBKCorporateClientFolder`, `IBKWealthClientFolder`, `IBKPolicyFolder`, `IBKClaimFolder`, `IBKComplianceCaseFolder`, `IBKVendorFolder`, `IBKEmployeeFolder`) |
