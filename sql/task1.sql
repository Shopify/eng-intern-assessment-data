-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT *
FROM 
    product_data
INNER JOIN
    category_data on product_data.category_id=category_data.category_id
WHERE 
    category_name = 'Sports & Outdoors';


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT
    user_data.user_id,
    user_data.username,
    COUNT(order_items_data.order_id) AS total_orders
FROM
    user_data
INNER JOIN
    order_data ON user_data.user_id = order_data.user_id
INNER JOIN
    order_items_data ON order_data.order_id = order_items_data.order_id
GROUP BY
    user_data.user_id, user_data.username;


-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

SELECT
    product_data.product_id,
    product_data.product_name,
    AVG(review_data.rating) AS average_rating
FROM
    product_data
INNER JOIN
    review_data ON product_data.product_id=review_data.product_id
GROUP BY
    product_data.product_id, product_data.product_name;


-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent..

SELECT
    user_data.user_id,
    user_data.username,
    SUM(order_data.total_amount) AS total_amount_spent
FROM
    user_data
INNER JOIN
    order_data ON user_data.user_id = order_data.user_id
GROUP BY
    user_data.user_id, user_data.username
ORDER BY
    total_amount_spent DESC
LIMIT 5;