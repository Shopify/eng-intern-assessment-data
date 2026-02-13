/*
-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- This SQL query identifies the top 3 categories based on total sales amount.
-- The output includes the category ID, category name, and the total sales amount.
-- The query uses joins and aggregate functions to calculate total sales per category.
*/

-- Selecting category details and calculating the total sales amount
SELECT 
    c.category_id,                                
    c.category_name,                              
    SUM(oi.quantity * oi.unit_price) AS total_sales_amount  -- Calculating total sales for each category 
FROM 
    categories c                                  
-- Joining categories with products on category ID
JOIN 
    products p ON c.category_id = p.category_id   
-- Joining products with order items on product ID
JOIN 
    order_items oi ON p.product_id = oi.product_id 
GROUP BY 
    c.category_id,
    c.category_name
ORDER BY 
    total_sales_amount DESC
LIMIT 3;


/*
Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
This query identifies users who have ordered every product in the "Toys & Games" category.
The result includes the user ID and username.
The query uses multiple joins and a subquery in the HAVING clause to ensure completeness of orders within the category.
*/

SELECT 
    u.user_id,
    u.username
FROM 
    users u
JOIN 
    orders o ON u.user_id = o.user_id
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
JOIN 
    categories c ON p.category_id = c.category_id
WHERE 
    c.category_name = 'Toys & Games'
GROUP BY 
    u.user_id, u.username
-- Ensuring that users have ordered all products in the category	
HAVING 
    -- Counting the distinct products ordered by each user in the category
    COUNT(DISTINCT p.product_id) = 
    -- Subquery to get the total number of products in the "Toys & Games" category
    (SELECT COUNT(product_id) FROM products WHERE category_id = (SELECT category_id FROM categories WHERE category_name = 'Toys & Games'));

/*
Problem 11: Retrieve the products that have the highest price within each category
This query identifies products within each category that have the highest price.
The output includes product ID, product name, category ID, and price.
It uses a Common Table Expression (CTE) with the DENSE_RANK window function.
*/

-- Create a Common Table Expression (CTE) named RankedProducts
WITH RankedProducts AS (
    -- Select product details and calculate the rank of each product based on price within its category
    SELECT 
        p.product_id,          
        p.product_name,        
        p.category_id,         
        p.price,              
        -- Use DENSE_RANK to rank products based on price within each category
        DENSE_RANK() OVER (
            PARTITION BY p.category_id   
            ORDER BY p.price DESC        
        ) as rank                        
    FROM 
        products p                      
)

-- Main query to select from the CTE
SELECT 
    product_id,           
    product_name,           
    category_id,             
    price                   
FROM 
    RankedProducts           
WHERE 
    rank = 1;                


/*
Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
This query identifies users who have made orders on at least three consecutive days.
The output includes the user ID and username.
The query utilizes Common Table Expressions (CTEs) and window functions.
*/

-- First CTE: OrderedDates
WITH OrderedDates AS (
    SELECT 
        u.user_id,
        u.username,
        o.order_date,
        -- Calculate the difference in days between the current order date and the next order date
        LEAD(o.order_date) OVER (PARTITION BY u.user_id ORDER BY o.order_date) - o.order_date AS date_diff
    FROM 
        users u
    JOIN 
        orders o ON u.user_id = o.user_id
),
-- Second CTE: ConsecutiveOrders
ConsecutiveOrders AS (
    SELECT 
        user_id,
        username,
        order_date,
        -- Sum the consecutive ordering days; when there's a break in consecutive ordering, the sum restarts
        SUM(CASE WHEN date_diff = 1 THEN 0 ELSE 1 END) OVER (PARTITION BY user_id ORDER BY order_date) AS order_group
    FROM 
        OrderedDates
)
SELECT 
    user_id,
    username
FROM 
    ConsecutiveOrders
GROUP BY 
    user_id, username, order_group
HAVING 
    COUNT(*) >= 3 -- Filter for groups where the count of consecutive orders is at least 3
ORDER BY 
    user_id;
