-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- For each category, calculate sum of sales for all order items, and then 
-- select top 3 categories
SELECT
    c.category_id,
    c.category_name,
    SUM(oi.unit_price * oi.quantity) AS total_sales
FROM Order_Items oi 
LEFT JOIN Products p
    ON oi.product_id = p.product_id
LEFT JOIN Categories c 
    ON p.category_id = c.category_id
GROUP BY c.category_id
ORDER BY total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- For each user, keep in result if # of unique products in Toys & Games ordered 
-- accross all their orders equals total # of unique products in Toys & Games
SELECT 
    u.user_id,
    u.username
FROM Users u   
LEFT JOIN Orders o 
    ON u.user_id = o.order_id
LEFT JOIN Order_items oi 
    ON o.order_id = oi.order_id
LEFT JOIN Products p
    ON oi.product_id = p.product_id
LEFT JOIN Categories c 
    ON p.category_id = c.category_id
WHERE c.category_name = 'Toys & Games'
GROUP BY u.user_id
HAVING (COUNT(DISTINCT(p.product_id))) = (
    -- Get # of products in Toys & Games category
    SELECT COUNT(p.product_id)
    FROM Products p
    LEFT JOIN Categories c
        ON p.category_id = c.category_id
    WHERE c.category_name = 'Toys & Games'
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Rank products by price descending for each category and keep products with 
-- rank of 1 in final result
SELECT 
    p.product_id,
    p.product_name,
    p.category_id,
    p.price
FROM Products p
LEFT JOIN (
    SELECT
        product_id,
        price,
        RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS price_rank
    FROM Products p
) AS pr ON p.product_id = pr.product_id
WHERE pr.price_rank = 1;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- For each user, keep in result if they have an order where the difference 
-- between order_date and order_date of their last order (last_date) is 1 day,
-- and difference between last_date and date of their last-to-last order is 1 day
SELECT DISTINCT
    u.user_id,
    u.username
FROM Users u
LEFT JOIN (
    SELECT
        user_id,
        order_date,
        LAG(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) AS last_date,
        LAG(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS second_last_date
    FROM Orders
) AS dates ON u.user_id = dates.user_id
WHERE order_date - last_date = 1
AND last_date - second_last_date = 1;