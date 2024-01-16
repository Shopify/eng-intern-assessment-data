-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
    
    SELECT category_data.category_id, category_data.category_name, SUM(order_items_data.quantity*order_items_data.unit_price) AS total_sales_amount
    FROM product_data 
    JOIN category_data ON product_data.category_id = category_data.category_id
    JOIN order_items_data ON order_items_data.product_id = product_data.product_id
    GROUP BY category_data.category_name
    ORDER BY total_sales_amount DESC
    LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
    
    SELECT user_data.user_id, user_data.username
    FROM user_data
    WHERE user_data.user_id IN (
        SELECT DISTINCT user_data.user_id
        FROM user_data
        JOIN order_data ON order_data.user_id = user_data.user_id
        JOIN order_items_data ON order_items_data.order_id = order_data.order_id
        JOIN product_data ON order_items_data.product_id = product_data.product_id
        JOIN category_data ON product_data.category_id = category_data.category_id
        WHERE category_data.category_name = 'Toys & Games' -- check if the category is Toys & Games
        -- check if the user has ordered all products in the Toys & Games category, so total number of products in the category is the same as the number of products ordered by the user
        GROUP BY user_data.user_id HAVING COUNT(DISTINCT product_data.product_id) = (SELECT COUNT(DISTINCT product_id) FROM product_data WHERE category_id = 5)
    );

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
    
    SELECT category_data.category_id, product_data.product_id, product_data.product_name, product_data.price
    FROM product_data
    RIGHT JOIN category_data ON product_data.category_id = category_data.category_id
    WHERE (product_data.category_id, product_data.price) IN (
        SELECT category_id, MAX(price) -- get the max price for each category
        FROM product_data
        GROUP BY category_id
    )
    ORDER BY category_data.category_id;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
    -- This query retrieves the users who have placed orders on consecutive days for at least 3 days
    
    SELECT DISTINCT user_data.user_id, user_data.username
    FROM order_data
    JOIN user_data ON order_data.user_id = user_data.user_id
    WHERE EXISTS (
        SELECT 1
        FROM order_data AS o1
        JOIN order_data AS o2 ON o1.user_id = o2.user_id
        -- Check if there is any consecutive order dates (1 day apart)
        WHERE o1.order_date = DATE_SUB(o2.order_date, INTERVAL 1 DAY)
        AND o1.order_id <> o2.order_id
        AND o1.user_id = order_data.user_id
    )
    AND EXISTS (
        SELECT 1
        FROM order_data AS o1
        JOIN order_data AS o2 ON o1.user_id = o2.user_id
        -- Check if there is any consecutive order dates (2 days apart)
        WHERE o1.order_date = DATE_SUB(o2.order_date, INTERVAL 2 DAY)
        AND o1.user_id = order_data.user_id
    );
