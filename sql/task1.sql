-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT 
    product_id, product_name, description, price, category_id
FROM 
    products
WHERE 
    category_id = (
        SELECT category_id FROM category WHERE category_name LIKE 'Sports%'
    )


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT u.user_id, u.username, o.total_orders
FROM
(
    (
        SELECT user_id, username
        FROM users
    ) u
    INNER JOIN
    (
        SELECT user_id, COUNT(order_id) AS total_orders
        FROM orders
        GROUP BY user_id
    ) o
    ON u.user_id = o.user_id
)


-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT r.product_id, p.product_name, r.avg_rating
FROM
(
    (
        SELECT product_id, product_name
        FROM products
    ) p
    RIGHT JOIN
    (
        SELECT product_id, AVG(rating) AS avg_rating
        FROM reviews
        GROUP BY product_id
    ) r
    ON p.product_id = r.product_id
)


-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT o.user_id, u.username, o.total_amount_spent
FROM
(
    (
        SELECT user_id, username
        FROM users
    ) u
    RIGHT JOIN
    (
        SELECT user_id, SUM(total_amount) AS total_amount_spent
        FROM orders
        GROUP BY user_id
    ) o
    ON u.user_id = o.user_id
)
ORDER BY o.total_amount_spent DESC
LIMIT 5