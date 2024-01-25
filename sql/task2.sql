-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
SELECT 
  r.product_id, p.product_name, AVG(r.rating) AS average_rating
FROM 
  products p
RIGHT JOIN 
  reviews r 
ON 
  p.product_id = r.product_id
GROUP BY 
  r.product_id
HAVING AVG(r.rating) = (
  SELECT 
    MAX(avg_rating)
  FROM (
    SELECT 
      AVG(rating) AS avg_rating
    FROM 
      reviews
    GROUP BY 
      product_id
  )
)


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT 
  uid as user_id, uname as username
FROM
(
  SELECT
      u.user_id as uid, u.username as uname, COUNT(DISTINCT c.category_id) as user_categories
  FROM
    users u
  INNER JOIN orders o ON u.user_id = o.user_id
  LEFT JOIN order_items oi ON o.order_id = oi.order_id
  LEFT JOIN products p ON oi.product_id = p.product_id
  LEFT JOIN category c ON p.category_id = c.category_id
  GROUP BY
    uid, uname
)
WHERE user_categories = (
  SELECT COUNT(category_id) FROM category  
)


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT product_id, product_name
FROM
products
WHERE
product_id NOT IN (
    SELECT product_id
    FROM
    reviews
)


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
SELECT DISTINCT u.user_id, u.username
FROM users u
INNER JOIN
(
    SELECT
        user_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
    FROM
        orders
) o ON u.user_id = o.user_id
WHERE JULIANDAY(o.order_date) - JULIANDAY(o.prev_order_date) = 1