-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Problem 9 --
SELECT DISTINCT category_data.category_id, category_data.category_name, SUM(order_data.total_amount) AS total_sales_amount FROM order_data -- total_category_amount stores the total sales amount for a category
JOIN order_items_data 
    ON order_data.order_id = order_items_data.order_id
JOIN product_data 
    ON order_items_data.product_id = product_data.product_id
JOIN category_data 
    ON product_data.category_id = category_data.category_id
GROUP BY category_data.category_id, category_data.category_name -- Group total_sales_amount by the category_id and category_name
ORDER BY total_sales_amount DESC -- Order the categories by the total sales amount
LIMIT 3; -- Only include the top 3 categories with the highest sales amount

-- Problem 10 --
SELECT DISTINCT user_data.user_id, user_data.username FROM user_data
JOIN order_data ON user_data.user_id = order_data.user_id
WHERE NOT EXISTS (SELECT product_data.product_id FROM product_data
                JOIN category_data ON product_data.category_id = category_data.category_id
                WHERE category_data.category_name = "Toys & Games" AND NOT EXISTS -- Check if the product is in the "Toys & Games" category
                (SELECT 1 FROM order_data 
                JOIN order_items_data ON order_data.order_id = order_items_data.order_id
                WHERE user_data.user_id = order_data.user_id AND product_data.product_id = order_items_data.product_id)); -- Check if the user who ordered the product actually ordered a product from the "Toys & Games" category

-- Problem 11 --
WITH category_price_data AS (SELECT product_id, product_name, category_id, price, 
                            ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) -- Rank the products price (lowest to highest) based on their category
                            AS price_rank FROM product_data)

SELECT product_id, product_name, category_id, price FROM category_price_data
WHERE price_rank = 1; -- Only include the products with the highest price based on their category

-- Problem 12 --
WITH order_date_data AS (SELECT user_data.user_id, 
                                user_data.username, 
                                order_data.order_date,
                                LAG(order_data.order_date) OVER (PARTITION BY order_data.user_id ORDER BY order_data.order_date) AS prev_date_1, 
                                LAG(order_data.order_date, 2) OVER (PARTITION BY order_data.user_id ORDER BY order_data.order_date) AS prev_date_2 -- Include the 3 previous dates which a user has placed an order for, NULL if there are no previous dates
                                FROM order_data
                        JOIN user_data ON order_data.user_id = user_data.user_id)

SELECT DISTINCT user_id, username FROM order_date_data
WHERE   prev_date_1 IS NOT NULL 
        AND prev_date_2 IS NOT NULL -- Make sure the previous dates are not NULL
        AND DATEDIFF(order_date, prev_date_1) = 1
        AND DATEDIFF(prev_date_1, prev_date_2) = 1; -- Only include the user if the date difference between all the 3 dates is 1
