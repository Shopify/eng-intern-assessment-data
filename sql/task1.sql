-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

SELECT product_name 
FROM Products P
INNER JOIN Categories C ON P.category_id = C.category_id
WHERE category_name = 'Sports & Outdoors';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

--Canidate's note:
--LEFT JOIN is used to retrieve all the users even if they have no orders
SELECT U.user_id, U.username, Count(O.order_id) as total_orders
FROM Users U
LEFT JOIN Orders O ON U.user_id = O.user_id
GROUP BY U.user_id
ORDER By U.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

--Canidate's note:
--LEFT JOIN is use in case there are products with no reviews 
--All missing products data is manually inserted in the database to resolve the foreign key constraint
SELECT P.product_id, P.product_name, Round(avg(R.rating),1) as avg_rating
From Products P
LEFT JOIN Reviews R ON P.product_id = R.product_id
GROUP BY P.product_id
ORDER BY P.product_id;



-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

--Canidate's note:
--LEFT JOIN is used to retrieve all the users even if they have no orders
SELECT U.user_id, U.username, sum(O.total_amount) as orders_total_amount
FROM Users U
LEFT JOIN Orders O ON U.user_id = O.user_id
GROUP BY U.user_id
ORDER By sum(O.total_amount) DESC
LIMIT 5;