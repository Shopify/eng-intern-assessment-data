-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

SELECT *  --selecting all columns
FROM Products --from the Products table
WHERE category_id = 1; --where the category_id is 1 (Sports)




-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT u.user_id, u.username, COUNT(o.order_id) AS total_orders --selecting the user_id, username, and total number of orders
FROM Users AS u  -- from the Users table
LEFT JOIN Orders AS o ON u.user_id = o.user_id --left joining the Orders table on the user_id
GROUP BY u.user_id, u.username; --grouping by the user_id and username

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating --selecting the product_id, product_name, and average rating
FROM Products AS p --from the Products table
LEFT JOIN Reviews AS r ON p.product_id = r.product_id --left joining the Reviews table on the product_id
ORDER BY p.product_id; --ordering by the product_id

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT u.user_id, u.username, SUM(o.total_amount) AS total_amount_spent --selecting the user_id, username, and total amount spent
FROM Users AS u --from the Users table
JOIN Orders AS o ON u.user_id = o.user_id -- joining the Orders table on the user_id
GROUP BY u.user_id, u.username -- grouping by the user_id and username
ORDER BY total_amount_spent DESC -- ordering by the total amount spent in descending order
LIMIT 5; -- limiting the results to 5
