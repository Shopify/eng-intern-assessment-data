-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

WITH CATEGORYSALES AS (
 -- using CTE to calculate the total sales for each category
    SELECT
        C.CATEGORY_ID,
        C.CATEGORY_NAME,
        SUM(OI.QUANTITY * OI.UNIT_PRICE) AS TOTAL_SALES
    FROM
 -- get each item and how many time it was ordered
        CATEGORIES AS C
        LEFT JOIN PRODUCTS AS P
        ON C.CATEGORY_ID = P.CATEGORY_ID
        LEFT JOIN ORDER_ITEMS AS OI
        ON P.PRODUCT_ID = OI.PRODUCT_ID
    GROUP BY
        C.CATEGORY_ID,
        C.CATEGORY_NAME
)
SELECT
    CATEGORY_ID,
    CATEGORY_NAME,
    TOTAL_SALES
FROM
    CATEGORYSALES
ORDER BY
 -- get the top 3 total sales
    TOTAL_SALES DESC LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

WITH TOYSGAMESPRODUCTS AS (
 -- using CTE to get all products where it is Toys & Games
    SELECT
        PRODUCT_ID
    FROM
        CATEGORIES AS C
        JOIN PRODUCTS P
        ON C.CATEGORY_ID = P.CATEGORY_ID
    WHERE
        C.CATEGORY_NAME = 'Toys & Games'
)
SELECT
    U.USER_ID,
    U.USERNAME
FROM
    USERS AS U
WHERE
 -- filter out users who did not placed any orders for products in the Toys & Games cateogory
    NOT EXISTS (
        SELECT
            TP.PRODUCT_ID
        FROM
            TOYSGAMESPRODUCTS AS TP
            LEFT JOIN ORDER_ITEMS OI
            ON TP.PRODUCT_ID = OI.PRODUCT_ID
            LEFT JOIN ORDERS O
            ON OI.ORDER_ID = O.ORDER_ID
        WHERE
            U.USER_ID = O.USER_ID
    );

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH RANKEDPRODUCTS AS (
 -- using CTE to assign its rank of how much it costs within its respective category
    SELECT
        PRODUCT_ID,
        PRODUCT_NAME,
        CATEGORY_ID,
        PRICE,
 -- orders the products based on it category and assigns it the row number to distinguish its cost relative to other products in its category
        ROW_NUMBER() OVER (PARTITION BY CATEGORY_ID ORDER BY PRICE DESC) AS RANK_WITHIN_CATEGORY
    FROM
        PRODUCTS
)
SELECT
    PRODUCT_ID,
    PRODUCT_NAME,
    CATEGORY_ID,
    PRICE
FROM
    RANKEDPRODUCTS
WHERE
 -- corresponds to the most expensive
    RANK_WITHIN_CATEGORY = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH CONSECUTIVEORDERDAYS AS (
 -- using CTE to calculate the previous and next order for each user
    SELECT
        USER_ID,
        ORDER_DATE,
 -- gets previous order
        LAG(ORDER_DATE) OVER (PARTITION BY USER_ID ORDER BY ORDER_DATE) AS PREV_ORDER_DATE,
 -- gets next order
        LEAD(ORDER_DATE) OVER (PARTITION BY USER_ID ORDER BY ORDER_DATE) AS NEXT_ORDER_DATE
    FROM
        ORDERS
)
SELECT
    DISTINCT U.USER_ID,
    U.USERNAME
FROM
    USERS AS U
    JOIN CONSECUTIVEORDERDAYS AS COD
    ON U.USER_ID = COD.USER_ID
WHERE
 -- check if the days are at +1, -1 days apart
 -- means that it exists a sequence of order that spans 3 days
    DATEDIFF(DAY, COD.PREV_ORDER_DATE, COD.ORDER_DATE) = 1
    AND DATEDIFF(DAY, COD.ORDER_DATE, COD.NEXT_ORDER_DATE) = 1;