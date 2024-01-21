-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- create a temporary table calculating the total sales amount for each category
WITH TotalSales AS (
    SELECT category_id, sum(Order_Items.unit_price * Order_Items.quantity) as total_sales
    FROM Order_Items JOIN Products ON Order_Items.product_id = Products.product_id
    GROUP BY category_id
)
-- sort the above table by the total sales amount in descending order and select
-- the top 3 rows (ie. 3 highest total sales amount), and join with Categories
-- to retrieve category names
SELECT TotalSales.category_id, category_name, total_sales
FROM TotalSales JOIN Categories ON TotalSales.category_id = Categories.category_id
ORDER BY total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- create a temporary table of all products that belong to the "Toys & Games"
-- category
WITH AllToysAndGames AS (
    SELECT product_id
    FROM Products JOIN Categories ON Products.category_id = 
        Categories.category_id
    WHERE category_name = 'Toys & Games'
), UsersMissingToys AS (
    -- create a temporary table of users who have not ordered some product from
    -- the "Toys & Games" category by subtracting all products actually ordered
    -- by users from a list of all users paired with all products in the "Toys
    -- & Games" category
    (SELECT user_id, product_id
    FROM AllToysAndGames, Users)
    EXCEPT
    (SELECT user_id, product_id
    FROM Orders JOIN Order_Items ON Orders.order_id = Order_Items.order_id)
), OrderedAllToys AS (
    -- create a temporary table of users who have ordered all products from the
    -- "Toys & Games" category by subtracting users missing some products from 
    -- a list of all users to find the remaining users who are not missing any
    (SELECT user_id
    FROM Users)
    EXCEPT
    (SELECT user_id
    FROM UsersMissingToys)
) 
-- join OrderedAllToys with Users to retrieve usernames
SELECT Users.user_id, username
FROM OrderedAllToys JOIN Users ON OrderedAllToys.user_id = Users.user_id;

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT product_id, product_name, category_id, price
FROM (
    -- find the max price for a product in each category and pair the max price
    -- with the price of each individual product in that category 
    SELECT product_id, product_name, category_id, price, max(price) 
        OVER (PARTITION BY category_id) as max_price
    FROM Products
) as MaxCategoryPrice
WHERE price = max_price;
-- select only products where the product's individual price is equal to the max
-- price; that is, the product has the highest price for the category

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT Users.user_id, username
FROM (
    -- find the difference in days between the first and second order made by a 
    -- user following every order they've made by sorting all order dates in 
    -- ascending order and subtracting the date of the first and second previous 
    -- order
    SELECT user_id, order_date, order_date - LAG(order_date, 1) 
        OVER (PARTITION BY user_id ORDER BY order_date) as second_date, 
        order_date - LAG(order_date, 2) OVER (PARTITION BY user_id 
        ORDER BY order_date) as third_date
        FROM Orders) as DaysBetweenOrders 
    JOIN Users ON DaysBetweenOrders.user_id = Users.user_id
WHERE second_date = 1 AND third_date = 2;
-- find users where the difference in days between an order and the first order
-- following it is 1 (ie. orders on 2 consecutive days) and the difference in 
-- days between an order and the second order following it is 2 (overall, orders 
-- are made on at least 3 consecutive days)
