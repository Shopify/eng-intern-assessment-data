-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.


WITH product_avg_ratings AS (
    SELECT
        p.product_id,
        p.product_name,
        AVG(r.rating) AS avg_rating
    FROM
        products p
    RIGHT JOIN
        reviews r ON p.product_id = r.product_id
    GROUP BY
        p.product_id
)

SELECT
    product_id,
    product_name,
    avg_rating
FROM
    product_avg_ratings
WHERE
    avg_rating = (SELECT MAX(avg_rating) FROM product_avg_ratings);



-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT
    u.user_id,
    u.username
FROM
    users u
JOIN
    orders o ON u.user_id = o.user_id
JOIN
    order_items oi ON o.order_id = oi.order_id
JOIN
    products p ON oi.product_id = p.product_id
GROUP BY
    u.user_id, u.username
HAVING
    COUNT(DISTINCT p.category_id) = (SELECT COUNT(*) FROM categories);



-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT
  p.product_id,
  p.product_name
FROM
  products p
LEFT JOIN
  reviews r ON p.product_id = r.product_id
WHERE
  r.product_id IS NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

SELECT DISTINCT
    u.user_id,
    u.username
FROM
    orders o1
JOIN
    users u ON o1.user_id = u.user_id
JOIN
    orders o2 ON o1.user_id = o2.user_id AND o1.order_date = o2.order_date - INTERVAL '1 day';
