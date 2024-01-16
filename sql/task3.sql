-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY c.category_id, c.category_name
-- Ordering the results by total sales in descending order to find the top categories.
ORDER BY total_sales DESC 
-- Limiting the results to the top 3 categories.
LIMIT 3; 

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT u.user_id, u.username
FROM Users u
JOIN Orders o ON u.user_id = o.user_id 
JOIN Order_Items oi ON o.order_id = oi.order_id 
JOIN Products p ON oi.product_id = p.product_id
-- Joining with the Categories table to focus on the "Toys & Games" category.
JOIN Categories c ON p.category_id = c.category_id AND c.category_name = 'Toys & Games'
GROUP BY u.user_id
-- HAVING clause calculates the total number of products in the "Toys & Games" category.
HAVING COUNT(DISTINCT p.product_id) = (
    SELECT COUNT(*)
    FROM Products p
    JOIN Categories c ON p.category_id = c.category_id
    WHERE c.category_name = 'Toys & Games'
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT ranked_products.product_id, ranked_products.product_name, ranked_products.category_id, ranked_products.price
FROM (
    -- Subquery to rank products within each category based on price.
    SELECT p.product_id, p.product_name, p.category_id, p.price,
        -- Ranks the products within each category based on their price in descending order
           RANK() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) AS price_rank 
    FROM Products p
) AS ranked_products
-- Filtering to select only the products with the highest price within their category.
WHERE ranked_products.price_rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT DISTINCT u.user_id, u.username
FROM Users u
JOIN (
    SELECT o.user_id,
           o.order_date,
        -- Get each order's previous and next order dates for each user using LAG and LEAD function
           LAG(o.order_date, 1) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_order_date,
           LEAD(o.order_date, 1) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS next_order_date
    FROM Orders o
) AS order_dates ON u.user_id = order_dates.user_id
WHERE 
    -- Checking for orders on 3 consecutive days which used DATEDIFF function to calculates the difference in days between consecutive orders.
    (DATEDIFF(order_dates.order_date, order_dates.prev_order_date) = 1 AND DATEDIFF(order_dates.next_order_date, order_dates.order_date) = 1)
    OR 
    (DATEDIFF(order_dates.order_date, order_dates.prev_order_date) = 1 AND DATEDIFF(order_dates.order_date, LAG(order_dates.order_date, 2) OVER (PARTITION BY order_dates.user_id ORDER BY order_dates.order_date)) = 2)
    OR 
    (DATEDIFF(LEAD(order_dates.order_date, 2) OVER (PARTITION BY order_dates.user_id ORDER BY order_dates.order_date), order_dates.order_date) = 2 AND DATEDIFF(order_dates.next_order_date, order_dates.order_date) = 1);