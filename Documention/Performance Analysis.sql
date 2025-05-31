/* Anlyze the yearly performance of products by comparing thier sales
to both the average sales performace of products and the previous year's sales */ 
WITH yearly_product_sales AS (
SELECT 
date_trunc('Year',s.order_date) AS order_year,
p.product_name,
SUM(s.sales_amount) AS current_sales
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY date_trunc('Year',s.order_date) , p.product_name 
)
SELECT 
order_year,
product_name,
current_sales,
ROUND (AVG(current_sales) OVER (PARTITION BY product_name ),0) AS Avg_sales,
current_sales - ROUND (AVG(current_sales) OVER (PARTITION BY product_name ),0) AS Diff_avg,
CASE WHEN current_sales - ROUND (AVG(current_sales) OVER (PARTITION BY product_name ),0) > 0 THEN 'Above Avg'
	 WHEN current_sales - ROUND (AVG(current_sales) OVER (PARTITION BY product_name ),0) < 0 THEN 'below Avg'
	 ELSE 'Avg'
END avg_change,
-- YOY Analysis 
LAG (current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS PY_sales,
current_sales -LAG (current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS Diff_PY,
CASE WHEN current_sales -LAG (current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
	 WHEN current_sales -LAG (current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
	 ELSE 'No Change'
END PY_change
FROM yearly_product_sales
ORDER BY product_name , order_year
