# ErgoPro Multi-Agent Supervisor — Setup Guide

## Prerequisites

Before starting, confirm the following in your Databricks workspace:

- [ ] Unity Catalog enabled
- [ ] Serverless compute available
- [ ] Access to Mosaic AI Model Serving
- [ ] Agent Bricks preview enabled (Supervisor Agent + Knowledge Assistant)
- [ ] `databricks-gte-large-en` embedding endpoint has AI Guardrails disabled
- [ ] You.com MCP server integrated (or substitute Tavily/Brave from Marketplace)
- [ ] Pro or Serverless SQL warehouse available for Genie spaces
- [ ] SELECT privileges on `ius_unity_prod.sandbox.*`

---

## Step 1 — Upload Sample Data

Upload all CSV files to your Databricks volume:
```
/Volumes/s3/hma_prod/hma_data_storage_prod/sandbox/ergo_launch_sample/
```

Upload all PDF knowledge documents to the `/docs/` subfolder:
```
/Volumes/s3/hma_prod/hma_data_storage_prod/sandbox/ergo_launch_sample/docs/
```

Files needed:
- 6 operations CSVs (100 rows each) — from `01_data_setup/sample_data/`
- 5 website CSVs (500 rows each) — from `01_data_setup/sample_data/`
- 7 PDF knowledge documents — from `01_data_setup/knowledge_docs/`

---

## Step 2 — Create Delta Tables

Open a SQL notebook in Databricks and run:
```
01_data_setup/01_create_delta_tables.sql
```

This will:
- Create all 11 Delta tables from the CSV volume files
- Add descriptive comments to every table (critical for Genie accuracy)
- Run a verification query confirming all tables have expected row counts

Expected output:
```
campaign_attribution        500
checkout_funnel             500
customer_support            100
inventory_management        100
marketing_copy              100
order_fulfillment           100
pricing_promotions          100
product_page_interactions   500
product_research            100
site_search_queries         500
web_sessions                500
```

---

## Step 3 — Create the 7 Genie Spaces (Subagents 1–7)

For each agent, navigate to **Genie → New** and follow the config in
`02_subagent_config/subagent_configurations.yaml`.

Order of creation (recommended):

### 3a. Product Research Agent
- Table: `ius_unity_prod.sandbox.product_research`
- Copy general_instructions from config
- Add all 5 example SQL queries
- Test: "Which competitor brand has the highest average rating?"

### 3b. Inventory Management Agent
- Table: `ius_unity_prod.sandbox.inventory_management`
- Copy general_instructions from config
- Add all 5 example SQL queries
- Test: "Which SKU is most at risk of stockout?"

### 3c. Pricing & Promotions Agent
- Table: `ius_unity_prod.sandbox.pricing_promotions`
- Copy general_instructions from config
- Add all 5 example SQL queries
- Test: "Which promo type has the highest ROI?"

### 3d. Marketing Copy Agent
- Table: `ius_unity_prod.sandbox.marketing_copy`
- Copy general_instructions from config
- Add all 5 example SQL queries
- Test: "Which headline has the best CTR on paid search?"

### 3e. Customer Support Agent
- Table: `ius_unity_prod.sandbox.customer_support`
- Copy general_instructions from config
- Add all 5 example SQL queries
- Test: "What are the top support issues for EP-900?"

### 3f. Order Fulfillment Agent
- Table: `ius_unity_prod.sandbox.order_fulfillment`
- Copy general_instructions from config
- Add all 5 example SQL queries
- Test: "What is our on-time delivery rate for FedEx Freight?"

### 3g. Website Performance Agent
- Tables: all 5 web tables
- Copy general_instructions from config
- Add all 10 example SQL queries
- Test: "Which channel drives the highest conversion rate?"

---

## Step 4 — Create the Knowledge Assistant (Subagent 8)

Navigate to **Agents → Knowledge Assistant → Build**

1. Name: `ErgoPro Knowledge Assistant`
2. Under Knowledge Source → Type: **UC Files**
3. Source path:
   `/Volumes/s3/hma_prod/hma_data_storage_prod/sandbox/ergo_launch_sample/docs/`
4. Paste the `knowledge_source_description` from the config file
5. Save and wait for ingestion to complete (2–5 minutes for 7 PDFs)
6. Test with each question in the `test_questions` list from the config
7. Verify citations appear for every response

---

## Step 5 — Verify You.com MCP (Subagent 9)

Navigate to **Agents → MCP Servers**

Confirm your You.com connection shows as active. If not integrated yet,
alternatives from the Databricks Marketplace:
- Tavily MCP (recommended — purpose-built for AI agents)
- Brave Search MCP (privacy-focused alternative)

For a Unity Catalog function approach instead:
```sql
CREATE OR REPLACE FUNCTION ius_unity_prod.sandbox.web_search(
  query STRING COMMENT 'Search query to run against the web'
)
RETURNS STRING
COMMENT 'Searches the web and returns top results. Use for competitor news,
market trends, and real-time information not in internal tables.'
LANGUAGE PYTHON
AS $$
  import urllib.request, json, os
  api_key = os.environ.get("SEARCH_API_KEY", "")
  payload = json.dumps({"api_key": api_key, "query": query,
                        "search_depth": "advanced", "max_results": 5}).encode()
  req = urllib.request.Request("https://api.tavily.com/search", data=payload,
        headers={"Content-Type": "application/json"})
  with urllib.request.urlopen(req) as resp:
      data = json.loads(resp.read())
  results = data.get("results", [])
  return json.dumps([{"title": r["title"], "url": r["url"],
                      "content": r["content"][:500]} for r in results])
$$;
```

---

## Step 6 — Create the Supervisor Agent

Navigate to **Agents → Supervisor Agent → Build**

1. **Name:** `ErgoPro Launch Supervisor`
2. **Description:** Copy from `03_supervisor_config/supervisor_configuration.yaml`
3. **Instructions:** Copy from `03_supervisor_config/supervisor_configuration.yaml`
4. **Subagents:** Add all 7 Genie spaces + Knowledge Assistant endpoint
5. **MCP Tools:** Add You.com (or your web search tool)
6. **Benchmarks:** Add questions from the `benchmarks` section of the config

Save and open in AI Playground to test.

---

## Step 7 — Test the Supervisor

Start with single-agent prompts from `04_sample_prompts/sample_prompts.yaml`
to validate each subagent is routing correctly, then move to multi-agent prompts.

**Recommended test sequence:**

1. Single-agent: "Which SKU has the lowest inventory?" → Inventory Agent
2. Single-agent: "What does our EP-900 warranty cover?" → Knowledge Assistant
3. Single-agent: "What is Herman Miller doing on pricing?" → Web Search
4. Multi-agent: "Are we ready to launch EP-900 next month?"
5. Full demo: "Give me a complete ErgoPro launch readiness report."

---

## Troubleshooting

| Issue | Fix |
|---|---|
| Genie returns wrong results | Add more example SQL queries; check table comments |
| Knowledge Assistant not citing | Verify PDF ingestion completed; re-test with simpler question |
| Supervisor routes to wrong agent | Refine delegation triggers in Description field |
| Web search not activating | Check MCP server connection status in Agents → MCP Servers |
| Genie space SQL errors | Run example queries manually in a SQL notebook first |
| Knowledge Assistant slow | Normal for first few queries — model warms up after ~3 requests |

---

## Architecture Diagram

```
User Question
     │
     ▼
┌─────────────────────────────────┐
│     ErgoPro Launch Supervisor   │
│     (Agent Bricks Supervisor)   │
└──────────────┬──────────────────┘
               │ parallel delegation
    ┌──────────┼──────────────────────────┐
    │          │          │               │
    ▼          ▼          ▼               ▼
┌───────┐ ┌───────┐ ┌─────────┐    ┌──────────┐
│Genie  │ │Genie  │ │Knowledge│    │ You.com  │
│Spaces │ │Spaces │ │Assistant│    │   MCP    │
│(x7)   │ │(x7)   │ │  (x1)  │    │   (x1)   │
└───────┘ └───────┘ └─────────┘    └──────────┘
    │                    │
    ▼                    ▼
Delta Tables           PDF Docs
(Unity Catalog)      (UC Volume)
               │
               ▼
    Synthesized Response
```
