-- Please note that I used Postgres as the underlying RDBMS. 

-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT P.*
FROM Products P,
    Categories C
WHERE C.category_id = P.category_id
    AND C.category_name = 'Sports';
-- Explanation for Problem 1:
-- Join products & categories on category_id. 
-- Return all results where category_name = 'Sports'.
-- (However, note there is no category seeded with the exact name 'Sports' in the database).

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT U.user_id,
    U.username,
    COUNT(*) as total_number_of_orders
FROM Users U,
    Orders O
WHERE O.user_id = U.user_id
GROUP BY U.user_id,
    U.username;
-- Explanation for Problem 2: 
-- Join users & orders on user_id. Group results by user, and for each user,
-- count the number of records. 

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT P.product_id,
    P.product_name,
    AVG(R.rating) as average_rating
FROM Products P,
    Reviews R
WHERE P.product_id = R.product_id
GROUP BY P.product_id,
    P.product_name;
-- Explanation for Problem 3: 
-- Join products & reviews on product_id. Group results by product, and for each product,
-- obtain the average rating using the AVG function.

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT U.user_id,
    U.username,
    SUM(P.amount) as total_amount_spent
FROM Users U,
    Orders O,
    Payments P
WHERE U.user_id = O.user_id
    AND O.order_id = P.order_id
GROUP BY U.user_id, 
    U.username
ORDER BY total_amount_spent DESC
LIMIT 5;
-- Explanation for Problem 4:
-- Note that I am making the assumption that the records in the Payments
-- table correspond to the actual amount spent on an order 
-- (e.g. the total_amount in Orders would be the amount authorized,
-- and the amount in Payments would be the amount captured for an order).
-- With that in mind, we obtain all the payments for each user by joining 
-- the Users, Orders, and Payments table, and grouping by user.
-- Then, for each user, we obtain the total amount by using the SUM
-- function on the amount in the Payments table. Finally, we order 
-- results in a descending fashion (largest first), 
-- and limit the results to get the top 5 spenders.