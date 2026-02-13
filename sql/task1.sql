-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
    SELECT * FROM Products p
    JOIN Categories c ON p.category_id == c.category_id
    WHERE c.category_name == 'Electronics'; -- I chose electronics, it can be changed for any other category
-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
    SELECT u.user_id, u.username, COUNT(o.order_id) as total_orders
    FROM users u LEFT JOIN orders o -- Only include entries where the user exists
    ON u.user_id == o.user_id
    GROUP BY u.user_id;
-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
    SELECT p.product_id, p.product_name, AVG(r.rating) as average_rating
    FROM products p INNER JOIN reviews r -- Inner join because I didn't want to include product_name/average_rating that didnt exist
    ON p.product_id == r.product_id
    GROUP BY r.product_id;
-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
    SELECT u.user_id, u.username, sum(o.total_amount) as total_spent
    FROM orders o LEFT JOIN users u
    ON o.user_id == u.user_id
    GROUP BY o.user_id 
    ORDER BY total_spent DESC
    LIMIT 5;