-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH Top_Rating AS (
     SELECT TOP 1
        CASE 
            WHEN (COUNT(r.rating) > 0) 
            THEN CONVERT(DECIMAL(5,2), SUM(r.rating) / COUNT(r.rating))
            ELSE 0.00
        END AS "Average Rating"
    FROM Products p
    LEFT JOIN Reviews r ON p.product_id = r.product_id
    GROUP BY p.product_id, p.product_name
    ORDER BY "Average Rating" DESC
)

SELECT * FROM (
	SELECT p.product_id, p.product_name, 
	CASE 
		WHEN (COUNT(r.rating) > 0) 
            THEN CONVERT(DECIMAL(5,2), SUM(r.rating) / COUNT(r.rating))
            ELSE 0.00
        END AS "Average Rating"
    FROM Products p
    LEFT JOIN Reviews r ON p.product_id = r.product_id
    GROUP BY p.product_id, p.product_name) r
JOIN Top_Rating tr ON tr.[Average Rating] = r.[Average Rating];
-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
WITH CategoryOrders AS (
    SELECT u.user_id, u.username, c.category_id
    FROM Users u
    JOIN Orders o ON u.user_id = o.user_id
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
    JOIN Categories c ON p.category_id = c.category_id
	GROUP BY u.user_id, u.username, c.category_id
)
SELECT user_id, username
FROM CategoryOrders
GROUP BY user_id, username
HAVING COUNT(category_id) = (SELECT COUNT(*) FROM Categories);
-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
WITH ProductReviews as (
	SELECT p.product_id, p.product_name, 
		CASE 
			WHEN COUNT(r.rating) > 0 
			THEN CAST(CONVERT(DECIMAL(5,2), SUM(r.rating) / COUNT(r.rating)) AS varchar)
			ELSE 'No reviews'
		END AS "Average Rating"
	FROM Products p
	LEFT JOIN Reviews r ON p.product_id = r.product_id
	GROUP BY p.product_id, p.product_name
)

SELECT product_id, product_name
FROM ProductReviews
WHERE [Average Rating] = 'No reviews';
-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
WITH PreviousOrders as (
	SELECT *, 
		LAG(order_date) OVER( PARTITION BY user_id ORDER BY order_date) as "Previous Order" 
	FROM Orders
	)

SELECT DISTINCT po.user_id, u.username FROM PreviousOrders po
JOIN  Users u ON po.user_id = u.user_id
WHERE DATEDIFF(day, [Previous Order], order_date) = 1

