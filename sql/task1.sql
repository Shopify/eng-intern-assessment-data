-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Retrieve all the info except category_id about the satisfied products.
-- WHERE clause is used to only select products that are in the Sports category.
SELECT p.product_id, p.product_name, p.description, p.price
FROM Categories c JOIN Products p 
    ON c.category_id = p.category_id
WHERE c.category_name = 'Sports & Outdoors';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- LEFT JOIN is used to ensure every user is included in the result.
-- GROUP BY is used to count total number of order_id for each user_id. Since 
-- user_id is the primary key of Users, each user_id corresponds to only 1 
-- username.
-- ORDER BY user_id to make the result easier to check.
SELECT u.user_id, u.username, COUNT(o.order_id) AS total_num_order
FROM Users u LEFT JOIN Orders o
    ON u.user_id = o.user_id    
GROUP BY u.user_id, u.username
ORDER BY u.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- COALESCE is used to set avg_rating as 0 if a product doesn't have any review.
-- LEFT JOIN is used to ensure every product is included in the result.
-- GROUP BY is used to average all ratings for each product_id. Since product_id
-- is the primary key of Products, each product_id corresponds to only 1 
-- product_name.
-- ORDER BY product_id to make the result easier to check.
SELECT p.product_id, p.product_name, 
    COALESCE(AVG(r.rating), 0) AS avg_rating
FROM Products p LEFT JOIN Reviews r
    ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
ORDER BY p.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- COALESCE is used to set total_amount_spent as 0 if a user hasn't ordered yet.
-- All users are calculated to avoid edge cases when no users spent on any orders.
-- ORDER BY DESC is used to order the total amount spent in descreasing order.
-- LIMIT is used to retrieve only the top 5 users. When there is a tie, order
-- by user_id ascendingly.
SELECT u.user_id, u.username, 
    COALESCE(SUM(o.total_amount),0) AS total_amount_spent
FROM Users u LEFT JOIN Orders o
    ON u.user_id = o.user_id
GROUP BY u.user_id, u.username
ORDER BY total_amount_spent DESC, u.user_id
LIMIT 5;
