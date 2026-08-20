
==================================== Revenue & Sales Analysis ===============================================

Which two countries generate the highest revenue, and what is their share of total revenue?


WITH revenue_by_country_cte AS (
SELECT 
c.country ,
SUM(tv.gross_revenue ) AS Revenue
FROM marketing_and_ecommerce_analysis.customers c 
LEFT JOIN marketing_and_ecommerce_analysis.transactions_vw tv 
ON c.customer_id = tv.customer_id 
GROUP BY  c.country 
),
total_revenue_cte AS (
SELECT 
country ,
revenue ,
SUM(revenue ) OVER() AS Total_revenue
FROM revenue_by_country_cte 
)
SELECT 
country ,
CONCAT(
		ROUND((revenue / total_revenue) * 100, 2),
		"%"
	) AS Percentage_of_share
FROM total_revenue_cte 
ORDER BY revenue  DESC
LIMIT 2


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Which category generate the most revenue per order?


WITH cte AS (
SELECT 
p.category  ,
ROUND(
		SUM(tv.gross_revenue ) / COUNT(tv.transaction_id )
		,2
		) AS AOV
FROM marketing_and_ecommerce_analysis.products p 
JOIN marketing_and_ecommerce_analysis.transactions_vw tv 
ON p.product_id = tv.product_id 
GROUP BY p.category  
)
SELECT 
category 
FROM cte 
ORDER BY aov DESC
LIMIT 1


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Which product generate the most revenue per order in each category and what is their corresponding average order value?


WITH cte AS (
SELECT 
p.category ,
p.product_id ,
ROUND(
	SUM(tv.gross_revenue ) / COUNT(tv.transaction_id )
	,2
	) AS AOV
FROM marketing_and_ecommerce_analysis.products p 
JOIN marketing_and_ecommerce_analysis.transactions_vw tv 
ON p.product_id = tv.product_id 
GROUP BY 
		p.category ,
		p.product_id
),
cte_1 AS (
SELECT 
category ,
product_id ,
AOV ,
RANK() OVER(PARTITION BY category ORDER BY aov DESC) AS rnk
FROM cte 
)
SELECT 
category ,
product_id ,
AOV
FROM cte_1
WHERE rnk = 1
ORDER BY AOV DESC

-- ( Refer  "02.Data_quality_checks.sql"  file, to know why i used product_id in result )


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Which three brands generate the highest revenue within each product category?


WITH cte AS (
SELECT 
p.category ,
p.brand ,
SUM(tv.gross_revenue ) AS Revenue,
ROW_NUMBER() OVER(PARTITION BY p.category ORDER BY SUM(tv.gross_revenue ) DESC ) AS rn
FROM marketing_and_ecommerce_analysis.products p 
JOIN marketing_and_ecommerce_analysis.transactions_vw tv 
ON p.product_id = tv.product_id 
GROUP BY 
	p.category ,
	p.brand	
)
SELECT 
category ,
brand ,
revenue 
FROM cte 
WHERE rn <= 3


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Find the top two age groups that contribute the highest total revenue and their corresponding percentage of share?


WITH age_group_cte AS (
SELECT
c.customer_id ,
CASE
	WHEN c.age < 25 THEN "18-24"
	WHEN c.age < 35 THEN "25-34"
	WHEN c.age < 45 THEN "35-44"
	WHEN c.age < 55 THEN "45-54"
	ELSE "55+"
END AS Age_Group
FROM marketing_and_ecommerce_analysis.customers c 
),
cte AS (
SELECT 
DISTINCT ag.age_group ,
SUM(tv.gross_revenue) OVER(PARTITION BY ag.age_group) AS Revenue,
SUM(tv.gross_revenue) OVER() AS Total_revenue
FROM age_group_cte ag
JOIN marketing_and_ecommerce_analysis.transactions_vw tv 
ON ag .customer_id = tv.customer_id 
)
SELECT 
age_group ,
CONCAT(
		ROUND( revenue  / total_revenue * 100 , 2 ) ,
		"%"
		) AS Percentage_of_share
FROM cte 
ORDER BY percentage_of_share  DESC
LIMIT 2



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


What are the top 5 revenue-generating products, and what percentage of total revenue does each contribute?


WITH cte AS (
SELECT 
p.product_id ,
SUM(tv.gross_revenue ) AS Product_revenue
FROM marketing_and_ecommerce_analysis.products p 
JOIN marketing_and_ecommerce_analysis.transactions_vw tv 
ON p.product_id = tv.product_id 
GROUP BY p.product_id 
ORDER BY Product_revenue DESC
),
cte_1 AS (
SELECT 
product_id ,
Product_revenue,
SUM(Product_revenue ) OVER() AS Total_revenue
FROM cte 
)
SELECT 
product_id ,
Product_revenue,
CONCAT(
		ROUND(Product_revenue / Total_revenue  * 100 ,2),
		"%"
		) AS Percentage_of_contribution 
FROM cte_1 
LIMIT 5


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Which brand generates the highest revenue in each country?


WITH cte AS (
SELECT 
c.country ,
p.brand  ,
SUM(tv.gross_revenue ) AS Revenue
FROM marketing_and_ecommerce_analysis.customers c 
JOIN marketing_and_ecommerce_analysis.transactions_vw tv 
ON c.customer_id = tv.customer_id 
JOIN marketing_and_ecommerce_analysis.products p 
ON p.product_id = tv.product_id 
GROUP BY 
	c.country ,
	p.brand 
),
cte_1 AS (
SELECT
country ,
brand  ,
revenue ,
RANK() OVER(PARTITION BY country ORDER BY revenue DESC) AS rnk
FROM cte
)
SELECT 
country ,
brand  ,
revenue 
FROM cte_1
WHERE rnk = 1
ORDER BY revenue DESC


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


What are the top five revenue-generating products in each country?


WITH cte AS (
SELECT 
c.country ,
p.product_id ,
SUM(tv.gross_revenue ) AS Revenue,
ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY SUM(tv.gross_revenue ) DESC) AS rn
FROM marketing_and_ecommerce_analysis.customers c 
JOIN marketing_and_ecommerce_analysis.transactions_vw tv 
ON c.customer_id = tv.customer_id 
JOIN marketing_and_ecommerce_analysis.products p 
ON p.product_id = tv.product_id 
GROUP BY 
	c.country ,
	p.product_id 
)
SELECT 
country ,
product_id ,
revenue 
FROM cte 
WHERE rn <= 5


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Which month generated the highest revenue in every year?


WITH cte AS (
SELECT 
YEAR(tv.`timestamp` ) AS Year,
MONTH(tv.`timestamp` ) AS month,
SUM(tv.gross_revenue ) AS Revenue
FROM marketing_and_ecommerce_analysis.transactions_vw tv 
GROUP BY 
			YEAR(tv.`timestamp` ),
			MONTH(tv.`timestamp` ) 
),
cte_1 AS (
SELECT 
year,
month,
Revenue,
RANK() OVER(PARTITION BY year ORDER BY revenue DESC) AS rnk
FROM cte 
)
SELECT 
year,
month,
Revenue
FROM cte_1
WHERE rnk = 1


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


What is the month-over-month revenue growth rate?


WITH cte AS (
SELECT
YEAR(tv.`timestamp` ) AS Year,
MONTH(tv.`timestamp` ) AS Month,
SUM(tv.gross_revenue ) AS current_revenue
FROM marketing_and_ecommerce_analysis.transactions_vw tv 
GROUP BY 	
	YEAR(tv.`timestamp` ),
	MONTH(tv.`timestamp` )
),
lagged_revenue_cte AS (
SELECT 
year,
month,
current_revenue ,
LAG(current_revenue,1) OVER(ORDER BY `Year`,`month` ) AS previous_month_revenue
FROM cte
)
SELECT 
`year` ,
`month` ,
CASE 
	WHEN ROUND(((current_revenue - previous_month_revenue ) / previous_month_revenue  * 100),2) IS NULL THEN 0
	ELSE ROUND(((current_revenue - previous_month_revenue ) / previous_month_revenue  * 100),2)
END AS MoM_Growth_Percentage
FROM lagged_revenue_cte 


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


What percentage of total revenue comes from the top 10 products?


WITH cte AS (
SELECT
p.product_id ,
SUM(tv.gross_revenue ) AS Product_revenue
FROM marketing_and_ecommerce_analysis.products p 
JOIN marketing_and_ecommerce_analysis.transactions_vw tv 
ON p.product_id = tv.product_id 
GROUP BY p.product_id 
),
cte_1 AS (
SELECT 
product_id ,
Product_revenue ,
SUM(Product_revenue ) OVER() AS Total_revenue
FROM cte 
ORDER BY Product_revenue DESC 
LIMIT 10
)
SELECT 
CONCAT(
		ROUND(SUM(product_revenue ) / MAX(total_revenue) * 100,2),
		"%" 
		) AS Top_10_product_share
FROM cte_1 


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


What percentage of revenue comes from the top 20% of products?


WITH cte AS (
SELECT 
p.product_id ,
SUM(tv.gross_revenue) AS Revenue 
FROM marketing_and_ecommerce_analysis.products p 
JOIN marketing_and_ecommerce_analysis.transactions_vw tv 
ON p.product_id = tv.product_id 
GROUP BY p.product_id 
),
cte_1 AS (
SELECT 
product_id ,
revenue ,
NTILE(100) OVER(ORDER BY revenue DESC) AS tile,
SUM(revenue) OVER() AS Total_revenue
FROM cte
),
cte_2 AS (
SELECT 
product_id ,
revenue ,
total_revenue ,
tile
FROM cte_1 
WHERE tile <= 20
)
SELECT 
CONCAT(
		ROUND(SUM(revenue ) / MAX(total_revenue ) * 100,2),
		"%"
		) AS 'Top_20%_product_share' 
FROM cte_2 


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Which country experienced the largest month-over-month percentage decline in revenue?


WITH cte AS (
SELECT 
c.country ,
YEAR(tv.`timestamp` ) AS year,
MONTH(tv.`timestamp` ) AS month,
SUM(tv.gross_revenue ) AS Revenue
FROM marketing_and_ecommerce_analysis.customers c 
JOIN marketing_and_ecommerce_analysis.transactions_vw tv 
ON c.customer_id = tv.customer_id 
GROUP BY 
			c.country ,
			YEAR(tv.`timestamp` ),
			MONTH(tv.`timestamp` )
),
cte_1 AS (
SELECT 
country ,
year,
month,
revenue ,
LAG(revenue) OVER(PARTITION BY country ORDER BY year, month) AS Previous_month_revenue
FROM cte 
),
cte_2 AS (
SELECT 
country ,
year,
month,
ROUND(((revenue - previous_month_revenue )/ previous_month_revenue * 100),2) AS growth_or_decline
FROM cte_1
)
SELECT 
country,year,
month,
growth_or_decline
FROM cte_2 
WHERE growth_or_decline = (SELECT MIN(growth_or_decline) FROM cte_2 )

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------