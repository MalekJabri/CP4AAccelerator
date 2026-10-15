# Legacy Migration Manifest

**Document Title:** Legacy ECM Migration Manifest  
**Manifest Reference:** MIG-IBK-OPS-2024-003  
**Migration Project:** IBK Legacy Document Migration — Operations Archive  
**Migration Phase:** Phase 3 — Operations & HR Archive (2010–2019)  
**Date:** 1 November 2024  
**Prepared By:** IBK Digital Transformation Office  
**Confidentiality:** Internal  

---

## 1. MIGRATION OVERVIEW

| Field | Details |
|-------|---------|
| Source System | IBK Legacy DMS (OpenText Livelink 9.7.1 — decommission date: 31 December 2024) |
| Target System | IBM Content Cortex — Repository OS1 |
| Migration Tool | IBM Aspera Cargo + custom Python migration scripts |
| Scope | Operations & HR Archive — Documents from 2010 to 2019 (retained per legal obligations) |
| Total Documents (Estimated) | 48,320 |
| Total Volume (Estimated) | 2.3 TB |
| Migration Window | 1 November – 15 December 2024 |

---

## 2. SOURCE FOLDER STRUCTURE (PRESERVED)

The following legacy folder tree is preserved in the target system under `/Operations/Legacy Migration/`:

```
/Operations Archive (Legacy 2010–2019)/
  /Human Resources/
    /Contracts/
      /{Employee Name} — {Employee ID}/
    /Payslips/
      /{YYYY}/
    /Performance Reviews/
      /{YYYY}/
    /Disciplinary Records/
  /Vendor Management/
    /{Vendor Name}/
      /Contracts (Expired)/
      /Invoices (Paid)/
  /Finance & Back-Office/
    /Invoices Paid/
      /{YYYY}/
    /Purchase Orders/
      /{YYYY}/
    /Bank Reconciliations/
      /{YYYY}/
  /IT Assets/
    /Hardware Records/
    /Software Licences/
    /Decommission Reports/
  /Facilities/
    /Building Leases/
    /Maintenance Records/
    /Health & Safety Reports/
```

---

## 3. DOCUMENT STATISTICS BY CATEGORY

| Category | Documents | Volume | Date Range |
|----------|----------:|-------:|------------|
| HR — Contracts | 1,240 | 18.4 GB | 2010–2019 |
| HR — Payslips | 12,480 | 62.1 GB | 2010–2019 |
| HR — Performance Reviews | 2,340 | 14.2 GB | 2010–2019 |
| Vendor — Contracts (Expired) | 890 | 22.8 GB | 2010–2019 |
| Vendor — Invoices (Paid) | 14,200 | 187.4 GB | 2010–2019 |
| Finance — Invoices | 8,740 | 94.6 GB | 2010–2019 |
| Finance — Purchase Orders | 3,210 | 42.1 GB | 2010–2019 |
| Finance — Bank Reconciliations | 1,440 | 12.8 GB | 2010–2019 |
| IT Assets | 2,100 | 28.4 GB | 2010–2019 |
| Facilities | 1,680 | 25.2 GB | 2010–2019 |
| **TOTAL** | **48,320** | **~508 GB compressed / ~2.3 TB raw** | |

---

## 4. MIGRATION RULES & TRANSFORMATION LOGIC

| Rule | Description |
|------|-------------|
| Class Assignment | All migrated documents assigned to `IBKOperationsDocument` |
| IBKLegacySourcePath | Populated with the full Livelink path of each document (e.g. `/Operations Archive (Legacy 2010–2019)/HR/Contracts/...`) |
| DocumentTitle | Preserved from Livelink metadata `DocumentName` field |
| IBKDocumentStatus | Set to `Archived` for all legacy documents |
| IBKConfidentialityLevel | Set to `Internal` unless source metadata contains `CONFIDENTIAL` — then set to `Confidential` |
| Retention Date | Calculated per IBK Retention Schedule — HR records: retention until 2030; Finance records: until 2029 |
| Version Handling | Only the latest approved version migrated (Livelink current version = Content Cortex v1.0) |
| File Format | PDF/A-1b conversion applied to all MS Office documents; native files archived separately |
| Blank / Empty Documents | Excluded (1,240 empty stubs identified — not migrated) |

---

## 5. MIGRATION QUALITY CONTROLS

| Quality Check | Method | Target |
|--------------|--------|--------|
| Document count reconciliation | Pre/post row count comparison | 100% count match |
| Checksum validation | SHA-256 hash comparison | 100% hash match |
| Metadata completeness | Automated validation script | < 0.5% null field rate |
| Rendering quality check | Spot check — 500 random documents | > 99% renderable |
| Broken link check | Automated scan | 0 broken internal links |

---

## 6. MIGRATION STATUS DASHBOARD (as at 1 November 2024)

| Phase | Status | Documents Migrated | % Complete |
|-------|--------|--------------------|----------:|
| Pre-migration scan & deduplication | ✔ Complete | — | 100% |
| Pilot batch (500 docs) | ✔ Complete | 500 | 100% |
| Batch 1 — HR Documents | 🔄 In Progress | 8,420 / 16,060 | 52% |
| Batch 2 — Vendor & Finance | ⏳ Scheduled | 0 / 27,140 | 0% |
| Batch 3 — IT & Facilities | ⏳ Scheduled | 0 / 5,120 | 0% |
| **Total** | | **8,920 / 48,320** | **18%** |

---

## 7. EXCEPTIONS & ISSUES LOG

| Issue ID | Description | Status |
|---------|-------------|--------|
| MIG-EXC-001 | 342 HR payslips in `.WPD` format (WordPerfect) — manual conversion required | Open |
| MIG-EXC-002 | 18 documents flagged as duplicate checksums — under review | Open |
| MIG-EXC-003 | 5 vendor contracts contain embedded password — originals requested from Legal | Open |
| MIG-EXC-004 | Livelink metadata for 2010–2012 contracts incomplete (no Author field) — IBKApproverName set to "UNKNOWN" | Accepted Risk |

---

## 8. PROJECT TEAM

| Role | Name |
|------|------|
| Migration Project Lead | David Clarke, Digital Transformation Office |
| Technical Lead | Andreas Meier, IT Architecture |
| Business Owner | Anna Klebe, Chief Procurement Officer |
| Records Management | Susanne Lang, Group Records Manager |
| IBM Delivery Partner | IBM Client Engineering Team |

---

> ⚠️ **SPECIMEN DOCUMENT — FOR DEMONSTRATION PURPOSES ONLY**

*Class: IBKOperationsDocument | Scenario: IBK-OPS-03, Step 1 | IBKOpsDocType: Legacy Migration Manifest | IBKDocumentStatus: Draft | IBKBatchID: MIG-IBK-OPS-2024-003 | IBKLegacySourcePath: /OpenText Livelink 9.7.1/Operations Archive*
