/*
SALES PIPELINE REVENUE ANALYSIS
MySQL Portfolio Project

Table: sales_pipeline
Columns:
opportunity_id, sales_agent, product, account, deal_stage,
engage_date, close_date, close_value

Purpose:
Analyze sales opportunities, revenue, win rate, deal stages,
products, sales agents, accounts, and sales-cycle performance.
*/

-- =========================================================
-- 1. DATA VALIDATION
-- =========================================================

-- Total opportunities
SELECT COUNT(*) AS total_opportunities
FROM sales_pipeline;

-- Deal-stage distribution
SELECT deal_stage, COUNT(*) AS opportunity_count
FROM sales_pipeline
GROUP BY deal_stage
ORDER BY opportunity_count DESC;

-- Duplicate opportunity IDs
SELECT opportunity_id, COUNT(*) AS duplicate_count
FROM sales_pipeline
GROUP BY opportunity_id
HAVING COUNT(*) > 1;

-- Missing-value check
SELECT
    SUM(CASE WHEN opportunity_id IS NULL OR TRIM(opportunity_id) = '' THEN 1 ELSE 0 END) AS missing_opportunity_id,
    SUM(CASE WHEN sales_agent IS NULL OR TRIM(sales_agent) = '' THEN 1 ELSE 0 END) AS missing_sales_agent,
    SUM(CASE WHEN product IS NULL OR TRIM(product) = '' THEN 1 ELSE 0 END) AS missing_product,
    SUM(CASE WHEN account IS NULL OR TRIM(account) = '' THEN 1 ELSE 0 END) AS missing_account,
    SUM(CASE WHEN deal_stage IS NULL OR TRIM(deal_stage) = '' THEN 1 ELSE 0 END) AS missing_deal_stage,
    SUM(CASE WHEN engage_date IS NULL OR TRIM(engage_date) = '' THEN 1 ELSE 0 END) AS missing_engage_date,
    SUM(CASE WHEN close_date IS NULL OR TRIM(close_date) = '' THEN 1 ELSE 0 END) AS missing_close_date,
    SUM(CASE WHEN close_value IS NULL OR TRIM(close_value) = '' THEN 1 ELSE 0 END) AS missing_close_value
FROM sales_pipeline;


-- =========================================================
-- 2. CORE BUSINESS KPIs
-- =========================================================

-- Won opportunities
SELECT COUNT(*) AS won_opportunities
FROM sales_pipeline
WHERE deal_stage = 'Won';

-- Lost opportunities
SELECT COUNT(*) AS lost_opportunities
FROM sales_pipeline
WHERE deal_stage = 'Lost';

-- Win rate among closed opportunities
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN deal_stage IN ('Won','Lost') THEN 1 ELSE 0 END), 0),
        2
    ) AS win_rate_percent
FROM sales_pipeline;

-- Total revenue from Won deals
SELECT
    ROUND(SUM(
        CASE WHEN deal_stage = 'Won'
        THEN CAST(NULLIF(TRIM(close_value), '') AS DECIMAL(15,2))
        ELSE 0 END
    ), 2) AS total_revenue
FROM sales_pipeline;

-- Average Won deal value
SELECT
    ROUND(AVG(
        CASE WHEN deal_stage = 'Won'
        THEN CAST(NULLIF(TRIM(close_value), '') AS DECIMAL(15,2))
        END
    ), 2) AS average_won_deal_value
FROM sales_pipeline;


-- =========================================================
-- 3. PRODUCT ANALYSIS
-- =========================================================

-- Revenue and average deal value by product
SELECT
    product,
    COUNT(*) AS won_deals,
    ROUND(SUM(CAST(NULLIF(TRIM(close_value), '') AS DECIMAL(15,2))), 2) AS total_revenue,
    ROUND(AVG(CAST(NULLIF(TRIM(close_value), '') AS DECIMAL(15,2))), 2) AS average_deal_value
FROM sales_pipeline
WHERE deal_stage = 'Won'
GROUP BY product
ORDER BY total_revenue DESC;

-- Product with highest average deal value
SELECT
    product,
    ROUND(AVG(CAST(NULLIF(TRIM(close_value), '') AS DECIMAL(15,2))), 2) AS average_deal_value
FROM sales_pipeline
WHERE deal_stage = 'Won'
GROUP BY product
ORDER BY average_deal_value DESC
LIMIT 1;


-- =========================================================
-- 4. SALES AGENT ANALYSIS
-- =========================================================

-- Agent performance
SELECT
    sales_agent,
    COUNT(*) AS total_opportunities,
    SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_opportunities,
    SUM(CASE WHEN deal_stage = 'Lost' THEN 1 ELSE 0 END) AS lost_opportunities,
    ROUND(
        100.0 * SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN deal_stage IN ('Won','Lost') THEN 1 ELSE 0 END), 0),
        2
    ) AS win_rate_percent
FROM sales_pipeline
GROUP BY sales_agent
ORDER BY win_rate_percent DESC;

-- Top agents by revenue
SELECT
    sales_agent,
    COUNT(*) AS won_deals,
    ROUND(SUM(CAST(NULLIF(TRIM(close_value), '') AS DECIMAL(15,2))), 2) AS total_revenue
FROM sales_pipeline
WHERE deal_stage = 'Won'
GROUP BY sales_agent
ORDER BY total_revenue DESC
LIMIT 10;


-- =========================================================
-- 5. ACCOUNT ANALYSIS
-- =========================================================

SELECT
    account,
    COUNT(*) AS won_deals,
    ROUND(SUM(CAST(NULLIF(TRIM(close_value), '') AS DECIMAL(15,2))), 2) AS total_revenue,
    ROUND(AVG(CAST(NULLIF(TRIM(close_value), '') AS DECIMAL(15,2))), 2) AS average_deal_value
FROM sales_pipeline
WHERE deal_stage = 'Won'
GROUP BY account
ORDER BY total_revenue DESC
LIMIT 10;


-- =========================================================
-- 6. DEAL-STAGE / PIPELINE ANALYSIS
-- =========================================================

SELECT
    deal_stage,
    COUNT(*) AS opportunity_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM sales_pipeline), 2) AS pipeline_percentage
FROM sales_pipeline
GROUP BY deal_stage
ORDER BY opportunity_count DESC;

-- Currently open opportunities
SELECT COUNT(*) AS open_opportunities
FROM sales_pipeline
WHERE deal_stage IN ('Prospecting','Engaging');

-- Percentage of pipeline still open
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN deal_stage IN ('Prospecting','Engaging') THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS open_pipeline_percentage
FROM sales_pipeline;


-- =========================================================
-- 7. MONTHLY REVENUE ANALYSIS
-- =========================================================

SELECT
    DATE_FORMAT(STR_TO_DATE(close_date, '%Y-%m-%d'), '%Y-%m') AS close_month,
    COUNT(*) AS won_deals,
    ROUND(SUM(CAST(NULLIF(TRIM(close_value), '') AS DECIMAL(15,2))), 2) AS monthly_revenue
FROM sales_pipeline
WHERE deal_stage = 'Won'
  AND close_date IS NOT NULL
  AND TRIM(close_date) <> ''
GROUP BY close_month
ORDER BY close_month;


-- =========================================================
-- 8. SALES CYCLE ANALYSIS
-- =========================================================

-- Sales cycle for each Won opportunity
SELECT
    opportunity_id,
    sales_agent,
    product,
    account,
    DATEDIFF(
        STR_TO_DATE(close_date, '%Y-%m-%d'),
        STR_TO_DATE(engage_date, '%Y-%m-%d')
    ) AS sales_cycle_days
FROM sales_pipeline
WHERE deal_stage = 'Won'
  AND TRIM(engage_date) <> ''
  AND TRIM(close_date) <> ''
ORDER BY sales_cycle_days DESC;

-- Average sales cycle by product
SELECT
    product,
    ROUND(AVG(
        DATEDIFF(
            STR_TO_DATE(close_date, '%Y-%m-%d'),
            STR_TO_DATE(engage_date, '%Y-%m-%d')
        )
    ), 2) AS average_sales_cycle_days
FROM sales_pipeline
WHERE deal_stage = 'Won'
  AND TRIM(engage_date) <> ''
  AND TRIM(close_date) <> ''
GROUP BY product
ORDER BY average_sales_cycle_days DESC;


-- =========================================================
-- 9. CASE WHEN ANALYSIS
-- =========================================================

-- Categorize Won deals by value
SELECT
    opportunity_id,
    product,
    sales_agent,
    CAST(NULLIF(TRIM(close_value), '') AS DECIMAL(15,2)) AS deal_value,
    CASE
        WHEN CAST(NULLIF(TRIM(close_value), '') AS DECIMAL(15,2)) >= 5000 THEN 'High Value'
        WHEN CAST(NULLIF(TRIM(close_value), '') AS DECIMAL(15,2)) >= 2500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS deal_value_category
FROM sales_pipeline
WHERE deal_stage = 'Won'
ORDER BY deal_value DESC;


-- =========================================================
-- 10. CTE ANALYSIS
-- =========================================================

-- Agents performing above the overall win rate
WITH agent_performance AS (
    SELECT
        sales_agent,
        COUNT(*) AS closed_opportunities,
        SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_deals,
        ROUND(
            100.0 * SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END)
            / NULLIF(SUM(CASE WHEN deal_stage IN ('Won','Lost') THEN 1 ELSE 0 END), 0),
            2
        ) AS win_rate
    FROM sales_pipeline
    WHERE deal_stage IN ('Won','Lost')
    GROUP BY sales_agent
),
overall_rate AS (
    SELECT
        ROUND(
            100.0 * SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END)
            / NULLIF(SUM(CASE WHEN deal_stage IN ('Won','Lost') THEN 1 ELSE 0 END), 0),
            2
        ) AS overall_win_rate
    FROM sales_pipeline
)
SELECT
    a.sales_agent,
    a.closed_opportunities,
    a.won_deals,
    a.win_rate,
    o.overall_win_rate
FROM agent_performance a
CROSS JOIN overall_rate o
WHERE a.win_rate > o.overall_win_rate
ORDER BY a.win_rate DESC;


-- =========================================================
-- 11. WINDOW FUNCTION ANALYSIS
-- =========================================================

-- Rank products by revenue
WITH product_revenue AS (
    SELECT
        product,
        SUM(CAST(NULLIF(TRIM(close_value), '') AS DECIMAL(15,2))) AS revenue
    FROM sales_pipeline
    WHERE deal_stage = 'Won'
    GROUP BY product
)
SELECT
    product,
    ROUND(revenue, 2) AS revenue,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM product_revenue
ORDER BY revenue_rank;

-- Rank agents by revenue
WITH agent_revenue AS (
    SELECT
        sales_agent,
        SUM(CAST(NULLIF(TRIM(close_value), '') AS DECIMAL(15,2))) AS revenue
    FROM sales_pipeline
    WHERE deal_stage = 'Won'
    GROUP BY sales_agent
)
SELECT
    sales_agent,
    ROUND(revenue, 2) AS revenue,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM agent_revenue
ORDER BY revenue_rank;


-- =========================================================
-- 12. FINAL KPI QUERY FOR PORTFOLIO
-- =========================================================

SELECT
    COUNT(*) AS total_opportunities,
    SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_opportunities,
    SUM(CASE WHEN deal_stage = 'Lost' THEN 1 ELSE 0 END) AS lost_opportunities,
    SUM(CASE WHEN deal_stage = 'Engaging' THEN 1 ELSE 0 END) AS engaging_opportunities,
    SUM(CASE WHEN deal_stage = 'Prospecting' THEN 1 ELSE 0 END) AS prospecting_opportunities,
    ROUND(
        100.0 * SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN deal_stage IN ('Won','Lost') THEN 1 ELSE 0 END), 0),
        2
    ) AS win_rate_percent,
    ROUND(SUM(
        CASE WHEN deal_stage = 'Won'
        THEN CAST(NULLIF(TRIM(close_value), '') AS DECIMAL(15,2))
        ELSE 0 END
    ), 2) AS total_revenue
FROM sales_pipeline;


/*
BUSINESS QUESTIONS ANSWERED:
1. How large is the sales pipeline?
2. What is the overall win rate?
3. How much revenue was generated?
4. Which products generate the most revenue?
5. Which sales agents perform best?
6. Which accounts contribute the most revenue?
7. How is the pipeline distributed by stage?
8. What are the monthly revenue trends?
9. What is the average sales cycle?
10. Which products/agents show stronger performance?

This SQL analysis supports the Excel analysis and Power BI
Sales Pipeline Performance Dashboard.
*/

