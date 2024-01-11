use schema_name;
-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Pretty simple, just get all of the products where the category id in the products table is the same as the
-- category id that corresponds to the "Sports" category. Since the sports category is not called "sports"
-- I figured Like would be better
SELECT * FROM products WHERE category_id = (SELECT category_id FROM categories
                                                                       WHERE category_name LIKE '%Sports%');

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- Just count the number of orders, and take all user_id values from the users table, and only the values that match
-- orders table before preforming a groupy by function on that to get the aggregated data
SELECT users.user_id, users.username, COUNT(orders.order_id) AS orders FROM users
    LEFT JOIN orders ON users.user_id = orders.user_id GROUP BY users.user_id, users.username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- Pretty simply just getting the average rating from the reviews table, before joining the result to ensure that only
-- products with reviews will be included. The data is than grouped by the product characteristics
SELECT products.product_id, products.product_name, AVG(reviews.rating) AS average FROM products
    INNER JOIN reviews ON products.product_id = reviews.product_id GROUP BY products.product_id, products.product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- This is almost the same as the problem above except for this one, instead of taking the average of a set (column),
-- we are taking the sum of a column. The same things are done to ensure only users with orders will be counted, and
-- the data is grouped by user characteristics instead of product characteristics. Another difference is that we include
-- the limit of 5 (to only get 5 results) and the descending keyword to get the highest prices first
SELECT users.user_id, users.username, SUM(orders.total_amount) AS total_amount_spent FROM users
    JOIN orders ON users.user_id = orders.user_id GROUP BY users.user_id, users.username ORDER BY total_amount_spent DESC LIMIT 5;
