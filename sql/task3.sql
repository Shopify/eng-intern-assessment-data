-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT TOP 3 c.category_id, c.category_name, SUM(o.total_amount) AS total
FROM Categories c, Orders o, Products p, Order_Items ot
WHERE c.category_id = p.category_id AND p.product_id = ot.product_id AND o.order_id = ot.order_id
GROUP BY c.category_id, c.category_name
ORDER BY total DESC;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT u.user_id, u.username
FROM Users u, Products p, Orders o, Order_Items ot, Categories c 
WHERE u.user_id = o.user_id AND o.order_id = ot.order_id AND ot.product_id = p.product_id AND c.category_id = p.category_id AND c.category_name = 'Toys & Games'
AND COUNT(DISTINCT p.product_id) = (
    SELECT COUNT(*) 
    FROM Products p2, Categories c2 
    WHERE p2.category_id = c2.category_id AND c2.category_name = 'Toys & Games'
    )
GROUP BY u.user_id, u.username;

-- One could hard code the category_id for Toys & Games (5) and thus not have to join the categories table here 

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.


WITH ranked AS (SELECT p.product_id, p.product_name, p.category_id, p.price, 
                RANK() OVER(PARTITION BY p.category_id ORDER BY p.price DESC) Rank
                FROM Products p)
SELECT r.product_id, r.product_name, r.category_id, r.price 
FROM ranked r 
WHERE Rank = 1;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH consec AS(
SELECT o2.user_id, o2.order_date, 
            LAG(o2.order_date, 1) OVER (PARTITION BY o2.user_id ORDER BY o2.order_date) AS second_order,
            LAG(o2.order_date, 2) OVER (PARTITION BY o2.user_id ORDER BY o2.order_date) AS third_order,
    FROM Orders o2
)
SELECT u.user_id, u.username 
FROM Users u, consec
WHERE u.user_id = consec.user_id 
AND consec.second_order = consec.order_date - INTERVAL 1 DAY AND consec.third_order = consec.order_date - INTERVAL 2 DAY
