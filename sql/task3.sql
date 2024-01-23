-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT
    c.category_id,
    c.category_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM Categories c

-- Joining the Products and Order_Items tables based on ID to get access to quantity and unit price per order_item
JOIN Products p ON c.category_id = p.category_id
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY c.category_id

-- Limiting the results to the first 3 categories in DESC order by total sales
ORDER BY total_sales DESC
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT 
    u.user_id,
    u.username
FROM Users u

-- Creating a table with the number of Toys & Games products per user
JOIN (
    SELECT
        o.user_id,
        COUNT(oi.product_id) AS toys_count
    FROM Orders o
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
    JOIN Categories c ON p.category_id = c.category_id
    WHERE c.category_name = 'Toys & Games'
    GROUP BY o.user_id
) AS userToysCount ON u.user_id = userToysCount.user_id

-- Only allowing the users with the same number of Toys & Games products as the total number of products
WHERE userToysCount.toys_count IN (
    -- Finding the total number of Toys & Games products in the database
    SELECT 
        COUNT(p.product_id)
    FROM Products p
    JOIN Categories c ON p.category_id = c.category_id
    WHERE c.category_name = 'Toys & Games'
)
-- To Remove Edge Cases Where There Are No Products That Are Toys & Games
AND userToysCount.toys_count > 0;


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT
    c.category_id,
    c.category_name,
    MAX(p.price) as max_price
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY c.category_id;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT DISTINCT
    full_dates.user_id,
    full_dates.username
FROM (
  SELECT 
        o.user_id, 
        u.username, 
        o.order_date,
        LAG(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) as prev_date,
        LEAD(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) as next_date
    FROM orders o
    JOIN Users u ON u.user_id = o.user_id
) AS full_dates
WHERE 
    full_dates.prev_date = full_dates.order_date - 1 AND 
    full_dates.next_date = full_dates.order_date + 1;