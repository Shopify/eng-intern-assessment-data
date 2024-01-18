-- NOTE: the following code is in psql

-- NOTE: The search path below is initialized in modified schema.sql code. 
--       If not tested in this way, please comment out the below line. 
SET search_path TO onlineShopping;


-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- First get the category_ids for "Sports" in a subquery and find all products with those ids. 
--          (going to assume that there are multiple potential categories related to sports since name is not the key)
-- The subquery done to reduce unnecessary join rows (expensive operation), although unnecessary for a correct solution. 
SELECT * FROM Products NATURAL JOIN 
(SELECT * FROM Categories WHERE category_name LIKE '%Sports%' or category_name LIKE '%sports%')
ORDER BY product_id;


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- From a natural join of users with their orders, group by user_id and apply aggregation count (left join to include all users)
-- NOTE: GROUP BY includes username since username needs to be aggregated or grouped to be included in the final query, 
--          but since user_id is a primary key, usernames should be unique to user_ids. This addition does not change behavior
-- COALESCE is used to handle the case where a user has no orders, in which case the count will be 0.
SELECT user_id, username, COALESCE(COUNT(order_id), 0) AS total_orders 
FROM Users NATURAL LEFT JOIN Orders GROUP BY user_id, username ORDER BY user_id;


-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- From a natural join of Products with their Reviews, group by product_id and apply aggregation avg (left join to include all products)
-- NOTE: GROUP BY includes product_name since product_name needs to be aggregated or grouped to be included in the final query, 
--          but since product_id is a primary key, product_names should be unique to product_ids. This addition does not change behavior.
-- COALESCE is used to handle the case where a product has no reviews, in which case the average will be NULL
SELECT product_id, product_name, COALESCE(AVG(rating), NULL) AS average_rating 
FROM Products NATURAL LEFT JOIN Reviews GROUP BY product_id, product_name ORDER BY product_id;


-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- NOTE: Following query chooses the top 5 people ordered descending by their highest total amount. 
-- However, if there are many people with the same highest total, the query arbitrarily truncates
-- meaning some people are not included despite having the same value. 
-- I raised Issue #48 on Github on this interpretation, which is not answered at this time. 
-- I chose this interpretation as this query seems to emphasize the top 5 users rather than users with top 5 values. 
SELECT user_id, username, max(total_amount) AS total_amount
FROM Users NATURAL JOIN Orders GROUP BY user_id, username
ORDER BY total_amount DESC LIMIT 5;