-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT U.user_id, U.username, SUM(O.total_amount) AS total_spent
FROM Users AS U
JOIN Orders AS O ON U.user_id = O.user_id
GROUP BY U.user_id, U.username
ORDER BY total_spent DESC
LIMIT 5;