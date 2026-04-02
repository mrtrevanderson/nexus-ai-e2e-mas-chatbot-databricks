# 01 — Data Setup

## Files in this folder

| File | Description |
|---|---|
| `01_create_delta_tables.sql` | Creates all 11 Delta tables from CSV volume files |
| `sample_data/` | Source CSV files (upload to your Databricks volume) |
| `knowledge_docs/` | 7 PDF documents for the Knowledge Assistant |

## Sample Data — Operations Tables (100 rows each)

| File | Table | Agent |
|---|---|---|
| `product_research.csv` | `product_research` | Product Research Agent |
| `inventory_management.csv` | `inventory_management` | Inventory Management Agent |
| `pricing_promotions.csv` | `pricing_promotions` | Pricing & Promotions Agent |
| `marketing_copy.csv` | `marketing_copy` | Marketing Copy Agent |
| `customer_support.csv` | `customer_support` | Customer Support Agent |
| `order_fulfillment.csv` | `order_fulfillment` | Order Fulfillment Agent |

## Sample Data — Website Behavioral Tables (500 rows each)

| File | Table | Agent |
|---|---|---|
| `web_sessions.csv` | `web_sessions` | Website Performance Agent |
| `product_page_interactions.csv` | `product_page_interactions` | Website Performance Agent |
| `checkout_funnel.csv` | `checkout_funnel` | Website Performance Agent |
| `site_search_queries.csv` | `site_search_queries` | Website Performance Agent |
| `campaign_attribution.csv` | `campaign_attribution` | Website Performance Agent |

## Knowledge Documents (upload to volume /docs/ subfolder)

| File | Agent |
|---|---|
| `01_ergo_product_spec_sheets.pdf` | Knowledge Assistant |
| `02_ergo_assembly_setup_guide.pdf` | Knowledge Assistant |
| `03_ergo_warranty_returns_policy.pdf` | Knowledge Assistant |
| `04_ergo_pricing_promotions_playbook.pdf` | Knowledge Assistant |
| `05_ergo_customer_support_faq.pdf` | Knowledge Assistant |
| `06_ergo_sales_enablement.pdf` | Knowledge Assistant |
| `07_ergo_fulfillment_shipping_sop.pdf` | Knowledge Assistant |

## Setup Steps

1. Upload all CSVs to:
   `/Volumes/s3/hma_prod/hma_data_storage_prod/sandbox/ergo_launch_sample/`

2. Upload all PDFs to:
   `/Volumes/s3/hma_prod/hma_data_storage_prod/sandbox/ergo_launch_sample/docs/`

3. Open a SQL notebook in Databricks and run `01_create_delta_tables.sql`

4. Verify the final query returns 11 rows with expected counts

## Data Schema — Key Join Keys

All operational tables join on `sku` (values: `EP-200`, `EP-500`, `EP-900`)
All website tables join on `session_id` and/or `user_id`
Cross-domain joins: use `sku` to bridge operational and website tables
