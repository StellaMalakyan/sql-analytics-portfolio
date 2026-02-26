SELECT * FROM public.sales_analysis

SELECT
DATE_TRUNC('month', order_date_date) AS sales_month,
SUM(total_sales) AS monthly_revenue 
FROM sales_analysis
GROUP BY sales_month
ORDER BY monthly_revenue DESC
LIMIT 3;

SELECT
DATE_TRUNC('quarter', order_date_date) AS sales_quarter,
SUM(total_sales) AS quarter_revenue
FROM sales_analysis
GROUP BY sales_quarter
ORDER BY quarter_revenue DESC
LIMIT 1;

SELECT
order_date_date,
CURRENT_DATE - order_date_date AS days_since_transaction
FROM sales_analysis
ORDER BY days_since_transaction;


SELECT *
FROM sales_analysis
WHERE order_date_date >= CURRENT_DATE - INTERVAL '60 days';
