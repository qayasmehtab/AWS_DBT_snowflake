<div align="center">

# 💎 THE DATA REFINERY
### 🏔️ AWS x Snowflake x dbt: Enterprise Data Architecture

![Project Banner](enterprise_banner.png)

**A Principled Medallion Infrastructure for Modern Global Intelligence**

[![Master Build](https://img.shields.io/badge/Build-Verified-success?style=for-the-badge&logo=github)](https://github.com/qayasmehtab/AWS_DBT_snowflake)
[![Data Quality](https://img.shields.io/badge/QA--Tests-100%25--Pass-green?style=for-the-badge&logo=checkmarx)](https://github.com/qayasmehtab/AWS_DBT_snowflake)
[![dbt](https://img.shields.io/badge/dbt-v1.11.2-FF9900?style=for-the-badge&logo=dbt&logoColor=white)](https://docs.getdbt.com/)
[![Snowflake](https://img.shields.io/badge/Snowflake-Enabled-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)](https://www.snowflake.com/)

---

[**Architecture Blueprint**](#-architecture--lineage) • [**Environment Map**](#-snowflake-environment-map) • [**Record Journey**](#-data-lifecycle--journey) • [**Governance**](#-security--governance) • [**Operations**](#-standard-operating-procedures-sops)

</div>

## 📖 Executive Summary
This repository implements an **Enterprise-Grade Reference Architecture** for building a high-performance Data Lakehouse. By strictly adhering to the **Medallion Architecture**, we transform raw, fragmented datasets from **AWS S3** into highly structured, validated, and enriched analytical assets within **Snowflake**. 

Orchestrated via **dbt**, this project serves as a cornerstone for data-driven organizations requiring a cost-optimized, high-integrity "Single Source of Truth."

---

## 🏛️ Project Pillars

<table width="100%">
  <tr>
    <td width="33%" align="center">
      <h3>🛡️ Data Reliability</h3>
      Test-driven development (TDD) with 16+ automated integrity checks.
    </td>
    <td width="33%" align="center">
      <h3>⚡ Performance</h3>
      Incremental strategies and Snowflake-optimized SQL for sub-second builds.
    </td>
    <td width="33%" align="center">
      <h3>📖 Transparency</h3>
      Full auto-generated catalog with column-level lineage and metadata.
    </td>
  </tr>
</table>

---

## 📐 Architecture & Lineage

Our data pipeline is engineered for linear scalability, utilizing **SCD Type 2 Snapshots** for permanent historical auditability.

```mermaid
graph TD
    %% Layer Containers
    subgraph "☁️ AWS Cloud Ingestion"
        SRC1["📊 Source: Airbnb_Bookings"]
        SRC2["👤 Source: Airbnb_Hosts"]
        SRC3["🏠 Source: Airbnb_Listings"]
    end

    subgraph "🥉 Bronze Layer (Raw Ingest)"
        B1["💾 bronze_bookings"]
        B2["💾 bronze_hosts"]
        B3["💾 bronze_listings"]
    end

    subgraph "🥈 Silver Layer (Transformation)"
        SL1["✨ sliver_bookings"]
        SL2["✨ sliver_hosts"]
        SL3["✨ sliver_listings"]
    end

    subgraph "🥇 Gold Layer (Executive Reporting)"
        GOLD["🏆 OBT_Production_View"]
    end

    %% Process Connections
    SRC1 --> |S3 Ingest| B1
    SRC2 --> |S3 Ingest| B2
    SRC3 --> |S3 Ingest| B3

    B1 --> |Incremental Transform| SL1
    B2 --> |Incremental Transform| SL2
    B3 --> |Incremental Transform| SL3

    SL1 --> |Join & Optimize| GOLD
    SL2 --> |Join & Optimize| GOLD
    SL3 --> |Join & Optimize| GOLD

    %% Logic Injections
    MACRO{{"⚙️ Global Transformation Macros"}} -.-> SL1 & SL2 & SL3

    %% Styling (Elite Dark Theme)
    classDef source fill:#000,stroke:#FF9900,stroke-width:2px,color:#FF9900;
    classDef bronze fill:#000,stroke:#cd7f32,stroke-width:2px,color:#cd7f32;
    classDef silver fill:#000,stroke:#c0c0c0,stroke-width:2px,color:#c0c0c0;
    classDef gold fill:#000,stroke:#29B5E8,stroke-width:3px,color:#29B5E8,font-weight:bold;
    classDef macro fill:#000,stroke:#01579b,stroke-width:2px,color:#01579b;

    class SRC1,SRC2,SRC3 source;
    class B1,B2,B3 bronze;
    class SL1,SL2,SL3 silver;
    class GOLD gold;
    class MACRO macro;
```

---

## 🗺️ Snowflake Environment Map

Visualizing the logical structure of our Lakehouse within the **Snowflake Data Cloud**:

```mermaid
graph LR
    subgraph "❄️ Snowflake Data Warehouse"
        DB[("🗄️ AIRBNB_DB")]
        
        DB --> BRONZE_SCH["🥉 BRONZE_SCHEMA"]
        DB --> SILVER_SCH["🥈 SILVER_SCHEMA"]
        DB --> GOLD_SCH["🥇 GOLD_SCHEMA"]
        DB --> SNAP_SCH["🕒 SNAPSHOT_SCHEMA"]
    end

    BRONZE_SCH --> T1[Tables]
    SILVER_SCH --> T2[Views/Table]
    GOLD_SCH --> T3[Reporting OBT]
    SNAP_SCH --> T4[SCD2 Records]

    %% Styling
    classDef db fill:#1a1a1a,stroke:#29B5E8,stroke-width:4px,color:#fff;
    classDef schema fill:#000,stroke:#fff,stroke-width:2px,color:#fff;
    
    class DB db;
    class BRONZE_SCH,SILVER_SCH,GOLD_SCH,SNAP_SCH schema;
```

---

## 🔄 Data Lifecycle & Journey

The journey of a single record from arrival to decision:

```mermaid
sequenceDiagram
    participant AWS as ☁️ AWS S3
    participant BRONZE as 🥉 Bronze (Raw)
    participant SNAP as 🕒 Snapshot (SCD2)
    participant SILVER as 🥈 Silver (Logic)
    participant GOLD as 🥇 Gold (OBT)

    Note over AWS, BRONZE: Incremental Ingestion
    AWS ->> BRONZE: Ingest New Raw Data
    BRONZE ->> SNAP: Update History (if status changed)
    BRONZE ->> SILVER: Request Cleansing
    Note right of SILVER: Apply Macros (Trimmer/Tag/Multiply)
    SILVER ->> GOLD: Denormalize & Optimize
    Note over GOLD: Production Ready Data
```

---

## 📋 Data Governance Matrix

| Layer | Governance Strategy | PII Handling | Objective |
| :--- | :--- | :--- | :--- |
| **🥉 Bronze** | Schema Enforcement | Raw Storage | Auditability |
| **🥈 Silver** | Normalization & Macros | Anonymized Names | Business Logic |
| **🥇 Gold** | Aggregation & Join | Summary Only | Executive Reporting |

---

## 🛠️ Infrastructure Specifications

*   **Logic Orchestration**: dbt-core v1.11.2 (Latest Stable)
*   **Storage Tier**: AWS S3 (Staging Lake)
*   **Compute Tier**: Snowflake (Vectorized Execution Engine)
*   **Quality Gates**: 16+ Automated Unit & Schema Assertions
*   **Lineage Tracking**: SCD Type 2 Snapshots for permanent state history

---

## 🚀 Standard Operating Procedures (SOPs)

### Deployment Cycle
```powershell
# 1. Pipeline Synchronization
.venv\Scripts\Activate.ps1
dbt deps

# 2. Production Build Execution
dbt build --select +gold
```

---

## 🤝 Conclusion & Contact
This architecture represents the culmination of principled data engineering. It is designed for scale, built for reliability, and optimized for performance.

**"Data is the foundation; dbt is the masterpiece."** 🏔️✨

---
*Developed and Curated by **[Qayas Mehtab](https://github.com/qayasmehtab)** • [LinkedIn](https://www.linkedin.com/in/qayas-mehtab-6b834423b/)*
