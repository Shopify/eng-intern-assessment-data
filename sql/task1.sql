-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT products.*
FROM products NATURAL JOIN categories
Where category_name LIKE '%Sports%';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT user_id, username, count(order_id)
FROM users NATURAL JOIN orders
GROUP BY user_id, username
ORDER BY user_id ASC;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT product_id, product_name, avg(rating)
FROM products NATURAL JOIN reviews
GROUP BY product_id, product_name
ORDER BY product_id ASC;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT user_id, username, sum(total_amount)
FROM users NATURAL JOIN orders
GROUP BY user_id, username
ORDER BY sum(total_amount) DESC
LIMIT 5;
