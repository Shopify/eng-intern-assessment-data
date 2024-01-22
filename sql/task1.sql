-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT *
FROM Products
WHERE category_id = (SELECT category_id FROM Categories WHERE category_name = 'Sports & Outdoors');

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT
    U.user_id, U.username, O.num_orders
FROM 
    Users as U
JOIN 
    (SELECT user_id, count(distinct order_id) as num_orders
    FROM Orders
    GROUP BY user_id) as O
ON 
    U.user_id = O.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT
    P.product_id, P.product_name, R.average_rating
FROM 
    Products as P
JOIN 
    (SELECT product_id, AVG(rating) as average_rating
    FROM Reviews
    GROUP BY product_id) as R
ON 
    P.product_id = R.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT
    U.user_id, U.username, O.total_amount
FROM 
    Users as U
JOIN 
    (SELECT user_id, SUM(total_amount) as total_amount
    FROM Orders
    GROUP BY user_id) as O
ON 
    U.user_id = O.user_id
ORDER BY
    o.total_amount DESC
LIMIT 5;
