-- Problem 9:--Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- select only wahts mentioned
SELECT 
    Categories.category_id, 
    Categories.category_name, 
    SUM(Order_Items.quantity * Order_Items.unit_price) AS total_sales -- calculate total sales amount
FROM Categories
INNER JOIN Products ON Categories.category_id = Products.category_id
INNER JOIN Order_Items ON Products.product_id = Order_Items.product_id
INNER JOIN Orders ON Order_Items.order_id = Orders.order_id -- inner join all 4 tables
GROUP BY Categories.category_id, Categories.category_name
ORDER BY total_sales DESC
LIMIT 3; -- only show top 3


-- Problem 10:--Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- select only whats mentioned
SELECT 
    Users.user_id, 
    Users.username
FROM Users
INNER JOIN Orders ON Users.user_id = Orders.user_id
INNER JOIN Order_Items ON Orders.order_id = Order_Items.order_id
INNER JOIN Products ON Order_Items.product_id = Products.product_id
INNER JOIN Categories ON Products.category_id = Categories.category_id -- inner join all 5
WHERE Categories.category_name = 'Toys & Games' -- take category name
GROUP BY Users.user_id, Users.username
-- use subquery
-- count distinct toys&games products for each user
-- then compare to total number of products in toys&games
HAVING COUNT(DISTINCT Products.product_id) = (
    SELECT COUNT(*) 
    FROM Products
    INNER JOIN Categories ON Products.category_id = Categories.category_id
    WHERE Categories.category_name = 'Toys & Games'
);

-- Problem 11:--Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint You may need to use subqueries, joins, and window functions to solve this problem.

-- use CTE
-- rank products by its price within category
WITH RankedProductsByCate AS (
    SELECT 
        Products.product_id, 
        Products.product_name, 
        Products.category_id,
        Products.price,
        -- use partition to reset rank for each category
        RANK() OVER (PARTITION BY Products.category_id ORDER BY Products.price DESC) as price_rank
    FROM Products
)
-- pretty simple main query
SELECT 
    product_id, 
    product_name, 
    category_id, 
    price
FROM RankedProductsByCate
WHERE price_rank = 1; -- take only highest

-- Problem 12:--Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint You may need to use subqueries, joins, and window functions to solve this problem.

-- use CTE
-- include each uers's order date along with dates of two previous orders - use lag() again
-- partition by user_id and order_date
WITH OrderedDates AS (
    SELECT 
        Users.user_id, 
        Users.username, 
        Orders.order_date,
        LAG(Orders.order_date, 1) OVER (PARTITION BY Users.user_id ORDER BY Orders.order_date) AS prev_order_date,
        LAG(Orders.order_date, 2) OVER (PARTITION BY Users.user_id ORDER BY Orders.order_date) AS prev_order_date_2
    FROM Users
    INNER JOIN Orders ON Users.user_id = Orders.user_id
), ConsecutiveOrders AS (
-- another CTE to find rows where current order date is one day after the prev order date
    SELECT 
        user_id, 
        username
    FROM OrderedDates
    WHERE order_date = prev_order_date + INTERVAL '1 day'
    AND prev_order_date = prev_order_date_2 + INTERVAL '1 day'
)
-- simple main query
SELECT DISTINCT
    user_id, 
    username
FROM ConsecutiveOrders;