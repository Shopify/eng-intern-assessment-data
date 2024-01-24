-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem. 

WITH ProductRatings AS (
  SELECT 
    p.product_id, 
    p.product_name, 
    AVG(r.rating) AS average_rating, 
    DENSE_RANK() OVER (ORDER BY AVG(r.rating) DESC) AS ranking
    FROM Products AS p
    LEFT JOIN reviews AS r ON r.product_id = p.product_id
    GROUP BY p.product_id, p.product_name
)
SELECT product_id, product_name, TRUNC(average_rating, 2) AS average_rating
FROM ProductRatings
WHERE ranking = 1;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT u.user_id, u.username, c.category_name FROM users AS u
JOIN orders AS o ON o.user_id = u.user_id
JOIN order_items AS oi ON oi.order_id = o.order_id
JOIN products AS p ON p.product_id = oi.product_id
JOIN categories AS c ON c.category_id = p.category_id
WHERE u.user_id IN (
    SELECT DISTINCT o.user_id FROM orders AS o
    JOIN order_items AS oi ON o.order_id = oi.order_id
    JOIN products AS p ON oi.product_id = p.product_id
    JOIN categories AS c ON p.category_id = c.category_id
    GROUP BY o.user_id
    HAVING COUNT(DISTINCT c.category_id) = (SELECT COUNT(*) FROM Categories)
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT p.product_id, p.product_name FROM Products AS p
LEFT JOIN Reviews AS r ON r.product_id = p.product_id
WHERE r.product_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH date_groups AS ( 
	SELECT 
		u.user_id, 
		u.username, 
		o.order_date,
		LAG(o.order_date) OVER (PARTITION BY u.user_id ORDER BY o.order_date) as previous_order_date
		FROM users AS u
		JOIN orders AS o ON o.user_id = u.user_id
)
SELECT user_id, username FROM date_groups
WHERE previous_order_date = order_date - INTERVAL'1 day'
GROUP BY user_id, username;
