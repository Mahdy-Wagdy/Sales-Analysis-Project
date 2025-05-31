/*
==================================================
Product Report
==================================================

Purpose:
 - This report consolidates key product metrics and behaviors.

Highlights:
 1. Gathers essential fields such as product name, category, subcategory, and cost.
 2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
 3. Aggregates product-level metrics:
    - total orders
    - total sales
    - total quantity sold
    - total customers (unique)
    - lifespan (in months)
 4. Calculates valuable KPIs:
    - recency (months since last sale)
    - average order revenue (AOR)
    - average monthly revenue
==================================================
*/

CREATE VIEW gold.report_product AS 

--base_query

WITH base_query AS( 
SELECT 
s.order_number,
s.order_date,
s.customer_key,
s.sales_amount,
s.quantity,
p.product_key,
p.product_name,
p.category,
p.subcategory,
p.cost
FROM gold.fact_sales s LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
WHERE order_date IS NOT NULL
),

-- product_aggregation

product_aggregation AS (
SELECT 
product_key,
product_name,
category,
subcategory,
cost,
(EXTRACT(YEAR FROM MAX(order_date)) - EXTRACT(YEAR FROM MIN(order_date))) * 12 +
(EXTRACT(MONTH FROM MAX(order_date)) - EXTRACT(MONTH FROM MIN(order_date))) AS lifespen,
MAX (order_date) AS last_order_date,
COUNT(DISTINCT order_number) AS total_orders,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0))::numeric, 0) AS avg_selling_price
FROM base_query
GROUP BY product_key,product_name,category,subcategory,cost
)

SELECT 
product_key,
product_name,
category,
subcategory,
cost,
(EXTRACT(YEAR FROM AGE(CURRENT_DATE, last_order_date)) * 12 +
EXTRACT(MONTH FROM AGE(CURRENT_DATE, last_order_date)))::int AS recency,
CASE WHEN total_sales > 50000 THEN 'High-performance'
	 WHEN total_sales >= 10000 THEN 'Mid-performance'
	 ELSE 'Low-performance'
END AS product_segment,
lifespen,
total_orders,
total_customers,
total_sales,
total_quantity,
avg_selling_price,

-- Avg order revenue (AOR) 

CASE WHEN total_orders = 0 THEN 0
	 ELSE total_sales / total_orders
	 END AS avg_order_revenue,

-- Avg monthly revenue 

CASE WHEN lifespen = 0 THEN total_sales
	 ELSE ROUND(total_sales / lifespen,2)
END AS avg_monthly_revenue

FROM product_aggregation
