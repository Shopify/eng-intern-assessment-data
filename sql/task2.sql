-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH
  ProductAverageRatings
  AS
  (
    SELECT
      product_id,
      AVG(rating) AS avg_rating
    FROM
      reviews
    GROUP BY
    product_id
  ),
  MaxAverageRating
  AS
  (
    SELECT
      MAX(avg_rating) AS max_avg_rating
    FROM
      ProductAverageRatings
  )
SELECT
  p.product_id,
  p.product_name,
  par.avg_rating
FROM
  products p
  JOIN
  ProductAverageRatings par ON p.product_id = par.product_id
  JOIN
  MaxAverageRating m ON par.avg_rating = m.max_avg_rating;


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT
  u.user_id,
  u.username
FROM
  users u
WHERE
  (SELECT COUNT(DISTINCT category_id)
FROM categories) = 
  (SELECT COUNT(DISTINCT p.category_id)
FROM
  orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  JOIN products p ON oi.product_id = p.product_id
WHERE
     u.user_id = o.user_id);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT
  product_id,
  product_name
FROM
  products
WHERE
  product_id NOT IN (
    SELECT DISTINCT product_id
FROM Reviews
  );

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
WITH
  ConsecutiveOrders
  AS
  (
    SELECT
      u.user_id,
      u.username,
      o.order_date,
      LAG(o.order_date) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS prev_order_date
    FROM
      orders o
      JOIN
      users u ON o.user_id = u.user_id
  )
SELECT DISTINCT
  user_id,
  username
FROM
  ConsecutiveOrders
WHERE
  order_date = DATEADD(day, 1, prev_order_date);
-- was originally DATEADD(prev_order_date, INTERVAL 1 DAY) but vscode gives me an error