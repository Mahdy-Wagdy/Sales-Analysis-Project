-- which categories contribute the most to overall sales?
 WITH category_sales AS (
 SELECT 
 	category,
 	SUM(sales_amount) AS total_sales 
 FROM gold.fact_sales s LEFT JOIN gold.dim_products p
 ON s.product_key = p.product_key
 GROUP BY category
 )
SELECT 
	category,
	total_sales,
	SUM(total_sales) OVER () AS overall_sales,
	CONCAT(ROUND ((total_sales / SUM(total_sales) OVER () )*100,2),'%')AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC

