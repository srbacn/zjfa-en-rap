# ZJFA_EN_RAP — Production Quality Monitor

RAP-based unified dashboard combining production orders (PP) with quality inspection data (QM).  
Replaces the need to switch between `COOIS` and `QGA1` by delivering a single Fiori Elements List Report.

---

## Object Inventory

| Object | Type | Purpose |
|---|---|---|
| `ZI_ProdQualityMonitor` | DDLS (Root Interface View) | Joins AUFK + AFKO + AFPO; calculates scrap rate |
| `ZI_ProdQualityInspection` | DDLS (Child Interface View) | QALS + QAVE + defect count |
| `ZI_ProdQualityDefectCount` | DDLS (Aggregation View) | Counts defects per QM notification from QMFE |
| `ZC_ProdQualityMonitor` | DDLS (Root Projection View) | OData V4 consumption view with search |
| `ZC_ProdQualityInspection` | DDLS (Child Projection View) | Inspection lot consumption view |
| `ZC_ProdQualityMonitor` | DDLX (Metadata Extension) | UI annotations: List Report + Object Page |
| `ZC_ProdQualityInspection` | DDLX (Metadata Extension) | UI annotations: Inspection lot table |
| `ZI_ProdQualityMonitor` | BDEF (Abstract Interface) | Read-only RAP BO definition |
| `ZC_ProdQualityMonitor` | BDEF (Projection) | Projection behavior |
| `ZSD_ProdQualityMonitor` | SRVD (Service Definition) | Exposes both entities via OData |
| `ZSB_ProdQualityMonitor_O4` | SRVB (Service Binding) | OData V4 / UI binding |

---

## Data Model

```
AUFK (Order Master)
  └─ AFKO (Order Header)     → ScrapRate = GMNGA/GAMNG × 100
  └─ AFPO (Order Item 0001)  → Material
  └─ QALS (Inspection Lot)   via QALS-AUFNR = AUFK-AUFNR
        └─ QAVE (Usage Decision) via PRUEFLOS
        └─ QMFE (Defect Items)   via QMNUM (aggregated count)
```

---

## abapGit Deployment Steps

### Prerequisites
- Package `ZJFA_EN_RAP` already exists in your ABAP system
- abapGit plugin installed in Eclipse ADT

### Step 1 — Push this repository to GitHub
```bash
cd C:\Users\saurabh.s.mehta\Documents\zjfa_en_rap_abapgit
git init
git add .
git commit -m "Initial commit: Production Quality Monitor RAP objects"
git remote add origin https://github.com/<your-org>/zjfa-en-rap.git
git push -u origin main
```

### Step 2 — Link repo in Eclipse ADT (abapGit)
1. Open Eclipse ADT → connect to your BTP ABAP system
2. Window → Show View → abapGit Repositories
3. Click **+** (New Repository)
4. Enter your GitHub repository URL
5. Set **Package** = `ZJFA_EN_RAP`
6. Click **Next** → **Finish**

### Step 3 — Pull objects
1. Right-click the linked repository → **Pull**
2. Select a transport request when prompted
3. abapGit will create and activate all objects in dependency order

### Step 4 — Publish the Service Binding
> If `ZSB_PRODQUALITYMONITOR_O4` activates but shows "not published":
1. In ADT Project Explorer, expand `ZJFA_EN_RAP` → Service Bindings
2. Double-click `ZSB_PRODQUALITYMONITOR_O4`
3. Click **Publish Locally** (for BTP) or **Publish** (for on-premise)

### Step 5 — Launch the Fiori App
Copy the **Service URL** from the service binding and open it in your Fiori Launchpad or test it directly via `/sap/opu/odata4/...`.

---

## Key Business Fields

| Field | Source Table | Description |
|---|---|---|
| `ProductionOrder` | AUFK.AUFNR | Production order number |
| `Plant` | AUFK.WERKS | Manufacturing plant |
| `Material` | AFPO.MATNR | Finished goods material |
| `BasicStartDate` | AFKO.GSTRI | Planned start |
| `BasicFinishDate` | AFKO.GLTRI | Planned finish |
| `TotalOrderQty` | AFKO.GAMNG | Total confirmed quantity |
| `ConfirmedScrapQty` | AFKO.GMNGA | Confirmed scrap quantity |
| `ScrapRatePct` | Calculated | (Scrap/Total) × 100 |
| `InspectionLot` | QALS.PRUEFLOS | QM inspection lot number |
| `InspLotOrigin` | QALS.ART | Lot origin (04 = PP goods receipt) |
| `UsageDecisionCode` | QAVE.BEURTEILUNG | A=Accept / R=Reject etc. |
| `DefectCount` | COUNT(QMFE) | Total defects recorded |

---

## Adjusting Order Type Filter

The root view filters `AUART in ('PP01','PP10','ZP01','ZP10')`.  
Edit `zi_prodqualitymonitor.ddls.asddls` WHERE clause to match your order types:
```sql
where ProdOrder.auart in ( 'PP01', 'PP10', 'ZP01', 'ZP10' )
```

---

## Troubleshooting

| Issue | Resolution |
|---|---|
| SRVD/SRVB XML fails to import | Create manually in ADT: Right-click package → New → Service Definition / Service Binding |
| `count(*)` syntax error in DDLS | Replace with `count( qmnum )` in `zi_prodqualitydefectcount` |
| QALS.AUFNR empty for some lots | Check `InspLotOrigin` — only lots with ART='04' link back to production orders |
| Table access denied (BTP) | Replace direct table access with released CDS views: `I_ProductionOrder`, `I_InspectionLot` |
