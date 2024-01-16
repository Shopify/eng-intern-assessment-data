-- NOTE: first set up data paths (initialize schema and datavalues)
SET search_path TO onlineShopping;
-- NOTE: the following code is in psql

-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- First get the category_ids for "Sports" 
--          (going to assume that there are multiple potential categories related to sports since name is not the key)
-- NOTE: subquery done to reduce unnecessary join rows (expensive operation)
SELECT * FROM Products NATURAL JOIN (SELECT * FROM Categories WHERE category_name LIKE "%Sports%" or category_name LIKE "%sports%");


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- From a natural join of users with their orders, group by user_id and apply aggregation count (left join to include all users)
-- NOTE: GROUP BY includes username since username needs to be aggregated or grouped to be included in the final query, 
--          but since user_id is a primary key, usernames should be unique to user_ids. This addition does not change behavior
-- NOTE: COALESCE is used to handle the case where a user has no orders, in which case the count will be 0
SELECT user_id, username, COALESCE(COUNT(order_id), 0) AS total_orders 
FROM Users NATURAL LEFT JOIN Orders GROUP BY user_id, username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- From a natural join of Products with their Reviews, group by product_id and apply aggregation avg (left join to include all products)
-- NOTE: GROUP BY includes product_name since product_name needs to be aggregated or grouped to be included in the final query, 
--          but since product_id is a primary key, product_names should be unique to product_ids. This addition does not change behavior.
-- NOTE: COALESCE is used to handle the case where a product has no reviews, in which case the average will be NULL
-- NOTE: none of the fields are nullable meaning in a join, how will it be interpreted?
SELECT product_id, product_name, COALESCE(AVG(rating), NULL) AS average_rating 
FROM Product NATURAL LEFT JOIN Reviews GROUP BY product_id, product_name;


-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- What if there were more than 5 users with the 5 highest total value amounts? Should all users be included?
-- NOTE: following code chooses the top 5 people. However, if there are many people with a given total, 
--          query arbitrarily picks names to come first meaning some people are not included. 
-- I will confirm the query specifications. 
SELECT user_id, username, COALESCE(max(total_amount), 0) AS total_amount
FROM Users NATURAL LEFT JOIN Orders GROUP BY user_id, username
ORDER BY total_amount DESC LIMIT 5;


-- If query does wants all people with the top 5 values, this is the following code
-- DROP VIEW IF EXISTS Top5Amounts CASCADE;
-- CREATE VIEW Top5Amounts AS
-- SELECT DISTINCT total_amount FROM MaxSpent
-- ORDER BY total_amount DESC LIMIT 5;

-- Selects the top 5 users, but does not include 0. I am not sure if 0 should be included in this ranking or not. 
-- DROP VIEW IF EXISTS TopSpendersNot0 CASCADE;
-- CREATE VIEW TopSpendersNot0 AS 
-- SELECT user_id, username, total_amount
-- FROM MaxSpent WHERE total_amount in (SELECT total_amount FROM Top5Amounts) and total_amount != 0;