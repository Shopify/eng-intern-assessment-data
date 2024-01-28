-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH avg_rating_tab AS (
	SELECT pr.product_id, pr.product_name, AVG(rating) AS avg_rating
	FROM reviews AS r
	LEFT JOIN products AS pr
		ON pr.product_id = r.product_id
	GROUP BY pr.product_id, pr.product_name
)
	
SELECT product_id, product_name, avg_rating
FROM avg_rating_tab
WHERE avg_rating = (
	SELECT MAX(avg_rating) AS max_rating
	FROM avg_rating_tab
	);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT d.user_id, d.username
FROM (
	SELECT u.user_id, u.username, COUNT(DISTINCT category_id) AS ordered_categories
	FROM order_items AS oi
	LEFT JOIN orders AS o
		ON o.order_id = oi.order_id
	LEFT JOIN products AS pr
		ON pr.product_id = oi.product_id
	LEFT JOIN users AS u
		ON u.user_id = o.user_id
	GROUP BY u.user_id, u.username
	) AS d
WHERE d.ordered_categories = (SELECT COUNT(DISTINCT category_id) FROM Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT *
FROM (SELECT pr.product_id, pr.product_name, COUNT(r.review_id) AS review_number
	FROM reviews AS r
	LEFT JOIN products AS pr
		ON r.product_id = pr.product_id
	GROUP BY pr.product_id, pr.product_name)
WHERE review_number = 0;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
SELECT u.user_id, u.username
FROM (
	SELECT *, order_date-LAG(order_date, 1)
		OVER (
			PARTITION BY user_id
			ORDER BY order_date
		) AS order_date_diff
	FROM orders AS o
	) AS date_data
LEFT JOIN users AS u
	ON date_data.user_id = u.user_id
WHERE date_data.order_date_diff = 1;