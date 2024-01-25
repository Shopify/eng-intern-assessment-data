-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Using a subquery to compute average rating (using an aggregation function) per product
-- and a window function - dense_rank for results/values with ties

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


-- first cte gives the total number of categories available per product
-- second cte gives the total number of categories per product ordered per user
-- last select statement joins the two aforementioned ctes on common column and
-- on condition that total number of categories per product match


WITH categories_products AS (
SELECT
     p.product_id,
     count(DISTINCT c.category_id) AS total_categories
FROM Products p
    JOIN Categories c using (category_id)
GROUP BY
      1
),

orders_product_categories AS (
SELECT
   p.product_id,
   o.user_id,
   u.username,
   count(DISTINCT c.category_id) as total_categories
FROM Orders o
JOIN Users u USING(user_id)
JOIN Order_Items oi USING(order_id)
JOIN Products p ON p.product_id=oi.product_id
JOIN Categories c ON p.category_id=c.category_id
GROUP BY
       1,
       2,
       3)

SELECT
    DISTINCT -- using distinct because some users ordered multiple (>1)  products that meet this condition (most product have just one category)
    opc.user_id,
    opc.username
FROM  orders_product_categories opc
   JOIN categories_products cp on opc.product_id = cp.product_id
                                      and opc.total_categories = cp.total_categories

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- query outputs products without reviews by  filtering out ("where not exists)
-- products that have a review; Select 1  will output constant 1 for every row of the query
-- to determine if records matches "where" clause in subquery in a less expensive way (p.o.v. query performance)


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

-- Using a subquery to compute consecutive orders per user using lag window function
-- and difference in days between two consecutive orders using datediff in a window function

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
LEFT JOIN Users u USING (user_id)
WHERE time_diff = 1