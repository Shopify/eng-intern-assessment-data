-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH PRODUCTRATINGS AS (
  SELECT p.product_id, p.product_name, AVG(r.rating) AS avg_rating
  FROM PRODUCTS p
  INNER JOIN REVIEWS R ON p.product_id = r.product_id
  GROUP BY p.product_id, p.product_name
)

SELECT product_id, product_name, avg_rating
FROM (
  SELECT *, ROW_NUMBER() OVER (ORDER BY avg_rating DESC) AS "ROW_NUM"
  FROM PRODUCTRATINGS
) ranked
WHERE "ROW_NUM" = 1;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT u.user_id, u.username
FROM USERS u
WHERE NOT EXISTS (
  SELECT c.category_id
  FROM CATEGORIES C
  WHERE NOT EXISTS (
    SELECT p.product_id
    FROM PRODUCTS p
    LEFT JOIN ORDERS_ITEMS oi ON p.product_id = oi.product_id
    LEFT JOIN ORDERS o ON oi.order_id = o.order_id AND o.user_id = u.user_id
    WHERE c.category_id = p.category_id AND oi.order_id IS NOT NULL
  )
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT p.product_id, p.product_name
FROM PRODUCTS p
LEFT JOIN  REVIEWS R ON p.product_id = r.product_id
WHERE r.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

SELECT DISTINCT u.user_id, u.username
FROM USERS u
JOIN ORDERS o1 ON u.user_id = o1.user_id
JOIN ORDERS o2 ON u.user_id = o2.user_id AND o2.order_date = o1.order_date + 1;
