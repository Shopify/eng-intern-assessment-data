-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT * FROM products WHERE category_id = "Sports & Outdoors";

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT user_id, username, COUNT(*) FROM orders GROUP BY user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT product_id, products.product_name, AVG(reviews.rating) FROM reviews
    JOIN products
    ON review.product_id = products.product_id
    GROUP BY product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT user_id, users.username, SUM(total_amount) as user_total_amount FROM orders
    JOIN users
    ON orders.user_id = users.user_id
    ORDER BY user_total_amount
    LIMIT 5;
