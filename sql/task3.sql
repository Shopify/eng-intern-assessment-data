-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Understanding
-- If we add the prices of order_id, we get 125
-- But the orders for order_id=1 gives us the total price of 100
-- This could be data inconsistency, or perhaps we can interpret it as
-- the orders being the actual final price which could include discounts or sales
-- whereas the other is just the prices


WITH
tmp AS (
	SELECT category_id, category_name, (quantity * unit_price) AS total_amount
  	FROM Categories 
  		LEFT JOIN Products USING (category_id)
  		LEFT JOIN Order_Items using (product_id) -- We don't need to join it to orders
)

SELECT category_id, category_name, SUM(total_amount) as total_sales_amount
FROM tmp
GROUP BY category_id, category_name
ORDER BY total_sales_amount DESC
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

WITH
tmp AS (
	SELECT product_id, category_name, product_name
  	FROM Products AS p -- More efficent to filter while joining
  		INNER JOIN Categories AS c
  		ON (p.category_id=c.category_id 
            AND c.category_name = 'Toys & Games')
)


SELECT DISTINCT user_id, username
FROM Order_Items 
	INNER JOIN tmp USING (product_id)
    INNER JOIN Orders using (order_id)
    INNER JOIN Users USING (user_id);



-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- This way, if we have two items in a category that have the same max price, 
-- we can retrieve them
WITH 
tmp AS (
	SELECT category_id, MAX(price) AS price
  FROM Products INNER JOIN Categories using (category_id)
  GROUP BY category_id
)

SELECT product_id, product_name, category_id, price
FROM Products as p INNER JOIN tmp AS t USING (category_id, price);


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.


-- The simpilest way is to store the next two dates and compute the difference
-- If both are 1, then this user at some point orders consectuviely in 3 days

WITH tmp AS (
    SELECT
        user_id,
        username,
        order_date,
        LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_date,
        LEAD(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS next2_date
    FROM Orders
    LEFT JOIN Users USING (user_id)
)

SELECT DISTINCT user_id, username
FROM tmp
WHERE
    julianday(next_date) - julianday(order_date) = 1 AND 
    julianday(next2_date) - julianday(next_date) = 1;
