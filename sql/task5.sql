-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH ProductRatings AS (
  SELECT
    P.product_id,
    P.product_name,
    AVG(R.rating) AS average_rating
  FROM Products AS P
  LEFT JOIN Reviews AS R ON P.product_id = R.product_id
  GROUP BY P.product_id, P.product_name
)

SELECT product_id, product_name, average_rating
FROM ProductRatings
WHERE average_rating = (
  SELECT MAX(average_rating)
  FROM ProductRatings
);