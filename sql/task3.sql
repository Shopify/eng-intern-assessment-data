-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- We group all the orders of items by their category, and then sum the total of each sale for each category
-- We then sort by the total sales, and take the top 3

SELECT
    Categories.category_id, 
    category_name, 
    SUM(unit_price * quantity) as catergory_total_sales
FROM 
    Categories
INNER JOIN
    Products ON Categories.category_id = Products.category_id
INNER JOIN
    Order_Items ON Products.product_id = Order_Items.product_id
GROUP BY 
    Categories.category_id
ORDER BY
    catergory_total_sales DESC
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- We find all the entries for user orders of toys and games
-- Then for each user we count the distinct number of products they have ordered (in toys and games since we filtered for that)
-- We then compare that to the total number of products in toys and games, and only keep the users who have ordered all of them (since the counts will be equal)

SELECT
    DISTINCT Users.user_id,
    username
FROM
    Users
INNER JOIN
    Orders ON Orders.user_id = Users.user_id
INNER JOIN
    Order_Items ON Orders.order_id = Order_Items.order_id
INNER JOIN
    Products ON Order_Items.product_id = Products.product_id
INNER JOIN
    Categories ON Products.category_id = Categories.category_id
WHERE
    Categories.category_name = "Toys & Games"
GROUP BY
    Users.user_id
HAVING
    COUNT(DISTINCT Products.product_id) = (
        SELECT
            COUNT(DISTINCT Products.product_id)
        FROM
            Products
        INNER JOIN
            Categories ON Products.category_id = Categories.category_id
        WHERE
            Categories.category_name = "Toys & Games"
    );

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- We're assuming there is a unique product with the highest price per category. If there is a tie, we will answer all of them.

-- We find the max price for each category with an internal select, and then find all the products that have that price

SELECT
    outerProd.product_id,
    outerProd.product_name,
    outerProd.category_id,
    outerProd.price
FROM
    Products outerProd
WHERE
    price = (
        SELECT
            MAX(price) as max_price
        FROM
            Products innerProd
        WHERE
            innerProd.category_id = outerProd.category_id
    );

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- This one's a doozy. We'll run through it inside out.
-- For each user, we find all the orders they've placed, and then using a window partition we find the first order of each day for each user.
-- From this list of unique days per user, we find the next two days a user ordered something
-- Finally, we filter out the lines where there aernt orders on consecutive days, and only keep the distinct users

SELECT 
    DISTINCT user_id, 
    username 
FROM (
    SELECT 
        user_id, 
        username, 
        order_date,
        LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date,
        LEAD(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date_2
    FROM (
        SELECT 
            user_id, 
            username, 
            order_date 
        FROM (
            SELECT 
                Users.user_id, 
                username, 
                order_date, 
                ROW_NUMBER() OVER (PARTITION BY Users.user_id, order_date ORDER BY Orders.order_id) AS order_of_day
            FROM 
                Users 
            INNER JOIN 
                Orders ON Users.user_id = Orders.user_id
        ) AS UserOrders 
        WHERE 
            order_of_day = 1
        )
    )
WHERE 
    next_order_date = DATE(order_date, '+1 day')
    AND next_order_date_2 = DATE(order_date, '+2 day');
