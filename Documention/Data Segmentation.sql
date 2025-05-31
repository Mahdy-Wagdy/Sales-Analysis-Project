/*Group customers into three segments based on their spending behavior:
   - VIP: Customers with at least 12 months of history and spending more than €5,000.
   - Regular: Customers with at least 12 months of history but spending €5,000 or less.
   - New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
WITH customer_spending AS
(
SELECT 
c.customer_key,
SUM(s.sales_amount) total_spending,
MIN(s.order_date) AS first_order,
MAX(s.order_date) AS last_order,
(EXTRACT(YEAR FROM MAX(order_date)) - EXTRACT(YEAR FROM MIN(order_date))) * 12 +
(EXTRACT(MONTH FROM MAX(order_date)) - EXTRACT(MONTH FROM MIN(order_date))) AS lifespen
FROM gold.fact_sales s LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key
)

SELECT 
customer_segment,
COUNT (customer_key)
FROM(
	SELECT 
	customer_key,
	CASE WHEN lifespen >= 12 AND total_spending > 5000 THEN 'VIP'
		 WHEN lifespen >= 12 AND total_spending <= 5000 THEN 'Regular'
		 ELSE 'NEW'
	END customer_segment
	FROM customer_spending ) t
GROUP BY customer_segment
ORDER BY customer_segment DESC
