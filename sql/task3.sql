-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT 
    Categories.category_id, -- Selects category_ID
    Categories.category_name, -- Selects category name
    SUM(Order_Items.quantity * Order_Items.unit_price) AS total_sales -- Calculates total sales for each category
FROM 
    Categories
JOIN 
    Products ON Categories.category_id = Products.category_id -- Joins Categories with Products
JOIN 
    Order_Items ON Products.product_id = Order_Items.product_id -- Joins Products with Order_Items
GROUP BY 
    Categories.category_id, Categories.category_name -- Groups results by category_id and category_name
ORDER BY 
    total_sales DESC -- Orders by the total sales in descending order
LIMIT 3; -- Limits the results to the top 3 categories

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT 
    Users.user_id, -- Selects user_ID
    Users.username -- Selects usernames
FROM 
    Users
JOIN 
    Orders ON Users.user_id = Orders.user_id -- Joins Users with Orders
JOIN 
    Order_Items ON Orders.order_id = Order_Items.order_id -- Joins Orders with Order_Items
JOIN 
    Products ON Order_Items.product_id = Products.product_id -- Joins Order_Items with Products
JOIN 
    Categories ON Products.category_id = Categories.category_id -- Joins Products with Categories
WHERE 
    Categories.category_name = 'Toys & Games' -- Filters to the "Toys & Games" category
GROUP BY 
    Users.user_id, Users.username -- Groups results by user_id and username
HAVING 
    COUNT(DISTINCT Products.product_id) = ( -- Ensures the user has ordered all products in the category
        SELECT COUNT(product_id) FROM Products WHERE category_id = (
            SELECT category_id FROM Categories WHERE category_name = 'Toys & Games'
        )
    );

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT 
    Products.product_id, -- Selects product_ID
    Products.product_name, -- Selects product name
    Products.category_id, -- Selects category_ID
    Products.price -- Selects price
FROM 
    Products
INNER JOIN (
    SELECT 
        category_id, 
        MAX(price) AS max_price -- Finds the maximum price for each category
    FROM 
        Products 
    GROUP BY 
        category_id -- Groups results by category_id
) AS max_prices ON Products.category_id = max_prices.category_id AND Products.price = max_prices.max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT DISTINCT
    Users.user_id, -- Selects user_ID
    Users.username -- Selects usernames
FROM 
    Users
JOIN 
    Orders o1 ON Users.user_id = o1.user_id -- Joins Users with Orders (first instance)
JOIN 
    Orders o2 ON Users.user_id = o2.user_id AND DATEDIFF(o2.order_date, o1.order_date) = 1 -- Joins Users with Orders (second instance) and checks for consecutive days
JOIN 
    Orders o3 ON Users.user_id = o3.user_id AND DATEDIFF(o3.order_date, o2.order_date) = 1 -- Joins Users with Orders (third instance) and checks for consecutive days
WHERE 
    o1.order_id <> o2.order_id AND o2.order_id <> o3.order_id; -- Ensures different orders are compared
