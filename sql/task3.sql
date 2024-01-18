-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT
    C.category_id,
    C.category_name,
    SUM(O.total_amount) AS total_sales_amount
FROM
    Categories C
JOIN
    -- categories in proudcts
    Products P ON C.category_id = P.category_id
JOIN
    -- prodcuts in order items
    Order_Items OI ON P.product_id = OI.product_id
JOIN
    -- orders_id in orders and total amount 
    Orders O ON OI.order_id = O.order_id
GROUP BY
    C.category_id, C.category_name
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
JOIN 
    Orders O ON U.user_id = O.user_id
JOIN 
    Order_Items OI ON OI.order_id = O.order_id
JOIN 
    Products P ON P.product_id = OI.product_id
JOIN
    Categories C ON P.category_id = C.category_id
WHERE
    C.category_name = 'Toys & Games'
GROUP BY
    U.user_id, U.username, C.category_id
HAVING
 -- total number of distinct products left should be equal to total number of products with toys & games_id
    COUNT(DISTINCT P.product_id) = (SELECT COUNT(*) FROM Products WHERE category_id = C.category_id);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- make subtable with info 
WITH MaxPrices AS (
  SELECT
    category_id,
    MAX(price) AS max_price
  FROM
    Products
  GROUP BY
    category_id
)

-- match from the table 
SELECT
  P.product_id,
  P.product_name,
  P.category_id,
  P.price
FROM
  Products P
JOIN
  MaxPrices MP ON P.category_id = MP.category_id AND P.price = MP.max_price;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.


-- create subtable like in task 2 to store data of next order dates
WITH ConsecutiveOrders AS (
    SELECT
        U.user_id,
        U.username,
        O.order_date,
        -- find next values using lead with inputs 1 and 2, organize by users id and order by order_date to find consec
        LEAD(O.order_date, 1) OVER (PARTITION BY U.user_id ORDER BY O.order_date) AS next_order_date,
        LEAD(O.order_date, 2) OVER (PARTITION BY U.user_id ORDER BY O.order_date) AS next_next_order_date
    FROM
        Users U
    JOIN
        Orders O ON U.user_id = O.user_id
)

-- pull valid rows from subtable 
SELECT DISTINCT
    CO.user_id,
    CO.username
FROM
    ConsecutiveOrders CO
WHERE
    -- start date + 1 and 2 will find three consecutive dates 
    CO.next_order_date - CO.order_date = 1
    AND CO.next_next_order_date - CO.order_date = 2;