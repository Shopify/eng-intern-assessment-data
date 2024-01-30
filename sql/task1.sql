-- TASK 1

-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- COMMENT: Assumed there might be several sport categories, using pattern to match all of them

SELECT *
FROM Products
WHERE category_id = (SELECT category_id 
					 FROM Categories 
                     WHERE category_name like '%Sports%');


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- COMMENT: left join because we need every user's data

SELECT u.user_id, u.username, COUNT(o.order_id) AS total_orders
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username;


-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- COMMENT: left join because we need every product's data

SELECT p.product_id, p.product_name, AVG(r.rating) AS avg_rating
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name;


-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- COMMENT: used left join for the case when user with 0 orders makes it into top 5

SELECT u.user_id, u.username, SUM(o.total_amount) AS total_amount_spent
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username
ORDER BY total_amount_spent DESC
LIMIT 5; 