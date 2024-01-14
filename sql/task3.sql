-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT 
    c.category_id,
    c.category_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales_amount
FROM 
    Categories c
JOIN 
    Products p ON c.category_id = p.category_id
JOIN 
    Order_Items oi ON p.product_id = oi.product_id
GROUP BY 
    c.category_id, c.category_name
ORDER BY 
    total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT 
    u.user_id,
    u.username
FROM 
    Users u
JOIN 
    Orders o ON u.user_id = o.user_id
JOIN 
    Order_Items oi ON o.order_id = oi.order_id
JOIN 
    Products p ON oi.product_id = p.product_id
JOIN 
    Categories c ON p.category_id = c.category_id
WHERE 
    c.category_name = 'Toys & Games'
GROUP BY 
    u.user_id, u.username
HAVING 
    COUNT(DISTINCT p.product_id) = (
        SELECT COUNT(*)
        FROM Products p
        JOIN Categories c ON p.category_id = c.category_id
        WHERE c.category_name = 'Toys & Games'
    );

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH ProductsRanked AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.category_id,
        p.price,
        RANK() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) as price_rank
    FROM 
        Products p
)
SELECT 
    product_id,
    product_name,
    category_id,
    price
FROM 
    ProductsRanked
WHERE 
    price_rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH ConsOrders AS (
    SELECT user_id, order_date,
    LAG(order_date, 1) OVER (PARTITION BY user_id BY order_date) AS PrevOrder,
    LAG(order_date, 2) OVER (PARTITION BY user_id BY order_date) AS PrevOrder_2,
    FROM Orders
), 
SELECT user_id 
FROM ConsOrders