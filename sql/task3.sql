-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

--Use CTE called Category_Sales to include category_id, category_name and the sum of total_amount which would be the total_sales
--join all corresponding ids (such as category, product and order) from categories with products, order_items and orders
WITH Category_Sales AS (
    SELECT
        C.category_id,
        C.category_name,
        SUM(O.total_amount) AS total_sales
    FROM
        Categories C
    JOIN
        Products P ON C.category_id = P.category_id
    JOIN
        Order_Items OI ON P.product_id = OI.product_id
    JOIN
        Orders O ON OI.order_id = O.order_id
    GROUP BY
        C.category_id, C.category_name
)

--Select the category id, name and total sales as output from the new table and order it by having the highest total sales at the top
SELECT
    category_id,
    category_name,
    total_sales
FROM
    Category_Sales
ORDER BY
    total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

--Filter products to those in "Toys & Games"
--HAVING used to make sure the count of distinct product IDs for each user is = total number of products in "Toys & Games" category
SELECT
    U.user_id,
    U.username
FROM
    Users U
JOIN
    Orders O ON U.user_id = O.user_id
JOIN
    Order_Items OI ON O.order_id = OI.order_id
JOIN
    Products P ON OI.product_id = P.product_id
WHERE
    P.category_id = 5
GROUP BY
    U.user_id, U.username
HAVING
    COUNT(DISTINCT P.product_id) = (
        SELECT COUNT(*)
        FROM Products
        WHERE category_id = 5
    );

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

--Make a CTE called Ranked_Products and use ROW_NUMBER() function to assign ranks to each product within its category based on prices in desc order
--ORDER BY in OVER clause ensures that the ranking is reset for each category
--Main query selects products from the CTW where row_num will equal 1 -> meaning it'll select the products has the highest price in each category 
WITH Ranked_Products AS (
    SELECT
        product_id,
        product_name,
        category_id,
        price,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS row_num
    FROM
        Products
)

SELECT
    product_id,
    product_name,
    category_id,
    price 
FROM
    Ranked_Products 
WHERE
    row_num = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

