
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
(SELECT DATE_PART('year', AGE(NOW(),birthday)) as age FROM customer);

-- By all ages
SELECT 
	DATE_PART('year', AGE(NOW(),c.birthday)) as customer_age,
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

-- By Year

-- By Months

-- :: Revenue ::

-- By Product Categories

-- By Product Sub-Categories

-- By Customer Location

-- By Customer Age

-- By Customer Gender

-- By Customer Membership Status

-- By Year

-- By Months

-- :: Average Order Value :: 

-- By Product Categories

-- By Product Sub-Categories

-- By Customer Location

-- By Customer Age

-- By Customer Gender

-- By Customer Membership Status

-- By Year

-- By Months

-- END of Sales Analysis (Q1) 
-----------------------------
