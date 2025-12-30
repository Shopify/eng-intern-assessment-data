-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Solution 5
-- In the CTE, the AVG function computes the average rating, rounded to two decimal places, and groups the results by product_id.
-- The RANK() window function is used to assign a rank to each product based on its average rating in descending order.
-- The WHERE clause in the main query is used to display only the top-ranked product, which has the highest average rating.

WITH ProductAverageRatings AS (
    SELECT product_id,
          ROUND(AVG(rating), 2) AS avg_rating,
          RANK() OVER (ORDER BY ROUND(AVG(rating), 2) DESC) AS rating_rank
   FROM Reviews
   GROUP BY product_id
)
SELECT P.product_id,
       P.product_name,
       PAR.avg_rating
FROM Products P
JOIN ProductAverageRatings PAR ON P.product_id = PAR.product_id
WHERE PAR.rating_rank = 1;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Solution 6
-- The query joins four tables: Users, Orders, Order_Items, and Products, to link users to the categories of the products they have ordered.
-- The results are grouped by user_id.
-- The HAVING clause filters the results to include only users whose count of distinct ordered product categories equals the total number of distinct categories available.

SELECT U.user_id,
       U.username
FROM Users U
JOIN Orders O ON U.user_id = O.user_id
JOIN Order_Items OI ON O.order_id = OI.order_id
JOIN Products P ON OI.product_id = P.product_id
GROUP BY U.user_id
HAVING COUNT(DISTINCT P.category_id) =
  (SELECT COUNT(DISTINCT category_id)
   FROM Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Solution 7
-- It involves a LEFT JOIN between the Products table and the Reviews table.
-- The WHERE clause filters the results to include only those products for which there is no corresponding review record.

SELECT P.product_id,
       P.product_name
FROM Products P
LEFT JOIN Reviews R ON P.product_id = R.product_id
WHERE R.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Solution 8
-- Within the CTE, The LAG() window function is used to get the date of the previous order for each user.
-- The WHERE clause in the main query filters the results to include only those cases where the order_date is exactly one day after the previous_order_date.
-- The DISTINCT keyword is used to ensure each user is listed only once.

WITH OrderedUsers AS (
    SELECT U.user_id,
          U.username,
          O.order_date,
          LAG(O.order_date) OVER (PARTITION BY U.user_id ORDER BY O.order_date) AS previous_order_date
   FROM Users U
   JOIN Orders O ON U.user_id = O.user_id
)
SELECT DISTINCT user_id,
                username
FROM OrderedUsers
WHERE order_date = previous_order_date + INTERVAL '1 day';