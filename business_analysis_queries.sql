---------------------------------------------
-- KPI Driven Business Analysis
---------------------------------------------

-- Business Questions

-- (Q1) Perform a sales analysis to get a picture of the sales performance of the boutique as well as help identify what is working well and what might need to be changed

-- (2) Perform a customer analysis highlighting top customers, membership rates, the effect of customer demographics on purchasing behavior, and patterns among repeat customers

-- (3) Create a report documenting the effect of the membership program on the companies performance


-- Analysis

/* Q1: Sales Analysis

Metrics: Sales Volume (ie quantity), Revenue, Average Order Value
Dimensions: Product Categories/Sub-Categories, Customer Demographics (location, gender, membership, etc), and Time (years, months)

*/

-- :: Sales Volume ::

-- Total Sales Volume
SELECT
	SUM(quantity) AS total_quantity
FROM orderline;

-- By Product Categories
SELECT
	prod.category,
	SUM(oline.quantity) AS total_quantity
FROM orderline AS oline
LEFT JOIN product AS prod
	USING(product_id)
GROUP BY prod.category;

-- By Product Sub-Categories
SELECT
	prod.sub_category,
	SUM(oline.quantity) AS total_quantity
FROM orderline AS oline
LEFT JOIN product AS prod
	USING(product_id)
GROUP BY prod.sub_category;

-- By Product Category & Sub-Category
SELECT
	prod.category,
	prod.sub_category,
	SUM(oline.quantity) AS total_quantity
FROM orderline AS oline
LEFT JOIN product AS prod
	USING(product_id)
GROUP BY prod.category, prod.sub_category
ORDER BY prod.category ASC, total_quantity DESC;

-- By Customer Location (ie state)
SELECT 
	add.state,
	SUM(oline.quantity) AS total_quantity
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
LEFT JOIN customer AS c
	USING(customer_id)
LEFT JOIN address AS add
	USING(address_id)
GROUP BY add.state
ORDER BY total_quantity DESC; -- OR order by state ASC

-- By Customer Age 

-- Min age: 18 | Max Age: 29 | Average age: 23.5 years old
SELECT  
	MIN(AGE),
	MAX(AGE), 
	AVG(age) AS avg_age
FROM
(SELECT DATE_PART('year', AGE(NOW(),birthday)) AS age FROM customer);

-- By all ages
SELECT 
	DATE_PART('year', AGE(NOW(),c.birthday)) AS customer_age,
	SUM(oline.quantity) AS total_quantity
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
LEFT JOIN customer AS c
	USING(customer_id)
GROUP BY customer_age
ORDER BY customer_age ASC;

-- By age category
SELECT 
	CASE
		WHEN DATE_PART('year', AGE(NOW(),c.birthday)) < 23 THEN 'Less than 23 yo'
		WHEN DATE_PART('year', AGE(NOW(),c.birthday)) BETWEEN 23 AND 24 THEN '23-24 yo (AVG)'
		ELSE 'Above 24 yo'
	END as age_group,
	SUM(oline.quantity) AS total_quantity
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
LEFT JOIN customer AS c
	USING(customer_id)
GROUP BY age_group;

-- By Customer Gender
SELECT 
	c.gender,
	SUM(oline.quantity) AS total_quantity
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
LEFT JOIN customer AS c
	USING(customer_id)
GROUP BY c.gender
ORDER BY c.gender DESC;

-- By Customer Membership Status
SELECT 
	CASE
		WHEN c.is_member = TRUE THEN 'Members'
		ELSE 'Non-members'
	END as member_status,
	SUM(oline.quantity) AS total_quantity
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
LEFT JOIN customer AS c
	USING(customer_id)
GROUP BY member_status;

-- By Year
SELECT 
	DATE_PART('year',o.order_date) AS year, 
	SUM(oline.quantity) AS total_quantity
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
GROUP BY year
ORDER BY year ASC;

-- Yearly Growth Rate
SELECT 
	DATE_PART('year',o.order_date) AS year, 
	ROUND((SUM(oline.quantity) - LAG(SUM(oline.quantity)) OVER (ORDER BY DATE_PART('year',o.order_date)))/ CAST(LAG(SUM(oline.quantity),1) OVER (ORDER BY DATE_PART('year',o.order_date)) AS DECIMAL)* 100,2) AS q_yearly_growth_rate
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
GROUP BY year;

-- Average Yearly Growth Rate
SELECT ROUND(AVG(q_yearly_growth_rate),2) AS avg_yearly_growth_rate
FROM
(
SELECT 
	DATE_PART('year',o.order_date) AS year, 
	ROUND((SUM(oline.quantity) - LAG(SUM(oline.quantity)) OVER (ORDER BY DATE_PART('year',o.order_date)))/ CAST(LAG(SUM(oline.quantity),1) OVER (ORDER BY DATE_PART('year',o.order_date)) AS DECIMAL)* 100,2) AS q_yearly_growth_rate
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
GROUP BY year
);

-- By Months
SELECT 
	DATE_PART('year',o.order_date) AS year,
	DATE_PART('month',o.order_date) AS month,
	SUM(oline.quantity) AS total_quantity
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
GROUP BY year, month
ORDER BY year ASC, month ASC;

-- Monthly Growth Rate
SELECT 
	DATE_PART('year',o.order_date) AS year, 
	DATE_PART('month',o.order_date) AS month,
	ROUND((SUM(oline.quantity) - LAG(SUM(oline.quantity)) OVER (ORDER BY DATE_PART('month',o.order_date)))/ CAST(LAG(SUM(oline.quantity),1) OVER (ORDER BY DATE_PART('month',o.order_date)) AS DECIMAL)* 100,2) AS monthly_growth_rate
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
GROUP BY year,month;

-- Average Monthly Growth Rate
SELECT ROUND(AVG(monthly_growth_rate),2) AS avg_monthly_growth_rate
FROM
(
SELECT 
	DATE_PART('year',o.order_date) AS year, 
	DATE_PART('month',o.order_date) AS month,
	ROUND((SUM(oline.quantity) - LAG(SUM(oline.quantity)) OVER (ORDER BY DATE_PART('month',o.order_date)))/ CAST(LAG(SUM(oline.quantity),1) OVER (ORDER BY DATE_PART('month',o.order_date)) AS DECIMAL)* 100,2) AS monthly_growth_rate
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
GROUP BY year,month
);

-- :: Revenue ::

-- Total Revenue 
SELECT
	SUM(line_total) AS total_revenue
FROM orderline;

-- By Product Categories
SELECT
	prod.category,
	SUM(oline.line_total) AS total_revenue
FROM orderline AS oline
LEFT JOIN product AS prod
	USING(product_id)
GROUP BY prod.category;

-- By Product Sub-Categories
SELECT
	prod.sub_category,
	SUM(oline.line_total) AS total_revenue
FROM orderline AS oline
LEFT JOIN product AS prod
	USING(product_id)
GROUP BY prod.sub_category;

-- By Product Category & Sub-Category
SELECT
	prod.category,
	prod.sub_category,
	SUM(oline.line_total) AS total_revenue
FROM orderline AS oline
LEFT JOIN product AS prod
	USING(product_id)
GROUP BY prod.category, prod.sub_category
ORDER BY prod.category ASC, total_revenue DESC;

-- By Customer Location (ie state)
SELECT 
	add.state,
	SUM(oline.line_total) AS total_revenue
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
LEFT JOIN customer AS c
	USING(customer_id)
LEFT JOIN address AS add
	USING(address_id)
GROUP BY add.state
ORDER BY total_revenue DESC; -- OR order by state ASC

-- By Customer Age 

-- Min age: 18 | Max Age: 29 | Average age: 23.5 years old
SELECT  
	MIN(AGE),
	MAX(AGE), 
	AVG(age) AS avg_age
FROM
(SELECT DATE_PART('year', AGE(NOW(),birthday)) as age FROM customer);

-- By all ages
SELECT 
	DATE_PART('year', AGE(NOW(),c.birthday)) as customer_age,
	SUM(oline.line_total) AS total_revenue
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
LEFT JOIN customer AS c
	USING(customer_id)
GROUP BY customer_age
ORDER BY customer_age ASC;

-- By age category
SELECT 
	CASE
		WHEN DATE_PART('year', AGE(NOW(),c.birthday)) < 23 THEN 'Less than 23 yo'
		WHEN DATE_PART('year', AGE(NOW(),c.birthday)) BETWEEN 23 AND 24 THEN '23-24 yo (AVG)'
		ELSE 'Above 24 yo'
	END as age_group,
	SUM(oline.line_total) AS total_revenue
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
LEFT JOIN customer AS c
	USING(customer_id)
GROUP BY age_group;

-- By Customer Gender
SELECT 
	c.gender,
	SUM(oline.line_total) AS total_revenue
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
LEFT JOIN customer AS c
	USING(customer_id)
GROUP BY c.gender
ORDER BY c.gender DESC;

-- By Customer Membership Status
SELECT 
	CASE
		WHEN c.is_member = TRUE THEN 'Members'
		ELSE 'Non-members'
	END as member_status,
	SUM(oline.line_total) AS total_revenue
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
LEFT JOIN customer AS c
	USING(customer_id)
GROUP BY member_status;

-- By Year
SELECT 
	DATE_PART('year',o.order_date) AS year, 
	SUM(oline.line_total) AS total_revenue
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
GROUP BY year
ORDER BY year ASC;

-- Yearly Growth Rate
SELECT 
	DATE_PART('year',o.order_date) AS year, 
	ROUND((SUM(oline.line_total) - LAG(SUM(oline.line_total)) OVER (ORDER BY DATE_PART('year',o.order_date)))/ CAST(LAG(SUM(oline.line_total),1) OVER (ORDER BY DATE_PART('year',o.order_date)) AS DECIMAL)* 100,2) AS yearly_growth_rate
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
GROUP BY year;

-- Average Yearly Growth Rate
SELECT ROUND(AVG(yearly_growth_rate),2) AS avg_yearly_growth_rate
FROM
(
SELECT 
	DATE_PART('year',o.order_date) AS year, 
	ROUND((SUM(oline.line_total) - LAG(SUM(oline.line_total)) OVER (ORDER BY DATE_PART('year',o.order_date)))/ CAST(LAG(SUM(oline.line_total),1) OVER (ORDER BY DATE_PART('year',o.order_date)) AS DECIMAL)* 100,2) AS yearly_growth_rate
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
GROUP BY year
);

-- By Months
SELECT 
	DATE_PART('year',o.order_date) AS year,
	DATE_PART('month',o.order_date) AS month,
	SUM(oline.line_total) AS total_revenue
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
GROUP BY year, month
ORDER BY year ASC, month ASC;

-- Monthly Growth Rate
SELECT 
	DATE_PART('year',o.order_date) AS year, 
	DATE_PART('month',o.order_date) AS month,
	ROUND((SUM(oline.line_total) - LAG(SUM(oline.line_total)) OVER (ORDER BY DATE_PART('month',o.order_date)))/ CAST(LAG(SUM(oline.line_total),1) OVER (ORDER BY DATE_PART('month',o.order_date)) AS DECIMAL)* 100,2) AS monthly_growth_rate
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
GROUP BY year,month;

-- Average Monthly Growth Rate
SELECT ROUND(AVG(monthly_growth_rate),2) AS avg_monthly_growth_rate
FROM
(
SELECT 
	DATE_PART('year',o.order_date) AS year, 
	DATE_PART('month',o.order_date) As month,
	ROUND((SUM(oline.line_total) - LAG(SUM(oline.line_total)) OVER (ORDER BY DATE_PART('month',o.order_date)))/ CAST(LAG(SUM(oline.line_total),1) OVER (ORDER BY DATE_PART('month',o.order_date)) AS DECIMAL)* 100,2) AS monthly_growth_rate
FROM orders AS o
LEFT JOIN orderline AS oline
	USING(order_id)
GROUP BY year,month
);

-- :: Average Order Value :: 

-- Overall AOV
SELECT 
	ROUND(total_revenue/num_orders,2) AS avg_order_value
FROM
(
SELECT 
	COUNT(order_id) as num_orders,
	SUM(line_total) as total_revenue
FROM orderline
);

-- By Product Categories
SELECT 
	p_category,
	ROUND(total_revenue/num_orders,2) AS avg_order_value
FROM
(
SELECT
	prod.category AS p_category,
	COUNT(oline.order_id) AS num_orders,
	SUM(oline.line_total) AS total_revenue
FROM orderline AS oline
LEFT JOIN product AS prod
	USING(product_id)
GROUP BY prod.category
);

-- By Product Sub-Categories
SELECT 
	p_sub_category,
	ROUND(total_revenue/num_orders,2) AS avg_order_value
FROM
(
SELECT
	prod.sub_category As p_sub_category,
	COUNT(oline.order_id) AS num_orders,
	SUM(oline.line_total) AS total_revenue
FROM orderline AS oline
LEFT JOIN product AS prod
	USING(product_id)
GROUP BY prod.sub_category
);

-- END of Sales Analysis (Q1) 
-----------------------------
