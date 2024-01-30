-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT
    C.category_id,
    C.category_name,
    SUM(O_I.unit_price * O_I.quantity) AS total_sales_amount -- make sure to multiply quantity by price for total sale
FROM
    Categories C
    JOIN Products P ON C.category_id = P.category_id
    JOIN Order_Items O_I ON P.product_id = O_I.product_id -- find catagories of orders
GROUP BY
    C.category_id
ORDER BY
    total_sales_amount DESC 
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT
    U.user_id,
    U.username
FROM
    Users U
    JOIN Orders O ON U.user_id = O.user_id -- relate to orders -> items -> products -> catagories
    JOIN Order_Items O_I ON O_I.order_id = O.order_id
    JOIN Products P ON O_I.product_id = P.product_id
    JOIN Categories C ON C.category_id = P.category_id -- find users who have placed an order for one of all in category
WHERE
    C.category_name LIKE 'Toys & Games'  -- restrict category to toys and games
GROUP BY
    U.user_id;

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT
    P.product_id,
    P.product_name,
    P.category_id,
    P.price
FROM
    Products P
    JOIN ( -- CTE of max prices for each category id
        SELECT
            P2.category_id,
            MAX(P2.price) AS max_price
        FROM
            Products P2
        GROUP BY
            P2.category_id
        ) AS max_prices
    ON P.category_id = max_prices.category_id AND P.price = max_prices.max_price; -- pick products which are maximums

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- at this point it would likely be preferable to create a query for N consecutive days, 
-- I tried for a bit to figure out how to do so but didn't have much luck as I was getting close to the deadline
-- TLDR: i know this is sloppy, I am still new to SQL :p

SELECT DISTINCT
    U.user_id,
    U.username
FROM
    Users U
    JOIN Orders O1 ON O1.user_id = U.user_id
    JOIN Orders O2 ON O2.user_id = U.user_id AND O2.order_date = DATE_ADD(O1.order_date, INTERVAL 1 DAY)
    JOIN Orders O3 ON O3.user_id = U.user_id AND O3.order_date = DATE_ADD(O2.order_date, INTERVAL 1 DAY); 
