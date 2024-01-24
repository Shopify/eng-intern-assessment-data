-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT
       p.*
FROM Products p
JOIN Categories C USING(category_id)
WHERE category_name = 'Sports & Outdoors'

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT
       u.user_id,
       u.username,
       COUNT(o.order_id) AS total_orders
FROM Users u
JOIN Orders o USING(user_id)
GROUP BY 1,2;
-----
SELECT
       u.user_id,
       u.username,
       COUNT(o.order_id) OVER (PARTITION BY u.user_id) AS total_orders
FROM Users u
JOIN Orders o USING(user_id)

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT
       p.product_id,
       p.product_name,
       AVG(r.rating) OVER (PARTITION BY p.product_id) AS average_rating
FROM  Products p
LEFT JOIN Reviews r USING (product_id)

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT
     user_id,
     username,
     total_spent
FROM (
SELECT
       u.user_id,
       u.username,
       SUM(o.total_amount) AS total_spent,
       DENSE_RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS total_spent_rank
FROM Users u
LEFT JOIN Orders o USING(user_id)
GROUP BY 1,2 ) total_amount
WHERE total_spent_rank <=5
