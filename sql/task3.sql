-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
-- Retrieve the top 3 categories with the highest total sales amount

-- We can solve this problem by getting the highest total sales amounts by using a join on categories, product, and order_items.
-- We can then aggregate and order the sum of the unit_price * quantity within each category.
SELECT c.category_id, c.category_name, SUM(oi.unit_price * oi.quantity) AS top_3_sales_amount
FROM Categories c
JOIN 
    Products p ON c.category_id = p.category_id
JOIN 
    Order_Items oi ON p.product_id = oi.product_id
GROUP BY 
    c.category_id, c.category_name
ORDER BY 
    top_3_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- We can solve this problem by finding the users who have placed orders for all products in the Toys & Games category and
-- by comparing their order history against the total number of items in that category.
SELECT u.user_id, u.username
FROM Users u
JOIN 
    Orders o ON u.user_id = o.user_id
JOIN 
    Order_Items oi ON o.order_id = oi.order_id
JOIN 
    Products p ON oi.product_id = p.product_id
JOIN 
    Categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Toys & Games'
GROUP BY u.user_id, u.username
HAVING 
    COUNT(DISTINCT p.product_id) = (
        SELECT COUNT(DISTINCT product_id)
        FROM Products
        WHERE category_id = (
            SELECT category_id
            FROM Categories
            WHERE category_name = 'Toys & Games'
        )
    );
-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
-- Retrieve products with the highest price within each category

-- We can find the most expensive product in each category by using the RANK function and ranking
-- the products by their price within their own categories.
-- We can then filter the results to get the products with the highest price in each category
SELECT product_id, product_name, category_id, price
FROM (
    SELECT p.product_id, p.product_name, p.category_id, p.price,
        RANK() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) AS price_rank
    FROM Products p
) AS RankedProducts
WHERE price_rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- We can use two CTEs for this problem: 
-- The first CTE (dates_ordered) calculates the previous two order dates for each order.
-- The second CTE (check_consecutive) then counts sequences of consecutive order dates. 
-- Finally, the main query filters out users with at least 3 consecutive days of orders and selects their user ID and username.

WITH dates_ordered AS (
    SELECT o.user_id, o.order_date,
        LAG(o.order_date, 1) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_order_date,
        LAG(o.order_date, 2) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_order_date_2
    FROM Orders o
), check_consecutive AS (
    SELECT user_id, COUNT(*) OVER (PARTITION BY user_id, CASE WHEN order_date = prev_order_date + INTERVAL '1 day' AND order_date = prev_order_date_2 + INTERVAL '2 day' THEN 1 ELSE NULL END) AS consecutive_days
    FROM dates_ordered
)
SELECT DISTINCT u.user_id, u.username
FROM check_consecutive co
JOIN 
    Users u ON co.user_id = u.user_id
WHERE 
    co.consecutive_days >= 3;