-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.


-- This query finds products with the highest average rating.
-- A common table expression (CTE) RatedProducts is used to calculate the average rating per product.
-- The CTE groups the Reviews by product_id and computes the average rating.
-- The main query joins the Products table with the RatedProducts CTE.
-- It selects the product ID, name, and average rating from the CTE.
-- The WHERE clause filters products having the maximum average rating in the CTE.

WITH RatedProducts AS (
  SELECT
    product_id,
    AVG(rating) AS average_rating
  FROM Reviews
  GROUP BY product_id
)
SELECT p.product_id, p.product_name, rp.average_rating
FROM Products p
JOIN RatedProducts rp ON p.product_id = rp.product_id
WHERE rp.average_rating = (SELECT MAX(average_rating) FROM RatedProducts);


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- This query selects users who have made at least one order in every category.
-- The main query selects user ID and username from the Users table.
-- A NOT EXISTS clause checks for categories where no orders were made by the user.
-- A nested NOT EXISTS clause checks if the user made any order in each category.
-- The double NOT EXISTS ensures selection of users ordering from all categories.

SELECT u.user_id, u.username
FROM Users u
WHERE NOT EXISTS (
    SELECT c.category_id
    FROM Categories c
    WHERE NOT EXISTS (
        SELECT o.order_id
        FROM Orders o
        JOIN Order_Items oi ON o.order_id = oi.order_id
        JOIN Products p ON oi.product_id = p.product_id
        WHERE p.category_id = c.category_id AND o.user_id = u.user_id
    )
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- This query fetches products that have not been reviewed.
-- It selects the product ID and product name from the Products table.
-- A LEFT JOIN is used with the Reviews table on product_id.
-- The WHERE clause filters out products that have no associated review (null review_id).

SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
WHERE r.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.


-- This query identifies users who placed orders on consecutive days.
-- A subquery is used to select each order's date and the previous order date for the same user.
-- The LAG window function is used to get the previous order date for each user.
-- The main query selects distinct user ID and username from the Users table.
-- It joins with the subquery on user_id.
-- The WHERE clause checks for a 1-day difference between consecutive orders.


SELECT DISTINCT U.user_id, U.username
FROM 
    (SELECT 
         O.user_id, 
         O.order_date,
         LAG(O.order_date) OVER (PARTITION BY O.user_id ORDER BY O.order_date) AS prev_order_date
     FROM Orders O) AS Subquery
JOIN Users U ON Subquery.user_id = U.user_id
WHERE DATEDIFF(Subquery.order_date, Subquery.prev_order_date) = 1;
