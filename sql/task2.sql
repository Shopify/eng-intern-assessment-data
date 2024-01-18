-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- CTE querry to compute the avg value
WITH ProductRatings AS (
    SELECT
        P.product_id,
        P.product_name,
        AVG(R.rating) as average_rating
    FROM
        Products P
    LEFT JOIN 
        Reviews R on R.product_id = P.product_id
    GROUP BY
        P.product_id,
        P.product_name
)


SELECT
    product_id,
    product_name,
    average_rating
FROM
    ProductRatings
WHERE
-- use the CTE so the max returns all values tied for max
    average_rating = (SELECT MAX(average_rating) FROM ProductRatings);



-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT 
    U.user_id, 
    U.username
FROM 
    USERS U 
WHERE
    U.user_id IN (
        SELECT DISTINCT 
            O.user_id
        -- need table with user_id so use orders
        FROM 
            Orders O
        -- need to from table with order_ids to product ids 
        JOIN 
            Order_Items OI ON O.order_id = OI.order_id
        JOIN
            Products P ON OI.product_id = P.product_id
        GROUP BY 
            O.user_id, P.category_id
        -- number of disitnc category_id == to toal number of category ID
        HAVING 
            COUNT(DISTINCT P.category_id) = (SELECT COUNT(DISTINCT category_id) FROM Categories)
    );


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT
    P.product_id,
    P.product_name
FROM
    Products P
LEFT JOIN 
    Reviews R on P.product_id = R.product_id
WHERE
    -- values not found will be null
    R.product_id is NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH ConsecutiveOrders AS (
    SELECT
        user_id,
        order_date,
        -- find next row using lead, partion by user_id to look at one user and order 
        LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date
    FROM
        Orders
)

SELECT DISTINCT
    U.user_id,
    U.username
FROM
    Users U
JOIN
    ConsecutiveOrders CO ON U.user_id = CO.user_id
WHERE
    --take difference in days == 1 
    next_order_date - order_date = 1;