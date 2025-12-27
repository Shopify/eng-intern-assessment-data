-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH AVERAGERATINGS AS (
 -- get the ratings in a CTE
    SELECT
        P.PRODUCT_ID,
        P.PRODUCT_NAME,
 -- average the product rating
        AVG(R.RATING) AS AVERAGE_RATING
    FROM
 -- get the product's reviews
        PRODUCTS AS P
        LEFT JOIN REVIEWS AS R
        ON P.PRODUCT_ID = R.PRODUCT_ID
    GROUP BY
        P.PRODUCT_ID,
        P.PRODUCT_NAME
)
SELECT
    PRODUCT_ID,
    PRODUCT_NAME,
    AVERAGE_RATING
FROM
    AVERAGERATINGS
ORDER BY
    AVERAGE_RATING DESC LIMIT 1;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT
    U.USER_ID,
    U.USERNAME
FROM
    USERS AS U
WHERE
 -- filters out users who did not order from all categories
    NOT EXISTS (
 -- get all the category ID's
        SELECT
            C.CATEGORY_ID
        FROM
            CATEGORIES AS C
        WHERE
            NOT EXISTS (
 -- get categories that the user has not ordered from
                SELECT
                    DISTINCT O.CATEGORY_ID
                FROM
                    ORDERS AS O
                    JOIN ORDER_ITEMS AS OI
                    ON O.ORDER_ID = OI.ORDER_ID
                WHERE
                    U.USER_ID = O.USER_ID
                    AND C.CATEGORY_ID = OI.CATEGORY_ID
            )
    );

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT
    P.PRODUCT_ID,
    P.PRODUCT_NAME
FROM
 -- get all reviews for for each product
    PRODUCTS AS P
    LEFT JOIN REVIEWS AS R
    ON P.PRODUCT_ID = R.PRODUCT_ID
GROUP BY
    P.PRODUCT_ID,
    P.PRODUCT_NAME
HAVING
 -- check if the product has at least 1 review
    COUNT(R.REVIEW_ID) > 0;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH RANKEDORDERS AS (
 -- use CTE to calculate the previous order date
    SELECT
        USER_ID,
        ORDER_DATE,
 -- LAG: calcuate the previous order date
 --      compares the order date over this range
        LAG(ORDER_DATE) OVER (PARTITION BY USER_ID ORDER BY ORDER_DATE) AS PREV_ORDER_DATE
    FROM
        ORDERS
)
SELECT
    U.USER_ID,
    U.USERNAME
FROM
    USERS AS U
    JOIN RANKEDORDERS AS RO
    ON U.USER_ID = RO.USER_ID
WHERE
 -- check if RO.ORDER_DATE is exactly 1 day apart
    RO.ORDER_DATE = DATEADD(DAY, 1, RO.PREV_ORDER_DATE)
    OR (RO.ORDER_DATE = RO.PREV_ORDER_DATE
 -- checks if it is not the first order
    AND RO.PREV_ORDER_DATE IS NOT NULL);