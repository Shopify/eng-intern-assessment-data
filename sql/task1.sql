-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- As there is not any instruction about the output, I assume that the output should include all columns from the Products table
SELECT *
FROM Products p
WHERE ( SELECT category_name
        FROM Categories c
        WHERE p.category_id = c.category_id ) Like '%Sports%'; -- Use LIKE as the category name is not exactly 'Sports'

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT u.user_id, u.username, COUNT(o.order_id) AS total_orders
FROM Users u
LEFT JOIN Orders o       -- LEFT JOIN to include users with no orders
ON u.user_id = o.user_id
GROUP BY u.user_id, u.username

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating
FROM Products p
LEFT JOIN Reviews r     -- LEFT JOIN to include products with no reviews
ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT u.user_id, u.username, SUM(o.total_amount) AS total_amount_spent
FROM Users u
INNER JOIN Orders o    -- INNER JOIN to exclude users with no orders
ON u.user_id = o.user_id
GROUP BY u.user_id, u.username
ORDER BY total_amount_spent DESC
LIMIT 5;
