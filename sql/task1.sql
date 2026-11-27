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

-- Problem 1 Solution:

SELECT product_name FROM product_data WHERE category_id = 8;

-- Problem 2 Solution:

SELECT cart_data.user_id, user_data.username, SUM(cart_item_data.quantity) AS total_orders
FROM cart_data 
INNER JOIN user_data ON cart_data.user_id = user_date.user_id;
INNER JOIN cart_item_data ON cart_data.cart_id = cart_item_data.cart_id;

-- Problem 3 Solution:

SELECT review_data.product_id, product_data.product_name, (
    SELECT AVG(review_data.rating) 
    FROM review_data 
    WHERE review_data.product_id = product_data.product_id
) AS average_rating
FROM product_data;

-- Problem 4 Solution:

SELECT TOP 5 order_data.user_id, user_data.username, order_data.total_amount
FROM order_data
INNER JOIN user_data ON order_data.user_id = user_data.user_id
ORDER BY order_data.total_amount DESC;
