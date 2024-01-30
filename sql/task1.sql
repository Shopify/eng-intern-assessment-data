-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

SELECT P.*, C.category_name 
FROM Products P, Categories C 
WHERE P.category_id = C.category_id AND C.category_name LIKE '%sports%';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT U.user_id, U.username, SUM(O_I.quantity) AS total_orders
FROM Users U, Orders O, Order_Items O_I
WHERE U.user_id = O.user_id AND O.order_id = O_I.order_id
GROUP BY U.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

SELECT 
    R.product_id, 
    P.product_name, 
    AVG(R.rating) as avg_rating
FROM 
    Reviews R, 
    Products P
WHERE
    R.product_id = P.product_id
GROUP BY
    R.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT
    U.user_id, 
    U.username,
    SUM(O.total_amount)
FROM
    Users U,
    Orders O
WHERE
    U.user_id = O.user_id
GROUP BY
    U.user_id;
