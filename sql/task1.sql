----------------------------------------------------------------------------
-- NOTE:
-- 1. ids are casted to integer to look nicer
-- 2. tested csv files by changing values but modified back to original.  --
----------------------------------------------------------------------------

-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

SELECT *
FROM product_data p
JOIN category_data c ON p.category_id = c.category_id
WHERE c.category_name LIKE "%Sports%"; 
--assuming that we don't know the ID of the category. Can be simpler if we knew already.

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT CAST(u.user_id AS INT) AS 'user ID', u.username as 'username', COUNT(o.order_id) as 'total orders'
FROM user_data u
JOIN order_data o ON u.user_id = o.user_id
GROUP BY o.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

SELECT CAST(p.product_id AS INT) AS 'product ID', p.product_name AS 'product name', AVG(r.rating) AS 'Average Rating' 
FROM product_data p 
JOIN review_data r ON p.product_id = r.product_id 
GROUP BY p.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT CAST(o.user_id AS INT) AS 'User ID', u.username AS 'Username', o.total_amount AS 'total amount' 
FROM order_data o 
JOIN user_data u ON o.user_id = u.user_id 
ORDER BY o.total_amount DESC 
LIMIT 5;