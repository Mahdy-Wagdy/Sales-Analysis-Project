SELECT
EXTRACT ( YEAR FROM order_date) AS year,
EXTRACT ( Month FROM order_date) AS Month,
SUM(sales_amount) AS sales,
COUNT (DISTINCT customer_key) AS total_customers ,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL 
GROUP BY EXTRACT (year FROM order_date) , EXTRACT ( Month FROM order_date)
ORDER BY EXTRACT (year FROM order_date) , EXTRACT ( Month FROM order_date)

