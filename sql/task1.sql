-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- Problem 1 Solution
SELECT P.product_id, P.product_name, P.description, P.price 
FROM Products P LEFT JOIN Categories C
ON P.category_id = C.category_id
WHERE P.category_id = 8;

-- Problem 2 Solution
SELECT U.user_id, U.username, COUNT(U.user_id) AS num_orders
FROM Users U LEFT JOIN Orders O
ON U.user_id = O.user_id
GROUP BY U.user_id;

-- Problem 3 Solution
SELECT P.product_id, P.product_name, AVG(R.rating) AS avg_rating
FROM Products P LEFT JOIN Reviews R
ON P.product_id = R.product_id
GROUP BY P.product_id;

-- Problem 4 Solution
SELECT TOP 5 U.user_id, U.user_name, SUM(O.amount) AS total_amount
FROM Users U LEFT JOIN Orders O 
ON U.user_id = O.order_id
GROUP BY U.user_id
ORDER BY SUM(O.amount) DESC;