-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating
FROM products p
JOIN ratings r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
HAVING AVG(r.rating) = (
  SELECT MAX(average_rating)
  FROM (
    SELECT AVG(rating) AS average_rating
    FROM ratings
    GROUP BY product_id
  ) AS subquery
);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
WITH UserCategoryCounts AS (
    SELECT
        u.user_id,
        u.username,
        COUNT(DISTINCT p.category_id) AS category_count
    FROM
        users u
        JOIN orders o ON u.user_id = o.user_id
        JOIN order_items oi ON o.order_id = oi.order_id
        JOIN products p ON oi.product_id = p.product_id
    GROUP BY
        u.user_id
),
TotalCategoryCount AS (
    SELECT
        COUNT(DISTINCT category_id) AS total_category_count
    FROM
        categories
)
SELECT
    ucc.user_id,
    ucc.username
FROM
    UserCategoryCounts ucc,
    TotalCategoryCount tcc
WHERE
    ucc.category_count = tcc.total_category_count;

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN reviews r ON p.product_id = r.product_id
WHERE r.product_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
WITH ConsecutiveOrders AS (
  SELECT
    o.user_id,
    u.username,
    o.order_date,
    LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS previous_order_date
  FROM
    orders o
    JOIN users u ON o.user_id = u.user_id
)
SELECT DISTINCT
  co.user_id,
  co.username
FROM
  ConsecutiveOrders co
WHERE
  co.order_date = co.previous_order_date + INTERVAL '1 day';
