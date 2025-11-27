-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
WITH category_sales AS ( -- CTE to calculate total sales for each category based on category_id
    SELECT
        c.category_id, 
        c.category_name,
        SUM(oi.quantity * oi.unit_price) AS total_sales
    FROM
        Categories c
        JOIN Products p ON c.category_id = p.category_id
        JOIN Order_Items oi ON p.product_id = oi.product_id
    GROUP BY
        c.category_id
)
SELECT
    category_id,
    category_name,
    total_sales
FROM
    category_sales
ORDER BY
    total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT
    u.user_id, 
    u.username
FROM Users u
    JOIN Orders o ON u.user_id = o.user_id
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
    JOIN Categories c ON p.category_id = c.category_id
WHERE
    c.category_name = 'Toys & Games'
GROUP BY
    u.user_id
HAVING
    COUNT(DISTINCT p.product_id) = (-- Subquery to count the total number of unique products in the Toys & Games category
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
WITH ranked_products AS (
    SELECT
        p.product_id, 
        p.product_name, 
        p.category_id, 
        p.price,
        -- Ranking products by price within each category
        RANK() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) as price_rank
    FROM Products p
)
-- Selecting products that rank highest in their category
SELECT
    product_id, 
    product_name, 
    category_id, 
    price
FROM
    ranked_products
WHERE
    price_rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH order_sequences AS (
    SELECT 
        o.user_id,
        o.order_date,
        -- Assign a row number to each order per user
        ROW_NUMBER() OVER (PARTITION BY o.user_id ORDER BY o.order_date) as sequence_num
    FROM Orders o
),
consecutive_groups AS (
    SELECT 
        user_id,
        order_date,
        -- Subtracting the sequence number from the order date to identify consecutive groups
        DATE(order_date) - INTERVAL '1 day' * (sequence_num - 1) as group_id
    FROM order_sequences
)
-- Selecting users with at least a 3-day consecutive ordering streak
SELECT DISTINCT
    u.user_id,
    u.username
FROM consecutive_groups cg
    JOIN Users u ON cg.user_id = u.user_id
GROUP BY 
    cg.user_id, u.username, cg.group_id
HAVING 
    COUNT(*) >= 3;