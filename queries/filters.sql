SELECT *
FROM sales_analysis;

SELECT
transaction_id,
city,
category,
total_sales,
CASE
WHEN category = 'Electronics' AND total_sales > 1000 AND discount < 0.1 THEN 'Premium Electronics'
WHEN total_sales BETWEEN 500 AND 1000 AND discount <= 0.2 THEN 'Mid-Tier Value'
WHEN total_sales < 500 OR discount > 0.3 THEN 'Budget/Clearance'
WHEN city = 'alanborough' AND category = 'toys' THEN 'Toys_Segment'
ELSE 'Other'
END AS business_segment
FROM
sales_analysis
WHERE
YEAR = 2023; 



SELECT
category,
SUM(total_sales) AS total_revenue,
COUNT(transaction_id) AS transaction_count,
AVG(discount) AS average_discount,
CASE
WHEN SUM(total_sales) > 50000 THEN 'Strong Performer'
WHEN SUM(total_sales) BETWEEN 20000 AND 50000 THEN 'Average Performer'
ELSE 'Underperformer'
END AS performance_label
FROM
sales_analysis
WHERE
YEAR = 2023 
GROUP BY
category
HAVING
COUNT(transaction_id) > 5 
ORDER BY
total_revenue DESC; 



SELECT
city,
COUNT(*) AS transaction_volume,
CASE
WHEN COUNT(*) > 50 THEN 'High Activity'
WHEN COUNT(*) BETWEEN 25 AND 50 THEN 'Medium Activity'
ELSE 'Low Activity'
END AS activity_tier
FROM
sales_analysis
WHERE 
YEAR = 2023
GROUP BY
city
HAVING
COUNT(*) > 3
ORDER BY
transaction_volume DESC;




SELECT
category,
AVG(discount) AS average_discount,
SUM(total_sales) AS total_revenue,
CASE
WHEN AVG(discount) > 0.2 THEN 'High Discount'
WHEN AVG(discount) BETWEEN 0.1 AND 0.2 THEN 'Moderate Discount'
ELSE 'Low or No Discount'
END AS discount_behavior
FROM
sales_analysis
GROUP BY
category
HAVING
COUNT(*) > 5 
ORDER BY
average_discount DESC;

