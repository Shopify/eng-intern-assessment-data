-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT 
	TOP 3 c.category_id, 
	c.category_name, 
	SUM(oi.quantity* oi.unit_price) AS total_sales
FROM Categories c
	JOIN Products p ON c.category_id = p.category_id
	JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales DESC


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.


SELECT 
	u.user_id, 
	u.username
FROM users u
	JOIN orders o ON u.user_id = o.user_id
	JOIN order_items oi ON o.order_id = oi.order_id
	JOIN products p ON oi.product_id = p.product_id
	JOIN categories c ON p.category_id = c.category_id
WHERE c.category_id = 5
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.product_id) = (SELECT COUNT(*) FROM products WHERE category_id = 5)


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT prod.product_id, prod.product_name, prod.category_id, prod.price
FROM (
    SELECT 
        p.product_id, 
        p.product_name, 
        p.category_id, 
        p.price,
        ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) as rn
    FROM Products p
) prod
WHERE prod.rn = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.


SELECT DISTINCT u.user_id, u.username
FROM (
    SELECT o.user_id,
           o.order_date,
           LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) as prev_date,
           LEAD(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) as next_date
    FROM Orders o
) AS N_P_days
JOIN users u ON N_P_days.user_id = u.user_id
WHERE (N_P_days.order_date =  DATEADD(day, 1, N_P_days.prev_date)
       AND N_P_days.order_date = DATEADD(day, 1, N_P_days.next_date))
   OR (N_P_days.order_date = DATEADD(day, 1, N_P_days.prev_date) 
       AND N_P_days.order_date = DATEADD(day, 1, N_P_days.next_date)) 
   OR (N_P_days.order_date = DATEADD(day, 1, N_P_days.prev_date) 
       AND N_P_days.order_date = DATEADD(day, 1, N_P_days.next_date)) 
GROUP BY u.user_id, u.username
HAVING COUNT(*) >= 3