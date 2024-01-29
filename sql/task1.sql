-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT
 -- get all columns from Products table
    P.*
FROM
    PRODUCTS AS P
    JOIN CATEGORIES AS C
 -- get products where its category ID matches with "Sports" category ID
    ON P.CATEGORY_ID = C.CATEGORY_ID
WHERE
 -- find category ID of "Sports"
    LOWER(C.CATEGORY_NAME) LIKE '%sports%';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT
    U.USER_ID,
    U.USERNAME,
 -- sum the number of rows as total orders
    COUNT (O.ORDER_ID) AS 'Total Orders'
FROM
 -- join orders that belong to each user
    USERS AS U
    LEFT JOIN ORDERS AS O
    ON U.USER_ID = O.USER_ID
GROUP BY
    U.USER_ID,
    U.USERNAME;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT
    P.PRODUCT_ID,
    P.PRODUCT_NAME,
    AVG(R.RATING) AS 'Average Rating'
FROM
 -- find the reviews that belong to each product
    PRODUCTS AS P
    LEFT JOIN REVIEWS AS R
    ON P.PRODUCT_ID = R.PRODUCT_ID
GROUP BY
    P.PRODUCT_ID,
    P.PRODUCT_NAME;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT
    U.USER_ID,
    U.USERNAME,
    SUM(O.TOTAL_AMOUNT) AS TOTAL_AMOUNT_SPENT
FROM
 -- find the orders that belong to each user
    USERS AS U
    JOIN ORDERS AS O
    ON U.USER_ID = O.USER_ID
GROUP BY
    U.USER_ID,
    U.USERNAME
ORDER BY
 -- sort the amount spend of each user in descending order, then get the top 5 rows
    TOTAL_AMOUNT_SPENT DESC LIMIT 5;