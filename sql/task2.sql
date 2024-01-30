-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

--Same idea as problem 3 but order the average rating in descending order from highest avg rating to lowest avg rating 
SELECT
    P.product_id,
    P.product_name,
    AVG(R.rating) AS average_rating
FROM
    Products P
LEFT JOIN
    Reviews R ON P.product_id = R.product_id
GROUP BY
    P.product_id, P.product_name
ORDER BY
    average_rating DESC;


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

--Join Users, Orders, Order Items, Products and Categories tables together
--Use subquery in WHERE to filter users who have made at least one order in each category by checking
-- counts of distinct categories for each users
--HAVING ensures the count for distinct categories matches the number of distinct categories in the Categories table
SELECT DISTINCT 
    U.user_id,
    U.username,
FROM 
    Users U
JOIN 
    Orders O ON U.user_id = O.user_id
JOIN 
    Order_Items OI ON O.order_id = OI.order_id
JOIN 
    Products P ON OI.product_id = P.product_id
JOIN 
    Categories C ON P.category_id = C.category_id
WHERE 
    U.user_id IN (    
        SELECT DISTINCT 
            U2.user_id
        FROM 
            Users U2
        JOIN 
            Orders O2 ON U2.user_id = O2.user_id
        JOIN 
            Order_Items OI2 ON O2.order_id = OI2.order_id
        JOIN 
            Products P2 ON OI2.product_id = P2.product_id
        JOIN 
            Categories C2 ON P2.category_id = C2.category_id
        GROUP BY 
            U2.user_id, C2.category_id
        HAVING 
            COUNT(DISTINCT C2.category_id) = (SELECT COUNT(DISTINCT category_id)FROM Categories)
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

--Join product_id from reviews and products
--only output the product_id and name if the review_id is NULL (empty/not exist) for any product_id in Products
SELECT 
    P.product_id, P.product_name
FROM 
    Products P
LEFT JOIN 
    Reviews R ON P.product_id = R.product_id
WHERE 
    R.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

--Using CTE to create a new table for OrderedOrders
--Use LEAD() window function to get next order_date for each row from the result set
--Partition result set by user id so the lead function is applied independently to each user and order the rows by order date within each partition
--Assign the above results into a new column called next_order_date
--WHERE filters wanted results that have a difference between consecutive orders of 1 day or next order date is NULL
WITH OrderedOrders AS (
    SELECT
        user_id,
        order_id,
        order_date,
        LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date
    FROM
        Orders
)
SELECT DISTINCT U.user_id, U.username
FROM
    Users U
JOIN
    OrderedOrders O ON U.user_id = O.user_id
WHERE
    DATEDIFF(next_order_date, order_date) = 1 OR next_order_date IS NULL;
