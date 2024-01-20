-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH AvgRatings AS (
  SELECT
    product_id,
    AVG(rating) AS avg_rating
  FROM
    Reviews
  GROUP BY
    product_id
)

SELECT
  Products.product_id,
  Products.product_name,
  COALESCE(AvgRatings.avg_rating, 0) AS average_rating
FROM
  Products
LEFT JOIN
  AvgRatings ON Products.product_id = AvgRatings.product_id
ORDER BY
  average_rating DESC
LIMIT 5;


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
WITH UserCategoryOrders AS (
  SELECT
    U.user_id,
    U.username,
    C.category_id
  FROM
    Users U
    JOIN Orders O ON U.user_id = O.user_id
    JOIN Order_Items OI ON O.order_id = OI.order_id
    JOIN Products P ON OI.product_id = P.product_id
    JOIN Categories C ON P.category_id = C.category_id
  GROUP BY
    U.user_id, U.username, C.category_id
)

SELECT
  UCO.user_id,
  UCO.username
FROM
  Users U
  JOIN UserCategoryOrders UCO ON U.user_id = UCO.user_id
GROUP BY
  UCO.user_id, UCO.username
HAVING
  COUNT(DISTINCT UCO.category_id) = (SELECT COUNT(*) FROM Categories);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT
  P.product_id,
  P.product_name
FROM
  Products P
  LEFT JOIN Reviews R ON P.product_id = R.product_id
WHERE
  R.review_id IS NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
WITH UserOrderDays AS (
  SELECT
    user_id,
    order_id,
    order_date,
    LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
  FROM
    Orders
)

SELECT DISTINCT
  UO.user_id,
  U.username
FROM
  UserOrderDays UO
  JOIN Users U ON UO.user_id = U.user_id
WHERE
  DATEDIFF(UO.order_date, UO.prev_order_date) = 1;
