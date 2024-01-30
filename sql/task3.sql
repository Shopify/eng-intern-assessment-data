-- Problem 9:
-- Question: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
--
-- CTE TotalSalesPerCategory calculates the total sales for each category
-- Joins Categories, Products, Order_Items and Orders tables.
-- Use Coalesce to exclude categories with no sales
-- orders the result by total_sales_amount in descending order and limits the result to the top 3 categories.
WITH TotalSalesPerCategory AS (
    SELECT
        c.category_name,
        c.category_id,
        COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_sales_amount
    FROM
        Categories c
        LEFT JOIN Products p ON c.category_id = p.category_id       --join Products and Categories tables
        LEFT JOIN Order_Items oi ON p.product_id = oi.product_id    --join Products and Order_Items tables
        LEFT JOIN Orders o ON oi.order_id = o.order_id              --join Orders and Order_Items tables
    GROUP BY
        c.category_id, c.category_name
)
SELECT
    --Display category ID, category name, and total sales amount
    cts.category_id,
    cts.category_name,
    cts.total_sales_amount
FROM
    TotalSalesPerCategory cts
ORDER BY
    cts.total_sales_amount DESC     --orders the result by total_sales_amount in descending order
LIMIT 3;                            --Need the top 3 categories.

-- Problem 10:
-- Question: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
--
-- CTE ProductsInToysAndGames calculates the total sales for each category
-- Join the Users, Orders, Order_Items, and the ProductsInToysAndGames CTE to identify users who have ordered products in the "Toys & Games" category.
--
WITH ProductsInToysAndGames AS (
    SELECT
        p.product_id
    FROM
        Categories c
        JOIN Products p ON c.category_id = p.category_id  -- join the Products and the Category Table
    WHERE
        c.category_name = 'Toys & Games'
)
SELECT
    -- Display the user_id and username
    u.user_id,
    u.username
FROM
    Users u
    JOIN Orders o ON u.user_id = o.user_id           -- join the user and Orders table
    JOIN Order_Items oi ON o.order_id = oi.order_id  -- Joins the order_items and Orders Table
    JOIN ProductsInToysAndGames ptg ON oi.product_id = ptg.product_id  -- Joins the cte to the order_items table
GROUP BY
    u.user_id, u.username
HAVING
    COUNT(DISTINCT ptg.product_id) = (SELECT COUNT(*) FROM ProductsInToysAndGames); -- Ensure the count of distinct product_ids equals the count of the number of products in the Toys and Games category.

-- Problem 11:
-- Question: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
--
--  Select the product ID, product name, category ID, and the maximum price within each category.
SELECT p.product_id, p.product_name, c.category_id, MAX(p.price) FROM Products p
    JOIN Categories c
        ON p.category_id=c.category_id -- join the Products and Category Tables
    GROUP BY c.category_id  -- Maximum needs to be determined for each category

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
--
--The UsersWithDateDiff CTE uses the LEAD and LAG  functions to get the next and previous order dates for each user.
--This is used to check for consecutive days.
-- A second CTE (UsersWithDateDiffNominal) is used to calculates the date differences before and after each order.
-- The CAST function is used to convert the Julian day differences to integers.
-- The WHERE clause filters the results to include only users whose orders are on consecutive days, as indicated by date_diff_before = 1 AND date_diff_after = 1.
WITH
    UsersWithDateDiff AS (
        SELECT 
            o.user_id, 
            u.username, 
            o.order_date, 
            LAG(o.order_date,1) OVER (PARTITION BY o.user_id ORDER BY o.order_date) previous_order_date, --Get previous order date
            LEAD(o.order_date,1) OVER (PARTITION BY o.user_id ORDER BY o.order_date) next_order_date     --Get Next order date
        FROM Orders o
            JOIN Users u
                ON o.user_id=u.user_id  -- Join Users and Orders Table
            ORDER BY 1,3
    ),
    UsersWithDateDiffNominal AS (
        SELECT
            user_id, 
            username,
            order_date,
            previous_order_date,
            next_order_date,
            Cast((JulianDay(order_date) - JulianDay(previous_order_date)) As Integer) date_diff_before, -- Use Julian for simplicity
            Cast((JulianDay(next_order_date) - JulianDay(order_date)) As Integer) date_diff_after
        FROM UsersWithDateDiff
        --WHERE Cast((JulianDay(order_date) - JulianDay(previous_order_date)) As Integer) = 1
    )
SELECT 
    user_id, --Result displays User_id and Username
    username
FROM UsersWithDateDiffNominal
WHERE date_diff_before&date_diff_after