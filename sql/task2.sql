-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH product_avg_ratings AS (
	SELECT r.product_id, p.product_name, AVG(r.rating) AS avg_rating
	FROM review_data AS r
	JOIN product_data AS p
	ON r.product_id = p.product_id
	GROUP BY r.product_id
) 

SELECT product_id, product_name, avg_rating
FROM product_avg_ratings
WHERE avg_rating = (SELECT MAX(avg_rating) FROM product_avg_ratings);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
WITH total_categories AS (
	SELECT COUNT(*) AS total_categories
    FROM category_data AS c
), 

user_category_count AS (
	SELECT u.user_id, u.username, COUNT(DISTINCT  p.category_id) as category_count
	FROM user_data AS u
    JOIN order_data AS o ON u.user_id = o.user_id
    JOIN order_items_data oi ON o.order_id = oi.order_id
    JOIN product_data p ON oi.product_id = p.product_id
    GROUP BY u.user_id
)

SELECT ucc.user_id, ucc.username
FROM user_category_count AS ucc
CROSS JOIN total_categories
WHERE ucc.category_count = total_categories.total_categories;

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT p.product_id, p.product_name
FROM product_data AS p
LEFT JOIN review_data AS r 
ON p.product_id = r.product_id
WHERE r.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
WITH consec_orders AS (
	SELECT u.user_id, u.username, o.order_date, LAG(o.order_date) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS previous_order_date
	FROM user_data AS u
	JOIN order_data  AS o
	ON u.user_id = o.user_id
)

SELECT DISTINCT user_id, username
FROM consec_orders
WHERE order_date = DATE(previous_order_date, '+1 day');
