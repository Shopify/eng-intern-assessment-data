-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT c.category_id, c.category_name, SUM(oi.unit_price * oi.quantity) AS total_sales_amount
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY c.category_id
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT u.user_id, u.username
FROM Users u
WHERE (
    SELECT COUNT(Distinct oi.product_id) 
    FROM Order_Items oi
    JOIN Orders o ON o.order_id = oi.order_id 
    JOIN Products p ON p.product_id = oi.product_id
    JOIN Categories c ON p.category_id = c.category_id
    WHERE o.user_id = u.user_id and c.category_name = 'Toys & Games') 
    = 
    (SELECT COUNT(Distinct p1.product_id) 
     FROM Products p1
     JOIN Categories c1 ON p1.category_id = c1.category_id
     WHERE c1.category_name = 'Toys & Games');

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT p.product_id, p.product_name, p.category_id, p.price
FROM Products p 
JOIN (SELECT category_id, MAX(price) AS max_price 
      FROM Products 
      GROUP BY category_id) m ON p.category_id = m.category_id AND p.price = m.max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH OrderedDates AS (
    SELECT 
        user_id, 
        order_date,
        LAG(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) as prev_date,
        LEAD(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) as next_date
    FROM 
        Orders
),
ConsecutiveOrders AS (
    SELECT 
        user_id,
        order_date,
        prev_date,
        next_date,
        CASE 
            WHEN order_date = DATE_ADD(prev_date, INTERVAL 1 DAY) AND order_date = DATE_SUB(next_date, INTERVAL 1 DAY) THEN 1
            WHEN order_date = DATE_SUB(next_date, INTERVAL 1 DAY) AND prev_date IS NULL THEN 1
            WHEN order_date = DATE_ADD(prev_date, INTERVAL 1 DAY) AND next_date IS NULL THEN 1
            ELSE 0
        END AS is_consecutive
    FROM 
        OrderedDates
)
SELECT 
    u.user_id,
    u.username
FROM 
    Users u
JOIN 
    (SELECT 
        user_id
     FROM 
        ConsecutiveOrders
     WHERE 
        is_consecutive = 1
     GROUP BY 
        user_id
     HAVING 
        COUNT(*) >= 3) AS ConsUsers ON u.user_id = ConsUsers.user_id;