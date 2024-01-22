-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

SELECT
    P.product_id, P.product_name, AVG(R.rating) AS average_rating 
FROM Products P
LEFT JOIN
    Reviews R ON P.product_id = R.product_id
GROUP BY
    P.product_id, P.product_name
HAVING AVG(R.rating) =(SELECT TOP 1  AVG (R.rating) AS average_rating 
                            FROM
                                Products P
                            LEFT JOIN
                                Reviews R ON P.product_id = R.product_id

                            GROUP BY
                                P.product_id, P.product_name
                                
                            ORDER BY
                                average_rating DESC
                            )    

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

    SELECT id, username from 
        (SELECT
            U.user_id as id, U.username as username,
            count(DISTINCT P.category_id) AS ordered_category
        FROM Users U, Products P, Orders O, Order_Items I
        Where U.user_id = O.user_id and  O.order_id = I.order_id and I.product_id = P.product_id
        GROUP BY U.user_id, U.username) AS T
    WHERE ordered_category = (select count (*) from Categories) 

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
    Reviews R ON P.product_id = R.product_id
WHERE
    R.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

   select U.user_id, U.username FROM
   (SELECT
        user_id,
        order_date,
        DATEDIFF(day, order_date, LEAD(order_date,1) OVER (PARTITION BY user_id ORDER BY order_date)) as date_diff
    FROM Orders) as T,  Users AS U
    where T.date_diff = 1 AND T.user_id = U.user_id;