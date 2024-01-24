-- Problem 5: Retrieve the products with the highest average rating
WITH product_averages AS (
    SELECT
        p.product_id,
        p.product_name,
        ROUND(AVG(r.rating), 2) AS average_rating,
        RANK() OVER (ORDER BY ROUND(AVG(r.rating), 2) DESC) AS rating_rank
    FROM reviews AS r
    JOIN products AS p ON r.product_id = p.product_id
    GROUP BY p.product_id, p.product_name
)
SELECT
    product_id,
    product_name,
    average_rating
FROM product_averages
WHERE rating_rank = 1;


-- Problem 6: Retrieve the users who have made at least one order in each category
SELECT u.user_id, u.username
FROM users u
WHERE NOT EXISTS (
    SELECT c.category_id
    FROM categories c
    WHERE NOT EXISTS (
        SELECT DISTINCT p.category_id
        FROM products p
        JOIN order_items oi ON p.product_id = oi.product_id
        JOIN orders o ON oi.order_id = o.order_id
        WHERE o.user_id = u.user_id AND p.category_id = c.category_id
    )
);

-- Problem 7: Retrieve the products that have not received any reviews
SELECT product_id, product_name
FROM products
WHERE product_id NOT IN (SELECT DISTINCT(product_id) FROM reviews);

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
WITH OrderedOrders AS (
  SELECT
    user_id,
    order_date,
    LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
  FROM
    orders
)
SELECT
  u.user_id,
  u.username
FROM
  OrderedOrders oo
JOIN
  users u ON oo.user_id = u.user_id
WHERE
  DATEDIFF(order_date, prev_order_date) = 1 OR prev_order_date IS NULL;
