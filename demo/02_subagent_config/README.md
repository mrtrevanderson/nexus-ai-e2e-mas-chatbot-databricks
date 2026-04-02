# 02 — Subagent Configuration

## Overview

9 subagents power the ErgoPro supervisor system:

| # | Agent | Type | Data Source |
|---|---|---|---|
| 1 | Product Research | Genie Space | `product_research` |
| 2 | Inventory Management | Genie Space | `inventory_management` |
| 3 | Pricing & Promotions | Genie Space | `pricing_promotions` |
| 4 | Marketing Copy | Genie Space | `marketing_copy` |
| 5 | Customer Support | Genie Space | `customer_support` |
| 6 | Order Fulfillment | Genie Space | `order_fulfillment` |
| 7 | Website Performance | Genie Space | 5 web tables |
| 8 | Knowledge Assistant | Agent Bricks KA | 7 PDFs |
| 9 | Web Search | You.com MCP | Live web |

## Creating Genie Spaces (Agents 1–7)

1. Go to **Genie → New** in the Databricks sidebar
2. Add the table(s) listed in `subagent_configurations.yaml`
3. Copy the `general_instructions` text into **Configure → Instructions → Text**
4. Add each SQL query under **Configure → Instructions → SQL Queries**
5. Run each example query manually to validate it returns results before saving

## Creating the Knowledge Assistant (Agent 8)

1. Go to **Agents → Knowledge Assistant → Build**
2. Set Name and Description from the config file
3. Under Knowledge Source: select **UC Files**
4. Point to the `/docs/` subfolder in your volume
5. Paste the `knowledge_source_description` into the content description field
6. Test with the provided `test_questions` — verify citations appear

## Adding You.com Web Search (Agent 9)

1. Go to **Agents → MCP Servers**
2. Locate your You.com MCP connection
3. Confirm it is active — no additional config needed
4. It will be added to the Supervisor as a tool, not a standalone agent

## Quality Tips

- Always add table comments via SQL before configuring Genie spaces
- Run all example SQL queries manually before adding them to Genie
- For the Knowledge Assistant, test every PDF with at least one question
- The more specific your `general_instructions`, the better Genie routes
