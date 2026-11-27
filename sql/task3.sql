-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Retrieve the top 3 categories with the highest total sales amount.
SELECT TOP 3
    c.category_id,                           -- Selects the category ID from the 'Categories' table.
    c.category_name,                         -- Selects the category name.
    SUM(oi.quantity * oi.unit_price) AS total_sales -- Calculates the total sales amount for each category.

FROM 
    Categories c                             -- Specifies the 'Categories' table.

JOIN 
    Products p ON c.category_id = p.category_id  -- Joins the 'Products' table with 'Categories' on the category ID.
    -- This join links each product to its respective category.

JOIN 
    Order_Items oi ON p.product_id = oi.product_id  -- Joins 'Order_Items' with 'Products' on the product ID.
    -- This join allows us to access the order details for each product.

JOIN 
    Orders o ON oi.order_id = o.order_id          -- Joins 'Orders' with 'Order_Items' on the order ID.
    -- This join is necessary to include the order data for each order item.

GROUP BY 
    c.category_id, c.category_name                -- Groups the results by category ID and name.
    -- Grouping is essential for aggregating sales data by category.

ORDER BY 
    total_sales DESC                              -- Orders the results by total sales in descending order.
    -- Ensures that the categories with the highest total sales are listed first.


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT 
    u.user_id,       -- Selects the user ID from the 'Users' table.
    u.username       -- Selects the username from the 'Users' table.
FROM 
    Users u          -- Specifies the 'Users' table.

JOIN 
    Orders o ON u.user_id = o.user_id           -- Joins 'Orders' with 'Users' on the user ID.
    -- This join connects each user to their orders.

JOIN 
    Order_Items oi ON o.order_id = oi.order_id  -- Joins 'Order_Items' with 'Orders' on the order ID.
    -- This join links each order to its respective items.

JOIN 
    Products p ON oi.product_id = p.product_id  -- Joins 'Products' with 'Order_Items' on the product ID.
    -- This join retrieves product details for each order item.

JOIN 
    Categories c ON p.category_id = c.category_id -- Joins 'Categories' with 'Products' on the category ID.
    -- This join filters products by their categories.

WHERE 
    c.category_name = 'Toys & Games'            -- Filters to include only products in the 'Toys & Games' category.

GROUP BY 
    u.user_id, u.username
    -- Groups the results by user to aggregate their product orders.

-- The HAVING clause ensures that only users who have ordered every distinct product in the 'Toys & Games' category are selected.
HAVING 
    COUNT(DISTINCT p.product_id) = (
        -- Subquery to count the total number of distinct products in the 'Toys & Games' category.
        SELECT COUNT(DISTINCT product_id)
        FROM Products
        WHERE category_id = (
            -- Nested subquery to find the category_id for 'Toys & Games'.
            SELECT category_id
            FROM Categories
            WHERE category_name = 'Toys & Games'
        )
    );

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Selecting the required columns from the subquery result
SELECT 
    product_id,
    product_name,
    category_id,
    price
FROM (
    -- Subquery to rank products within each category by price
    SELECT 
        Products.product_id,           -- Selecting product ID
        Products.product_name,         -- Selecting product name
        Products.category_id,          -- Selecting category ID to partition the data
        Products.price,                -- Selecting price to order and rank the products
        -- Using ROW_NUMBER() to assign a rank to each product within its category based on price in descending order
        ROW_NUMBER() OVER (
            PARTITION BY Products.category_id 
            ORDER BY Products.price DESC
        ) AS rn
    FROM 
        Products                       -- From the Products table
) AS RankedProducts                     -- Naming the subquery as RankedProducts for clarity
WHERE 
    rn = 1;                             -- Filtering to get only the top-ranked product in each category (highest price)


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
-- Selecting distinct user IDs and usernames
SELECT DISTINCT
    u.user_id,
    u.username
FROM (
    -- Subquery to calculate the dates of the next two orders for each order
    SELECT
        o.user_id,                         -- User ID for each order
        o.order_date,                      -- Date of the current order
        -- Use LEAD to find the date of the next order (1 day ahead)
        LEAD(o.order_date, 1) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS next_order_date,
        -- Use LEAD to find the date of the order after the next (2 days ahead)
        LEAD(o.order_date, 2) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS next_next_order_date
    FROM
        Orders o                           -- From the Orders table
) AS ordered_dates                         -- Alias for the subquery
JOIN Users u ON ordered_dates.user_id = u.user_id   -- Joining with Users table to get user details

-- The WHERE clause conditions combined ensure that there are two consecutive 1-day gaps, which together indicate 3 consecutive days of orders.
WHERE
    -- Filtering for records where there are orders on three consecutive days
    DATEDIFF(ordered_dates.next_order_date, ordered_dates.order_date) = 1 AND  -- Difference of 1 day between the current and next order
    DATEDIFF(ordered_dates.next_next_order_date, ordered_dates.next_order_date) = 1;  -- Difference of 1 day between the next and the order after next