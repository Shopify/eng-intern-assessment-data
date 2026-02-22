-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

SELECT p.*, "Sports & Outdoors" as category_name
    FROM products p
    WHERE category_id IN
        (SELECT category_id FROM categories c
                WHERE category_name = 'Sports & Outdoors');


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT
    user_id,
    username,
    (SELECT COUNT(order_id) FROM Orders WHERE user_id = Users.user_id) AS total_orders
FROM
    Users;


-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

SELECT
    product_id,
    product_name,
    COALESCE((SELECT AVG(rating) FROM Reviews 
        WHERE product_id = Products.product_id), 0) AS average_rating
FROM
    Products;


-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT
    u.user_id,
    u.username,
    SUM(o.total_amount) AS total_spent
FROM
    Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY
    u.user_id
ORDER BY
    total_spent DESC
LIMIT 5;


