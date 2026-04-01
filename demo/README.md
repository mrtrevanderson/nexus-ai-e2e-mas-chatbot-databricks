# ErgoPro Multi-Agent Supervisor — Databricks Demo

A production-style multi-agent AI application built on Databricks Agent Bricks,
showcasing supervisor-based orchestration across 9 specialized subagents for an
e-commerce go-to-market use case.

## Architecture Overview

```
                        ┌─────────────────────────┐
                        │   ErgoPro Launch        │
                        │   Supervisor Agent      │
                        └────────────┬────────────┘
                                     │ delegates
          ┌──────────────────────────┼──────────────────────────┐
          │              │           │          │                │
    ┌─────▼────┐  ┌──────▼───┐ ┌────▼─────┐ ┌─▼────────┐ ┌────▼─────┐
    │ Product  │  │Inventory │ │ Pricing  │ │Marketing │ │Customer  │
    │ Research │  │  Mgmt    │ │ & Promos │ │  Copy    │ │ Support  │
    └──────────┘  └──────────┘ └──────────┘ └──────────┘ └──────────┘
          │              │           │          │                │
    ┌─────▼────┐  ┌──────▼───┐ ┌────▼─────┐ ┌─▼────────┐
    │  Order   │  │ Website  │ │Knowledge │ │ You.com  │
    │Fulfillmt │  │ Perf.    │ │Assistant │ │Web Search│
    └──────────┘  └──────────┘ └──────────┘ └──────────┘
```

## Folder Structure

```
ergo_repo/
├── README.md                        ← You are here
├── 01_data_setup/                   ← Delta table creation & sample data
├── 02_subagent_config/              ← All 9 subagent configurations
├── 03_supervisor_config/            ← Supervisor description & instructions
├── 04_sample_prompts/               ← Test & demo prompts
├── 05_marketing/                    ← LinkedIn content & demo walkthrough
├── 06_branding/                     ← Brand guidelines & naming
└── 07_docs/                         ← Architecture & setup documentation
```

## Tech Stack

- **Platform:** Databricks (Unity Catalog, Agent Bricks, Genie, Model Serving)
- **Agent types:** Genie Spaces (7), Knowledge Assistant (1), MCP Web Search (1)
- **Data:** 11 Delta tables + 7 PDF knowledge documents
- **Web search:** You.com MCP integration
- **Catalog:** `ius_unity_prod` | **Schema:** `sandbox`

## Quick Start

1. Follow `07_docs/setup_guide.md` for environment prerequisites
2. Run `01_data_setup/01_create_delta_tables.sql` to load all tables
3. Configure subagents using guides in `02_subagent_config/`
4. Set up the Supervisor using `03_supervisor_config/`
5. Test with prompts in `04_sample_prompts/`

## Sample Data

| Dataset | Tables | Rows |
|---|---|---|
| E-commerce operations | 6 tables | 100 rows each |
| Website behavioral | 5 tables | 500 rows each |
| Knowledge documents | 7 PDFs | 3–5 pages each |

## Contact

Built as a LinkedIn portfolio demo showcasing Databricks multi-agent architecture.
