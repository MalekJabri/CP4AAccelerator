# IBK Sample Documents — Insurance & Banking

## Overview

This folder contains all **sample Markdown documents** for the **IBK Insurance & Banking** ECM demonstration environment, built on **IBM Content Cortex** (repository `OS1`).

IBK is a fictional global financial institution covering **six lines of business**. Each sample document is designed to:
- Populate the IBK Content Cortex repository with realistic, searchable content.
- Demonstrate AI-driven document capture, extraction, classification, and lifecycle management.
- All documents are in **English** (multi-language versions — German, Spanish, French — are available for advanced agentic extraction demonstrations).

---

## Folder Structure

```
Insurance & Banking/
├── Retail Banking/
│   ├── Loan Origination/
│   │   └── Hans Müller — LN-2024-00142/
│   │       ├── 01 – Application/          IBK-RETAIL-01 — Personal Loan Application
│   │       ├── 02 – Income & Employment/  IBK-RETAIL-01 — Employment Certificate (Siemens AG)
│   │       ├── 03 – Credit Assessment/    IBK-RETAIL-01 — Credit Bureau Report
│   │       └── 05 – Approved Loan Documents/ IBK-RETAIL-01 — Personal Loan Agreement
│   ├── Mortgages/
│   │   └── María García — LN-2024-00201/
│   │       ├── 01 – Application/          IBK-RETAIL-02 — Mortgage Application
│   │       └── 02 – Property Valuation/   IBK-RETAIL-02 — Property Valuation Report
│   ├── KYC & AML/
│   │   └── Sophie Martin — CUS-2024-00389/
│   │       ├── Identification Documents/  IBK-RETAIL-03 — KYC Onboarding Form
│   │       └── AML Screening/             IBK-RETAIL-03 — AML Screening Report
│   └── Account Statements/
│       └── James Wilson/2024/             IBK-RETAIL-04 — Monthly Account Statement (March 2024)
│
├── Corporate & Institutional Banking/
│   ├── Loan & Credit Files/
│   │   └── Meridian Industrials GmbH — FAC-2024-0077/
│   │       └── 01 – Term Sheet & Mandate/ IBK-CORP-01 — Syndicated Loan Term Sheet
│   ├── Trade Finance/
│   │   └── Iberia Export SA/Letters of Credit/  IBK-CORP-02 — Letter of Credit Application
│   ├── Capital Markets/
│   │   └── Trade Confirmations/2024/      IBK-CORP-03 — IRS Trade Confirmation
│   └── KYC & EDD/
│       └── Nexus Holdings SAS — CUS-2024-00512/
│           └── EDD Reports/               IBK-CORP-04 — Enhanced Due Diligence Report
│
├── Wealth Management/
│   ├── Private Clients/
│   │   └── Alexander von Richter — PF-2024-0031/
│   │       ├── 02 – Suitability & IPS/    IBK-WM-01 — Client Suitability Assessment & IPS
│   │       └── 04 – Portfolio Reports/2024-Q4/  IBK-WM-02 — Q4 2024 Portfolio Report
│   └── Trust & Estates/
│       └── Beaumont Family Trust — TR-2024-0009/
│           └── Trust Deed/                IBK-WM-03 — Trust Deed
│
├── Insurance/
│   ├── Life Insurance/Policies/
│   │   └── Karl Fischer — POL-LIFE-2024-00891/
│   │       ├── 02 – Underwriting/         IBK-INS-01 — Underwriting Memorandum
│   │       └── 03 – Policy Documents/     IBK-INS-01 — Life Insurance Policy Schedule
│   ├── Property & Casualty/Claims/
│   │   └── CLM-2024-04421 — POL-PC-2023-00654/
│   │       ├── Loss Report/               IBK-INS-02 — Motor Claim Form
│   │       └── Settlement/                IBK-INS-02 — Claim Settlement Letter
│   └── Regulatory/Solvency II/2024/       IBK-INS-04 — Solvency II QRT Narrative Report
│
├── Compliance & Risk/
│   ├── Policy Register/GDPR — Data Protection Policy/  IBK-COMP-01 — GDPR Data Protection Policy
│   ├── AML & Sanctions/SAR Filings/2024/  IBK-COMP-02 — Suspicious Activity Report (SAR)
│   ├── Internal Audit/Retail Credit Review — AUD-2024-003/
│   │   └── Findings/                      IBK-COMP-03 — Internal Audit Report
│   └── GDPR & Data Privacy/Data Subject Requests/  IBK-COMP-04 — DSAR Response (Charlotte Bernard)
│
└── Operations/
    ├── Vendor Management/
    │   └── CloudCore Technologies Ltd — VEN-2024-0041/
    │       ├── Contracts/                 IBK-OPS-01 — Master Service Agreement
    │       └── Invoices/                  IBK-OPS-01 — Q2 2024 Invoice
    ├── Human Resources/
    │   └── Elena Moreau — EMP-2024-0817/
    │       └── Contract & Amendments/     IBK-OPS-02 — Employment Contract
    └── Legacy Migration/                  IBK-OPS-03 — Legacy Migration Manifest
```

---

## Document Index

| Scenario | Document Title | File | Class |
|---------|---------------|------|-------|
| IBK-RETAIL-01 | Personal Loan Application | `Retail Banking/.../IBK-RETAIL-01_Personal-Loan-Application_Hans-Mueller.md` | IBKRetailDocument |
| IBK-RETAIL-01 | Employment Certificate (Siemens AG) | `Retail Banking/.../IBK-RETAIL-01_Employment-Certificate_Siemens-AG.md` | IBKRetailDocument |
| IBK-RETAIL-01 | Credit Bureau Report | `Retail Banking/.../IBK-RETAIL-01_Credit-Bureau-Report_Hans-Mueller.md` | IBKRetailDocument |
| IBK-RETAIL-01 | Personal Loan Agreement | `Retail Banking/.../IBK-RETAIL-01_Personal-Loan-Agreement_Hans-Mueller.md` | IBKRetailDocument |
| IBK-RETAIL-02 | Mortgage Application | `Retail Banking/.../IBK-RETAIL-02_Mortgage-Application_Maria-Garcia.md` | IBKRetailDocument |
| IBK-RETAIL-02 | Property Valuation Report | `Retail Banking/.../IBK-RETAIL-02_Property-Valuation-Report_Calle-Mayor-15.md` | IBKRetailDocument |
| IBK-RETAIL-03 | KYC Onboarding Form | `Retail Banking/.../IBK-RETAIL-03_KYC-Onboarding-Form_Sophie-Martin.md` | IBKRetailDocument |
| IBK-RETAIL-03 | AML Screening Report | `Retail Banking/.../IBK-RETAIL-03_AML-Screening-Report_Sophie-Martin.md` | IBKRetailDocument |
| IBK-RETAIL-04 | Monthly Account Statement (March 2024) | `Retail Banking/.../IBK-RETAIL-04_Account-Statement_March-2024_James-Wilson.md` | IBKRetailDocument |
| IBK-CORP-01 | Syndicated Loan Term Sheet | `Corporate & Institutional Banking/.../IBK-CORP-01_Term-Sheet_Meridian-Industrials.md` | IBKCorporateDocument |
| IBK-CORP-02 | Letter of Credit Application | `Corporate & Institutional Banking/.../IBK-CORP-02_LC-Application_Iberia-Export-SA.md` | IBKCorporateDocument |
| IBK-CORP-03 | IRS Trade Confirmation | `Corporate & Institutional Banking/.../IBK-CORP-03_IRS-Trade-Confirmation_Nexum-Asset-Management.md` | IBKCorporateDocument |
| IBK-CORP-04 | Enhanced Due Diligence Report | `Corporate & Institutional Banking/.../IBK-CORP-04_EDD-Report_Nexus-Holdings-SAS.md` | IBKCorporateDocument |
| IBK-WM-01 | Client Suitability Assessment & IPS | `Wealth Management/.../IBK-WM-01_Suitability-Assessment_Alexander-von-Richter.md` | IBKWealthDocument |
| IBK-WM-02 | Q4 2024 Portfolio Report | `Wealth Management/.../IBK-WM-02_Quarterly-Portfolio-Report_Q4-2024_von-Richter.md` | IBKWealthDocument |
| IBK-WM-03 | Trust Deed | `Wealth Management/.../IBK-WM-03_Trust-Deed_Beaumont-Family-Trust.md` | IBKWealthDocument |
| IBK-INS-01 | Underwriting Memorandum | `Insurance/.../IBK-INS-01_Underwriting-Memo_Karl-Fischer.md` | IBKInsuranceDocument |
| IBK-INS-01 | Life Insurance Policy Schedule | `Insurance/.../IBK-INS-01_Life-Insurance-Policy-Schedule_Karl-Fischer.md` | IBKInsuranceDocument |
| IBK-INS-02 | Motor Claim Form | `Insurance/.../IBK-INS-02_Motor-Claim-Form_Roberto-Fernandez.md` | IBKInsuranceDocument |
| IBK-INS-02 | Claim Settlement Letter | `Insurance/.../IBK-INS-02_Settlement-Letter_CLM-2024-04421.md` | IBKInsuranceDocument |
| IBK-INS-04 | Solvency II QRT Narrative Report | `Insurance/.../IBK-INS-04_Solvency-II-QRT-Narrative-Report_2024.md` | IBKInsuranceDocument |
| IBK-COMP-01 | GDPR Data Protection Policy | `Compliance & Risk/.../IBK-COMP-01_Data-Protection-Policy_GDPR.md` | IBKComplianceDocument |
| IBK-COMP-02 | Suspicious Activity Report (SAR) | `Compliance & Risk/.../IBK-COMP-02_SAR-Filing_2024-00089.md` | IBKComplianceDocument |
| IBK-COMP-03 | Internal Audit Report | `Compliance & Risk/.../IBK-COMP-03_Internal-Audit-Report_Retail-Credit-AUD-2024-003.md` | IBKComplianceDocument |
| IBK-COMP-04 | DSAR Response | `Compliance & Risk/.../IBK-COMP-04_DSAR-Response_Charlotte-Bernard.md` | IBKComplianceDocument |
| IBK-OPS-01 | Master Service Agreement | `Operations/.../IBK-OPS-01_Master-Service-Agreement_CloudCore-Technologies.md` | IBKOperationsDocument |
| IBK-OPS-01 | Vendor Invoice (Q2 2024) | `Operations/.../IBK-OPS-01_Invoice_Q2-2024_CloudCore-Technologies.md` | IBKOperationsDocument |
| IBK-OPS-02 | Employment Contract | `Operations/.../IBK-OPS-02_Employment-Contract_Elena-Moreau.md` | IBKOperationsDocument |
| IBK-OPS-03 | Legacy Migration Manifest | `Operations/.../IBK-OPS-03_Legacy-Migration-Manifest_Operations-Archive.md` | IBKOperationsDocument |

---

## Naming Convention

```
{SCENARIO-ID}_{Document-Type}_{Entity-Name}.md
```

Examples:
- `IBK-RETAIL-01_Personal-Loan-Application_Hans-Mueller.md`
- `IBK-CORP-04_EDD-Report_Nexus-Holdings-SAS.md`

---

## Document Footer Convention

Each document ends with a `> ⚠️ SPECIMEN DOCUMENT` notice and a metadata comment line:

```
*Class: IBKRetailDocument | Scenario: IBK-RETAIL-01, Step 1 | IBKLoanID: LN-2024-00142 | ...*
```

These metadata lines provide the key property values expected to be extracted and classified by the IBM Content Cortex AI pipeline.

---

## Language

All documents in this folder are in **English**. For multi-language demonstration variants (German, Spanish, French), see the `/testMD/` folder (ASOF company set) or request the IBK multi-language pack.

---

*IBK ECM Demonstration Environment — IBM Content Cortex · Repository OS1*
