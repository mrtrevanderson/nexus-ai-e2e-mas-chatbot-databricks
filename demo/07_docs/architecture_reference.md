# ErgoPro — Architecture Reference

## System Overview

The ErgoPro multi-agent supervisor is a demonstration of the Databricks
Agent Bricks Supervisor Agent pattern applied to an e-commerce go-to-market
use case. It shows how a single orchestration layer can coordinate multiple
specialized agents across structured data, unstructured documents, and
live web search to answer complex business questions.

---

## Agent Types Used

### Genie Spaces (7 agents)
Databricks AI/BI Genie converts natural language questions into SQL queries
against Unity Catalog tables. Each Genie space is scoped to a specific domain
and table set to ensure focused, accurate responses.

Best for: Structured data analytics, aggregations, trend analysis, comparisons.

### Knowledge Assistant (1 agent)
Agent Bricks Knowledge Assistant uses Instructed Retrieval (not traditional RAG)
to answer questions from unstructured documents with page-level citations.
Achieves up to 70% higher answer quality than simplistic RAG approaches.

Best for: Policy questions, product specs, SOPs, documentation lookups.

### MCP Web Search (1 agent)
You.com connected via the Model Context Protocol (MCP) provides real-time
web search capabilities for competitive intelligence and market trends.

Best for: Live competitor data, recent news, consumer sentiment, market events.

---

## Data Architecture

### Unity Catalog Location
- Catalog: `ius_unity_prod`
- Schema: `sandbox`
- Volume: `/Volumes/s3/hma_prod/hma_data_storage_prod/sandbox/ergo_launch_sample/`

### Delta Tables — Operations (100 rows each)

| Table | Primary Key | Description |
|---|---|---|
| `product_research` | research_id | Competitor product catalog |
| `inventory_management` | inventory_id | Per-SKU per-warehouse stock |
| `pricing_promotions` | promo_id | Historical promo performance |
| `marketing_copy` | copy_id | Copy assets and performance |
| `customer_support` | ticket_id | Support ticket history |
| `order_fulfillment` | order_id | Order and shipping records |

### Delta Tables — Website Behavioral (500 rows each)

| Table | Primary Key | Description |
|---|---|---|
| `web_sessions` | session_id | Session-level traffic data |
| `product_page_interactions` | event_id | Product page behavior events |
| `checkout_funnel` | funnel_id | Funnel progression per session |
| `site_search_queries` | search_id | On-site search log |
| `campaign_attribution` | attribution_id | UTM campaign performance |

### Cross-Table Join Keys

```
SKU (EP-200, EP-500, EP-900)
  └── Joins all 6 operations tables

session_id
  └── Joins web_sessions, product_page_interactions,
      checkout_funnel, site_search_queries, campaign_attribution

user_id
  └── Secondary join across web_sessions, campaign_attribution,
      site_search_queries, checkout_funnel
```

### Knowledge Documents (7 PDFs)

| Document | Key Content |
|---|---|
| Product Spec Sheets | Dimensions, materials, adjustments, certifications |
| Assembly & Setup Guide | Build instructions, ergonomic setup, floor types |
| Warranty & Returns Policy | Coverage by component, claim process, refund timeline |
| Pricing & Promotions Playbook | MSRP/MAP/floor, discount authority, promo calendar |
| Customer Support FAQ | 15 Q&As, escalation guide |
| Sales Enablement Guide | Pitch scripts, competitive matrix, objection handling |
| Fulfillment & Shipping SOP | Carrier routing, packaging, returns processing, SLAs |

---

## Supervisor Routing Logic

```
Incoming question
       │
       ▼
Is it about real-time external info?
  YES → You.com Web Search
  NO  ↓
Is it about internal policies, specs, or SOPs?
  YES → Knowledge Assistant
  NO  ↓
Is it about website/digital behavior?
  YES → Website Performance Agent
  NO  ↓
Is it about orders and shipping?
  YES → Order Fulfillment Agent
  NO  ↓
Is it about pricing or promotions?
  YES → Pricing & Promotions Agent
  NO  ↓
Is it about inventory?
  YES → Inventory Management Agent
  NO  ↓
Is it about customer issues?
  YES → Customer Support Agent
  NO  ↓
Is it about copy performance?
  YES → Marketing Copy Agent
  NO  ↓
Is it about competitors or market trends?
  YES → Product Research Agent
```

For multi-domain questions, the supervisor delegates to all relevant agents
in parallel and synthesizes results into a single response.

---

## Key Design Decisions

**Why separate Genie spaces per domain?**
A single Genie space with all 11 tables would work but would produce less
accurate results. Specialized spaces with domain-specific instructions and
example queries significantly outperform general-purpose spaces.

**Why Knowledge Assistant instead of another Genie space for docs?**
Genie is optimized for structured tabular data. Knowledge Assistant uses
Instructed Retrieval which is purpose-built for unstructured documents and
returns page-level citations — critical for policy and spec questions.

**Why MCP for web search instead of a Unity Catalog function?**
MCP is the native integration path in Agent Bricks and provides better
governance through Unity Catalog. A UC function alternative is documented
in the setup guide for environments where MCP isn't available.

**Why synthetic data instead of real data?**
This is a portfolio demo. Synthetic data allows realistic demonstration
of the architecture without exposing any real business or customer data.
The data generation scripts are included so the dataset can be regenerated
or scaled to larger volumes.

---

## Extending This Architecture

**Add more agents:**
Each new domain (e.g. email marketing, ad performance, HR data) follows
the same pattern: create a Delta table, add a Genie space, add it to the
supervisor's Description with clear delegation triggers.

**Scale the data:**
Edit the `gen_data.py` and `gen_web_data.py` scripts and change the row
count parameter. The schema is stable — larger datasets will work without
any changes to the agent configurations.

**Connect to real data:**
Replace the synthetic CSV files with your actual data sources. As long as
the table names and column names match what's referenced in the Genie
space instructions and example SQL, the agents will work without changes.

**Add a Databricks App front-end:**
The Supervisor Agent endpoint can be integrated into a Databricks App
using the Genie API conversation endpoint. See Databricks documentation
on `POST /api/2.0/genie/spaces/{space_id}/start-conversation`.
