-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

SELECT p.product_id, p.product_name, p.description, p.price -- Selecting product details from the Products table,
FROM Products p -- aliased as 'p',
JOIN Categories c -- then join with the Categories table, aliased as 'c', 
ON p.category_id = c.category_id -- with Join condition: match category IDs in both tables.
WHERE c.category_name = 'Sports'; -- Finally, filter conditionally: select only 'Sports' category.

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT u.user_id, u.username, COUNT(o.order_id) AS total_orders -- Coun the number of orders per user, and label it as 'total_orders',
FROM Users u -- from the Users table, aliased as 'u',
LEFT JOIN Orders o -- then left join with the Orders table, aliased as 'o', 
ON u.user_id = o.user_id -- with Join condition: match user IDs in both tables. 
GROUP BY u.user_id, u.username; -- Finally, group the results by ID and username to ensure unique user records.

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating -- Calculate the 'average_rating' for each product,
FROM Products p -- from the Products table, aliased as 'p',
LEFT JOIN Reviews r -- then left join with the Reviews table, aliased as 'r',
ON p.product_id = r.product_id -- with Join condition: match product IDs in both tables.
GROUP BY p.product_id, p.product_name; -- Finally, group the results by product ID and product name to ensure unique product records

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT u.user_id, u.username, SUM(o.total_amount) AS total_spent -- Sum the 'total_spent' on orders per user,
FROM Users u -- from the Users table, aliased as 'u',
JOIN Orders o -- then join with the Orders table, aliased as 'o',
ON u.user_id = o.user_id -- with Join condition: match user IDs in both tables.
GROUP BY u.user_id, u.username -- Group the results by user ID and username to ensure unique user records.
ORDER BY total_spent DESC -- Order in descending order,
LIMIT 5; -- and limit the results to the top 5 users.