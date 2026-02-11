-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT U.user_id, U.username, COUNT(O.order_id) AS total_orders
FROM Users AS U
LEFT JOIN Orders AS O ON U.user_id = O.user_id
GROUP BY U.user_id, U.username
ORDER BY U.user_id;
