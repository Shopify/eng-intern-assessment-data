-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT TOP 3 category_id, category_name, sum(quantity * price) AS total_sales_amount
FROM Order_Items NATURAL JOIN Products NATURAL JOIN Categories
GROUP BY category_id, category_name
ORDER BY total_sales_amount DESC;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT user_id, username
FROM Orders NATURAL JOIN Order_Items NATURAL JOIN Products NATURAL JOIN Categories
WHERE category_name = 'Toys & Games'
GROUP BY user_id, username
HAVING count(DISTINCT product_id) = (
    SELECT count(product_id) 
    FROM Products NATURAL JOIN Categories 
    WHERE category_name = 'Toys & Games'
    );

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT product_id, product_name, category_id, price
FROM Categories c1 NATURAL LEFT JOIN Products p1
WHERE price = (
    SELECT max(price) 
    FROM Categories c2 NATURAL LEFT JOIN Products p2 
    WHERE c2.category_id = c1.category_id
    );
-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT DISTINCT u.user_id, u.username
FROM (Orders o1, Orders o2, Orders o3) JOIN Users u ON o1.user_id = u.user_id
WHERE o1.user_id = o2.user_id AND o2.user_id = o3.user_id AND
DATE_PART('day', o2.order_date - o1.order_date) = 1 AND DATE_PART('day', o3.order_date - o2.order_date) = 1;