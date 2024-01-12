-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT 
    Categories.category_id, 
    Categories.category_name, 
    SUM(Order_Items.quantity * Order_Items.unit_price) AS total_sales
FROM Categories
JOIN Products ON Categories.category_id = Products.category_id
JOIN Order_Items ON Products.product_id = Order_Items.product_id
JOIN Orders ON Order_Items.order_id = Orders.order_id
GROUP BY Categories.category_id, Categories.category_name
ORDER BY total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT Users.user_id, Users.username
FROM Users
WHERE NOT EXISTS (
    SELECT Products.product_id
    FROM Products
    JOIN Categories ON Products.category_id = Categories.category_id
    WHERE Categories.category_name = 'Toys & Games'
    AND NOT EXISTS (
        SELECT Orders.order_id
        FROM Orders
        JOIN Order_Items ON Orders.order_id = Order_Items.order_id
        WHERE Order_Items.product_id = Products.product_id
        AND Orders.user_id = Users.user_id
    )
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH RankedProducts AS (
    SELECT 
        Products.product_id, 
        Products.product_name, 
        Products.category_id, 
        Products.price,
        ROW_NUMBER() OVER (PARTITION BY Products.category_id ORDER BY Products.price DESC) AS price_rank
    FROM Products
)
SELECT 
    product_id, 
    product_name, 
    category_id, 
    price
FROM RankedProducts
WHERE price_rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH OrderedUsers AS (
    SELECT 
        user_id, 
        order_date,
        LAG(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date,
        LAG(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date_2
    FROM Orders
),
ConsecutiveOrders AS (
    SELECT 
        user_id,
        order_date,
        CASE 
            WHEN order_date = DATEADD(day, 1, prev_order_date) AND prev_order_date = DATEADD(day, 1, prev_order_date_2) THEN 1
            ELSE 0 
        END AS is_consecutive
    FROM OrderedUsers
)
SELECT DISTINCT Users.user_id, Users.username
FROM Users
JOIN ConsecutiveOrders ON Users.user_id = ConsecutiveOrders.user_id
WHERE ConsecutiveOrders.is_consecutive = 1;
