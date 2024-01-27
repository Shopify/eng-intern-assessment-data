-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT p.product_id, p.product_name, p.description, p.price, p.category_id FROM Products p
LEFT JOIN Categories c on p.category_id = c.category_id
WHERE c.category_name = 'Sports & Outdoors';  --assume there is only one category contains "Sports"

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT
    U.user_id,
    U.username,
    COUNT(O.order_id) AS total_orders
FROM Users U
LEFT JOIN Orders O ON U.user_id = O.user_id
GROUP BY U.user_id, U.username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT
    P.product_id,
    P.product_name,
    AVG(R.rating) AS average_rating
FROM Products P
LEFT JOIN  Reviews R ON P.product_id = R.product_id
GROUP BY P.product_id, P.product_name;
-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT
    TOP 5
    U.user_id,
    U.username,
    SUM(O.total_amount) AS total_amount_spent
FROM
    Users U
JOIN
    Orders O ON U.user_id = O.user_id
GROUP BY
    U.user_id, U.username
ORDER BY
    total_amount_spent DESC;
