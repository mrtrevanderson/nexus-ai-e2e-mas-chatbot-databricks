# ErgoPro — Delta Table Creation
# Run this notebook in Databricks (DBR 13.3+, SQL or Python cluster)
# Catalog: ius_unity_prod | Schema: sandbox
# Volume:  /Volumes/s3/hma_prod/hma_data_storage_prod/sandbox/ergo_launch_sample/

# ── STEP 1: Set catalog and schema ───────────────────────────────────────────

USE CATALOG ius_unity_prod;
USE SCHEMA sandbox;

# ── STEP 2: Create operations tables (100 rows each) ─────────────────────────

CREATE OR REPLACE TABLE product_research USING DELTA AS
SELECT * FROM read_files(
  '/Volumes/s3/hma_prod/hma_data_storage_prod/sandbox/ergo_launch_sample/product_research.csv',
  format => 'csv', header => 'true', inferSchema => 'true'
);

CREATE OR REPLACE TABLE inventory_management USING DELTA AS
SELECT * FROM read_files(
  '/Volumes/s3/hma_prod/hma_data_storage_prod/sandbox/ergo_launch_sample/inventory_management.csv',
  format => 'csv', header => 'true', inferSchema => 'true'
);

CREATE OR REPLACE TABLE pricing_promotions USING DELTA AS
SELECT * FROM read_files(
  '/Volumes/s3/hma_prod/hma_data_storage_prod/sandbox/ergo_launch_sample/pricing_promotions.csv',
  format => 'csv', header => 'true', inferSchema => 'true'
);

CREATE OR REPLACE TABLE marketing_copy USING DELTA AS
SELECT * FROM read_files(
  '/Volumes/s3/hma_prod/hma_data_storage_prod/sandbox/ergo_launch_sample/marketing_copy.csv',
  format => 'csv', header => 'true', inferSchema => 'true'
);

CREATE OR REPLACE TABLE customer_support USING DELTA AS
SELECT * FROM read_files(
  '/Volumes/s3/hma_prod/hma_data_storage_prod/sandbox/ergo_launch_sample/customer_support.csv',
  format => 'csv', header => 'true', inferSchema => 'true'
);

CREATE OR REPLACE TABLE order_fulfillment USING DELTA AS
SELECT * FROM read_files(
  '/Volumes/s3/hma_prod/hma_data_storage_prod/sandbox/ergo_launch_sample/order_fulfillment.csv',
  format => 'csv', header => 'true', inferSchema => 'true'
);

# ── STEP 3: Create website behavioral tables (500 rows each) ─────────────────

CREATE OR REPLACE TABLE web_sessions USING DELTA AS
SELECT * FROM read_files(
  '/Volumes/s3/hma_prod/hma_data_storage_prod/sandbox/ergo_launch_sample/web_sessions.csv',
  format => 'csv', header => 'true', inferSchema => 'true'
);

CREATE OR REPLACE TABLE product_page_interactions USING DELTA AS
SELECT * FROM read_files(
  '/Volumes/s3/hma_prod/hma_data_storage_prod/sandbox/ergo_launch_sample/product_page_interactions.csv',
  format => 'csv', header => 'true', inferSchema => 'true'
);

CREATE OR REPLACE TABLE checkout_funnel USING DELTA AS
SELECT * FROM read_files(
  '/Volumes/s3/hma_prod/hma_data_storage_prod/sandbox/ergo_launch_sample/checkout_funnel.csv',
  format => 'csv', header => 'true', inferSchema => 'true'
);

CREATE OR REPLACE TABLE site_search_queries USING DELTA AS
SELECT * FROM read_files(
  '/Volumes/s3/hma_prod/hma_data_storage_prod/sandbox/ergo_launch_sample/site_search_queries.csv',
  format => 'csv', header => 'true', inferSchema => 'true'
);

CREATE OR REPLACE TABLE campaign_attribution USING DELTA AS
SELECT * FROM read_files(
  '/Volumes/s3/hma_prod/hma_data_storage_prod/sandbox/ergo_launch_sample/campaign_attribution.csv',
  format => 'csv', header => 'true', inferSchema => 'true'
);

# ── STEP 4: Add table comments (improves Genie accuracy significantly) ────────

COMMENT ON TABLE ius_unity_prod.sandbox.product_research IS
  'Competitor product catalog for ergonomic office chair market analysis.
   Contains pricing, ratings, features, and YoY growth by brand and category.
   Join key: sku (EP-200, EP-500, EP-900) for ErgoPro SKUs only.';

COMMENT ON TABLE ius_unity_prod.sandbox.inventory_management IS
  'Per-SKU per-warehouse inventory snapshot for ErgoPro chairs.
   Includes stock levels, velocity, reorder points, lead times, and bin locations.
   Join key: sku. Warehouses: WH-LAX, WH-DFW, WH-ORD, WH-ATL, WH-JFK.';

COMMENT ON TABLE ius_unity_prod.sandbox.pricing_promotions IS
  'Historical promotional campaigns for ErgoPro SKUs.
   Contains base vs promo price, discount type, units sold, margin,
   elasticity score, and ROI by channel. Join key: sku.';

COMMENT ON TABLE ius_unity_prod.sandbox.marketing_copy IS
  'Marketing copy assets for ErgoPro SKUs across formats and channels.
   Tracks CTR, CVR, engagement score, A/B variants, and approval status.
   Join key: sku.';

COMMENT ON TABLE ius_unity_prod.sandbox.customer_support IS
  'Support ticket history for ErgoPro products.
   Includes issue type, resolution, CSAT score, escalation flag,
   first response time, and sentiment score. Join key: sku.';

COMMENT ON TABLE ius_unity_prod.sandbox.order_fulfillment IS
  'Order and fulfillment records for ErgoPro SKUs.
   Tracks carrier, warehouse, ship/delivery dates, on-time performance,
   shipping cost, and returns by region. Join key: sku, order_id.';

COMMENT ON TABLE ius_unity_prod.sandbox.web_sessions IS
  'Website session data for ergochair.com.
   Contains session-level traffic metrics including device, browser, region,
   channel, bounce rate, session duration, and conversion flag.
   Join key: session_id, user_id.';

COMMENT ON TABLE ius_unity_prod.sandbox.product_page_interactions IS
  'User interaction events on ErgoPro product detail pages.
   Tracks scroll depth, time on page, images viewed, interaction type,
   and whether session led to cart or purchase. Join key: session_id, sku.';

COMMENT ON TABLE ius_unity_prod.sandbox.checkout_funnel IS
  'Checkout funnel progression per session and SKU.
   Tracks funnel stages, abandonment reason, promo codes, discount,
   final order total, and payment method. Join key: session_id, sku.';

COMMENT ON TABLE ius_unity_prod.sandbox.site_search_queries IS
  'On-site search query log for ergochair.com.
   Contains search terms, results count, click-through, refinements,
   zero-result queries, and whether search led to purchase.
   Join key: session_id.';

COMMENT ON TABLE ius_unity_prod.sandbox.campaign_attribution IS
  'Marketing campaign attribution with UTM parameters.
   Contains channel, source, medium, campaign, ROAS, CPC, CTR,
   impression share, and attribution model per session.
   Join key: session_id, user_id.';

# ── STEP 5: Verify all 11 tables ─────────────────────────────────────────────

SELECT 'product_research'          AS table_name, COUNT(*) AS row_count FROM ius_unity_prod.sandbox.product_research          UNION ALL
SELECT 'inventory_management',                     COUNT(*)              FROM ius_unity_prod.sandbox.inventory_management       UNION ALL
SELECT 'pricing_promotions',                       COUNT(*)              FROM ius_unity_prod.sandbox.pricing_promotions         UNION ALL
SELECT 'marketing_copy',                           COUNT(*)              FROM ius_unity_prod.sandbox.marketing_copy             UNION ALL
SELECT 'customer_support',                         COUNT(*)              FROM ius_unity_prod.sandbox.customer_support           UNION ALL
SELECT 'order_fulfillment',                        COUNT(*)              FROM ius_unity_prod.sandbox.order_fulfillment          UNION ALL
SELECT 'web_sessions',                             COUNT(*)              FROM ius_unity_prod.sandbox.web_sessions               UNION ALL
SELECT 'product_page_interactions',                COUNT(*)              FROM ius_unity_prod.sandbox.product_page_interactions  UNION ALL
SELECT 'checkout_funnel',                          COUNT(*)              FROM ius_unity_prod.sandbox.checkout_funnel            UNION ALL
SELECT 'site_search_queries',                      COUNT(*)              FROM ius_unity_prod.sandbox.site_search_queries        UNION ALL
SELECT 'campaign_attribution',                     COUNT(*)              FROM ius_unity_prod.sandbox.campaign_attribution
ORDER BY table_name;

-- Expected: 6 tables × 100 rows + 5 tables × 500 rows = 3,100 total rows
