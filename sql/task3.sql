-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- This query calculates the total sales amount for each category and retrieves the top 3 categories.
-- It joins Categories, Products, and Order_Items tables to calculate the total sales.
-- The GROUP BY clause groups the results by category, and the ORDER BY with LIMIT 3 selects the top 3 categories.
SELECT 
    Categories.category_id,
    Categories.category_name,
    SUM(Order_Items.quantity * Order_Items.unit_price) AS "Total Sales"
FROM 
    Categories
JOIN 
    Products ON Categories.category_id = Products.category_id
JOIN 
    Order_Items ON Products.product_id = Order_Items.product_id
GROUP BY 
    Categories.category_id, Categories.category_name
ORDER BY 
    "Total Sales" DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- This query identifies users who have ordered every product in the 'Toys & Games' category.
-- It involves multiple joins across Users, Orders, Order_Items, Products, and Categories.
-- The HAVING clause ensures that the count of distinct products ordered matches the total number in the category.
SELECT 
    Users.user_id,
    Users.username
FROM 
    Users
JOIN 
    Orders ON Users.user_id = Orders.user_id
JOIN 
    Order_Items ON Orders.order_id = Order_Items.order_id
JOIN 
    Products ON Order_Items.product_id = Products.product_id
JOIN 
    Categories ON Products.category_id = Categories.category_id
WHERE 
    Categories.category_name = 'Toys & Games'
GROUP BY 
    Users.user_id,
    Users.username
HAVING 
    COUNT(DISTINCT Products.product_id) = (
        SELECT COUNT(*) 
        FROM Products 
        WHERE category_id = (
            SELECT category_id 
            FROM Categories 
            WHERE category_name = 'Toys & Games'
        )
    );

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- This query selects products with the highest price in each category.
-- A subquery is used to determine the maximum price per category.
-- The main query then matches these maximum prices with products in each category.
SELECT 
    Products.product_id,
    Products.product_name,
    Products.category_id,
    Products.price
FROM 
    Products
INNER JOIN 
    (SELECT 
         Products.category_id, 
         MAX(Products.price) AS max_price
     FROM 
         Products
     GROUP BY 
         Products.category_id) AS MaxPrices
ON 
    Products.category_id = MaxPrices.category_id AND Products.price = MaxPrices.max_price;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- This query finds users who have placed orders on three consecutive days.
-- It performs self-joins on the Orders table to match orders across three days.
-- DISTINCT is used to ensure each user is listed only once.

SELECT DISTINCT
    Users.user_id,
    Users.username
FROM 
    Orders AS FirstOrder
JOIN 
    Orders AS SecondOrder ON FirstOrder.user_id = SecondOrder.user_id 
                            AND DATEADD(day, 1, FirstOrder.order_date) = SecondOrder.order_date
JOIN 
    Orders AS ThirdOrder ON FirstOrder.user_id = ThirdOrder.user_id 
                          AND DATEADD(day, 2, FirstOrder.order_date) = ThirdOrder.order_date
JOIN 
    Users ON FirstOrder.user_id = Users.user_id;
