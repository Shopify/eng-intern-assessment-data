-- Problem 5: Retrieve the products with the highest average rating
-- Query to retrieve the products with the highest average rating.
-- Includes the product ID, product name, and the average rating.

WITH AvgRatings AS (
    SELECT product_id, AVG(rating) AS average_rating
    FROM review_data
    GROUP BY product_id
)
SELECT p.product_id, p.product_name, a.average_rating
FROM product_data p
JOIN AvgRatings a ON p.product_id = a.product_id
WHERE a.average_rating = (SELECT MAX(average_rating) FROM AvgRatings);


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Query to retrieve the users who have made at least one order in each category.
-- Includes the user ID and username.

SELECT u.user_id, u.username
FROM user_data u
WHERE NOT EXISTS (
    SELECT c.category_id
    FROM category_data c
    WHERE NOT EXISTS (
        SELECT o.order_id
        FROM order_data o
        JOIN order_items_data oi ON o.order_id = oi.order_id
        JOIN product_data p ON oi.product_id = p.product_id
        WHERE u.user_id = o.user_id AND p.category_id = c.category_id
    )
);


-- Problem 7: Retrieve the products that have not received any reviews
-- Query to retrieve the products that have not received any reviews.
-- Includes the product ID and product name.

SELECT p.product_id, p.product_name
FROM product_data p
LEFT JOIN review_data r ON p.product_id = r.product_id
WHERE r.review_id IS NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Query to retrieve the users who have made consecutive orders on consecutive days.
-- Includes the user ID and username.

SELECT DISTINCT u.user_id, u.username
FROM user_data u
JOIN order_data o ON u.user_id = o.user_id
JOIN (
    SELECT user_id, order_date, 
           LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
    FROM order_data
) AS ord ON u.user_id = ord.user_id
WHERE ord.order_date = ord.prev_order_date + INTERVAL '1 DAY';
