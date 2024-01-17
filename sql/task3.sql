-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Solution 9:
SELECT 
    c.category_id, 
    c.category_name, 
    SUM(oi.quantity * oi.unit_price) AS total_sales_amount
FROM 
    Categories c
-- Joining with the Products table to link products to their categories.
JOIN 
    Products p ON c.category_id = p.category_id
-- Joining with the Order_Items table to get the sales data for each product.
JOIN 
    Order_Items oi ON p.product_id = oi.product_id
-- Grouping the results by category ID and category name.
-- This is necessary for the SUM aggregate function to calculate total sales per category.
GROUP BY 
    c.category_id, c.category_name
-- Ordering the results by total sales amount in descending order
-- and limiting the results to the top 3 categories.
ORDER BY 
    total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Solution 10:
-- Selecting user ID and username.
SELECT 
    u.user_id, 
    u.username
FROM 
    Users u
-- Joining with the Orders table to link users to their orders.
JOIN 
    Orders o ON u.user_id = o.user_id
-- Joining with the Order_Items table to link orders to their items.
JOIN 
    Order_Items oi ON o.order_id = oi.order_id
-- Joining with the Products table to link order items to products.
JOIN 
    Products p ON oi.product_id = p.product_id
-- Joining with the Categories table to categorize the products.
JOIN 
    Categories c ON p.category_id = c.category_id
-- Where clause to filter only products in the 'Toys & Games' category.
WHERE 
    c.category_name = 'Toys & Games'
-- Grouping by user ID and username.
GROUP BY 
    u.user_id, u.username
-- Having clause to ensure users have ordered all products in the category.
-- COUNT(DISTINCT p.product_id) counts the distinct products ordered by the user in the category.
-- (SELECT COUNT(*) FROM Products WHERE category_id = c.category_id) counts the total number of products in the category.
HAVING 
    COUNT(DISTINCT p.product_id) = (SELECT COUNT(*) FROM Products WHERE category_id = c.category_id);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Solution 11: 
-- Selecting the desired columns from a subquery that ranks products by price within each category.
SELECT 
    subq.product_id, 
    subq.product_name, 
    subq.category_id, 
    subq.price
-- Subquery to rank products within each category by price and select relevant columns.
FROM (
    SELECT 
        p.product_id, 
        p.product_name, 
        p.category_id, 
        p.price,
        -- Using the ROW_NUMBER() window function to assign a rank to each product within its category,
        -- ordered by price in descending order. The product with the highest price gets the rank 1.
        ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) AS rn
    FROM 
        Products p
) AS subq
-- Filtering to only include the products with the highest price in their category (rank 1).
WHERE 
    subq.rn = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Solution 12:
SELECT 
    DISTINCT u.user_id, 
    u.username
FROM 
    Users u
-- Joining with a subquery that analyzes ordering patterns.
JOIN (
    -- This subquery calculates the difference in days between each order and the previous order for the same user,
    -- and then identifies sequences of consecutive ordering days.
    SELECT 
        o.user_id,
        o.order_date,
        LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_order_date,
        -- Creating a group identifier for consecutive days.
        SUM(CASE WHEN DATEDIFF(o.order_date, LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date)) = 1 THEN 0 ELSE 1 END) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS day_group
    FROM 
        Orders o
) AS subq ON u.user_id = subq.user_id
-- Joining with another subquery to count the length of each consecutive day sequence.
JOIN (
    -- This subquery counts the number of orders in each group of consecutive days for each user.
    SELECT 
        user_id,
        day_group,
        COUNT(*) AS consecutive_days
    FROM 
        (SELECT 
            o.user_id,
            o.order_date,
            -- Repeating the calculation of the day_group identifier.
            SUM(CASE WHEN DATEDIFF(o.order_date, LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date)) = 1 THEN 0 ELSE 1 END) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS day_group
        FROM 
            Orders o) AS inner_subq
    GROUP BY 
        user_id, day_group
) AS day_count_subq ON u.user_id = day_count_subq.user_id AND subq.day_group = day_count_subq.day_group
-- Filtering for users with at least 3 consecutive ordering days.
WHERE 
    day_count_subq.consecutive_days >= 3;

-- Thank you for this project opportunity, really appreciate it!
-- kindly, Alain 