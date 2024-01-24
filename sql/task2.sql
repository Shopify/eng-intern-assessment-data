-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

SELECT
       product_id,
       product_name,
       average_rating
FROM(
SELECT
       p.product_id,
       p.product_name,
       r.rating,
       AVG(r.rating) OVER (PARTITION BY p.product_id) AS average_rating,
       DENSE_RANK() OVER (ORDER BY AVG(r.rating) DESC) AS avg_rating_rank
FROM  Products p
LEFT JOIN Reviews r USING (product_id)
GROUP BY 1,2,3
) rating
WHERE avg_rating_rank =1

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT
     user_id,
     username
FROM Orders o
JOIN Order_Items oi USING(order_id)
JOIN Products p USING(product_id)
JOIN Categories c USING(category_id)
JOIN Users u USING(user_id)
GROUP BY 1,2
HAVING COUNT(DISTINCT c.category_id) = (SELECT COUNT(*) FROM Categories)

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT
    p.product_id,
    p.product_name
FROM
    Products p
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Reviews r
        WHERE p.product_id = r.product_id
    )

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

SELECT
     o.user_id,
     u.username
FROM (
         SELECT user_id,
                order_date,
                LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS previous_date,
        DATEDIFF(DAY, Lag(order_date)
                      OVER ( PARTITION BY user_id ORDER BY order_date), order_date) AS time_diff
         FROM Orders
     ) o
JOIN Users u USING (user_id)
WHERE time_diff = 1