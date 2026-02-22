-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
--- CTE to perform the amount calculation.
WITH amount_calculation AS(
	SELECT o_i.order_id,
		   o_i.product_id,
           o_i.quantity*o_i.unit_price as purch_amount
	FROM Order_Items as o_i)
SELECT c.category_id,
	   c.category_name,
       SUM(ac.purch_amount)
FROM
	amount_calculation as ac
JOIN
	Products as p
ON
	ac.product_id =p.product_id
JOIN
	Categories as c
ON
	p.category_id=c.category_id
GROUP BY
	c.category_id
ORDER BY
	SUM(ac.purch_amount) DESC
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
WITH toy_products as (
	SELECT p.product_id
    FROM Products as p
	JOIN
		Categories as c
	ON
		p.category_id=c.category_id
	WHERE c.category_name='Toys & Games')
SELECT distinct u.user_id, u.username
FROM
	Orders as o
JOIN
	Order_Items as o_i
ON
	o.order_id=o_i.order_id
JOIN
	toy_products as t_p
ON
	o_i.product_id=t_p.product_id
JOIN
	Users as u
ON o.user_id=u.user_id;


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
--- Used a window function to partition and order data by price
--- Used the outter query to only get the highest priced product.
WITH sorted_products as (
	SELECT p.product_id,
		   p.product_name,
           p.category_id AS category_id,
		   p.price,
		   ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) AS rank_number
	FROM Products AS p
)
 SELECT * FROM sorted_products
 WHERE rank_number=1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
--- We can extend the CTE from task 2 question 4 to use the LEAD function to find the date of the next purchase.
--- Using the DATEDIFF function in a where clause we can find purchase date differences of 1 and -1
--- to obtain purchases made on 3 consecutive dates.
WITH OrderHistory AS (
	SELECT
		user_id,
		order_date,
		LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date,
		LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date
	FROM Orders
)
SELECT
	DISTINCT(u.user_id), u.username
FROM OrderHistory as oh
JOIN
	Users as u
ON
	oh.user_id=u.user_id
WHERE
	DATEDIFF(oh.order_date, oh.prev_order_date) = 1
	AND
	DATEDIFF(oh.order_date, oh.next_order_date) = -1;