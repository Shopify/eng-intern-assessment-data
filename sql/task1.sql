-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Selecting all products where the category ids correspond to the "Sports" category,
-- by joining both the Products and Categories tables on a matching column "category_id".

SELECT *
FROM Products p 
JOIN Categories c ON p.category_id = c.category_id
WHERE LOWER(c.category_name) LIKE LOWER("%Sports%");

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- Select user ID, username, and total no of orders (using aggregate function 'COUNT') as
-- columns from a joined table between 'Users' and 'Orders' matched on the user_id column. 
-- Lastly, groupby is performed to retrieve the aggregated data.
-- Note: LEFT JOIN is used to include users with 0 orders.

SELECT u.user_id, u.username, COUNT(o.order_id) as total_no_of_orders
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.user_id 
GROUP BY u.user_id, u.username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- Select product ID, product name, and average rating (using aggregate function 'AVG') as
-- columns from a joined table between 'Products' and 'Reviews' matched on the product_id column. 
-- Lastly, groupby is performed to retrieve the aggregated data.
-- Note: INNER JOIN is used to ONLY include products with reviews.

SELECT p.product_id, p.product_name, AVG(r.rating) as average_rating
FROM Products p 
INNER JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- Select user ID, username, and total amount spent (using aggregate function 'SUM') as
-- columns from a joined table between 'Users' and 'Orders' matched on the user_id column. 
-- Groupby is again performed, and the data is ordered in descending order based on total amount spent).
-- Note: Upon inspecting the order data, seems like user 17 and user 29 have the exact same total amount spent.
-- *If you wish to include both users in the list, 'LIMIT 6' could be used instead.

SELECT u.user_id, u.username, SUM(o.total_amount) as total_amount_spent
FROM Users u 
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username
ORDER BY total_amount_spent DESC
LIMIT 5;