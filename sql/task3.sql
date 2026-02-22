-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT c.category_id, c.category_name, sum(oi.quantity * oi.unit_price) as total_sales_amount
 FROM Categories c 
 INNER JOIN Products p ON c.category_id = p.category_id
 INNER JOIN Order_Items oi ON p.product_id = oi.product_id
 GROUP BY c.category_id, c.category_name
 ORDER BY total_sales_amount DESC
 LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT DISTINCT u.user_id, u.username
 FROM Users u
 INNER JOIN Orders o ON u.user_id = o.user_id
 INNER JOIN Order_Items oi ON o.order_id = oi.order_id
 INNER JOIN Products p ON oi.product_id = p.product_id
 INNER JOIN Categories c ON p.category_id = c.category_id
 WHERE c.category_name = 'Toys & Games'
 GROUP BY u.user_id, u.username
 HAVING COUNT(DISTINCT p.product_id) = (
     SELECT COUNT(*) FROM Products p_2
     INNER JOIN categories c_2 ON p_2.category_id = c_2.category_id
     WHERE c_2.category_name = 'Toys & Games'
 )

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH HIGHEST_PRICE AS (
     SELECT product_id, product_name, category_id, price,
     ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS row_num
     FROM products
 )
 SELECT product_id, product_name, category_id, price
 FROM HIGHEST_PRICE
 WHERE row_num = 1;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT DISTINCT u.user_id, u.username
 FROM Users u 
 INNER JOIN Orders o on u.user_id = o.user_id
 INNER JOIN Orders oo on u.user_id = oo.user_id
 INNER JOIN Orders ooo on u.user_id = ooo.user_id
 WHERE DATEDIFF(day, o.order_date, oo.order_date) = 1
         AND DATEDIFF(day, oo.order_date, ooo.order_date) = 1
         AND DATEDIFF(day, o.order_date, ooo.order_date) = 2;