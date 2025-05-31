--Calculate the total sales per month 
-- and the running total of sales over time
SELECT 
order_date,
total_sales,
SUM(total_sales) OVER (PARTITION BY  order_date ORDER BY order_date) AS Running_Total_Sales,
ROUND (AVG(avg_price) OVER (PARTITION BY  order_date ORDER BY order_date),2) AS Moving_Average_Price
--Window Function
FROM 
(
SELECT 
date_trunc( 'Month' ,order_date) AS order_date,
SUM(sales_amount) AS total_sales,
AVG (Price) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY date_trunc( 'Month' ,order_date)
)
