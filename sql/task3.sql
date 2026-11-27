-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- We use a series of INNER JOINS to reach the category ID and group based on this
SELECT 
    c.category_id, 
    c.category_name, 
    SUM(oi.quantity * oi.unit_price) AS total_sales -- Using quantity * price to reduce num of joins
FROM Categories c
JOIN Products p ON p.category_id = c.category_id
JOIN Order_Items oi ON oi.product_id = p.product_id
GROUP BY c.category_id
ORDER BY total_sales DESC -- Sorting here is the only option since there are 3 categories we need to find.
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- CTE (Purpose: Find the total number of products that fall under the Toys & Games category)
WITH total_toy_products AS ( -- From Problem 1
    SELECT 
        p.product_id
    FROM Products p
    JOIN Categories c ON p.category_id = c.category_id -- We must use this INNER JOIN to reach category_name
    WHERE c.category_name = 'Toys & Games'
)

-- Main Query
SELECT 
    u.user_id, 
    u.username
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items oi ON oi.order_id = o.order_id
GROUP BY u.user_id, u.username
-- The purpose of the HAVING is to find the users that have a set of distinct products that are the same number as 
-- the total toy products
HAVING COUNT(DISTINCT oi.product_id) = (  -- The DISTINCT is used to address the ties case, discussed in Problem 6
    SELECT 
        COUNT(product_id) 
    FROM total_toy_products);

-- There could be a case where another category has the same number of products, but the DISTINCT should be 
-- enough to address it in this scope.

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
-- CTE (Purpose: Find the prices ranked by ROW NUMBER )
WITH ranked_prices AS (
    SELECT
        product_id, 
        product_name, 
        category_id, 
        price,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS rank_within_category -- Partition by category in order to distinguish them 
    FROM Products
)
-- Main Query
SELECT product_id, product_name, category_id,price
FROM ranked_prices
WHERE rank_within_category = 1; -- The highest rank would be 1 (AKA MAX)

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
-- CTE (Purpose: Find previous day dates)
WITH lagged_orders AS (
    SELECT user_id, 
           order_date,
           LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) as previous_date
    FROM Orders
), 
-- CTE (Purpose: Find date differences that are equal to 1)
date_differences AS ( -- Problem 8
    SELECT DISTINCT u.user_id, 
                    u.username, 
                    o.order_date,
                    LAG(o.order_date) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS previous_date
    FROM Users u
    JOIN Orders o ON o.user_id = u.user_id
    JOIN lagged_orders l ON u.user_id = l.user_id
    WHERE o.order_date - l.previous_date = 1
)
-- Main Query
SELECT user_id, username
FROM date_differences
GROUP BY user_id, username
HAVING COUNT(*) >= 2; -- If the query based on Partition is >= 2 (including current date, which would make it 3)
