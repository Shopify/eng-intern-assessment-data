-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT p.product_id, p.product_name, p.description, p.price -- selecting product details from products table
FROM Products p
    JOIN Categories c ON p.category_id = c.category_id -- join with categories table on category id
WHERE
    LOWER(c.category_name) Like '%Sports%'; -- filter by sports


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT u.user_id, u.username, COUNT(o.order_id) AS total_orders
FROM Users u
    LEFT JOIN Orders o ON u.user_id = o.user_id -- left join with orders table on user id (even users with 0 orders are returned)
GROUP BY
    u.user_id,
    u.username; -- ensure unique records


-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating -- calculate average rating for each product
FROM Products p
    LEFT JOIN Reviews r ON p.product_id = r.product_id -- left join reviews table on product id 
GROUP BY
    p.product_id,
    p.product_name; -- ensure unique products


-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT u.user_id, u.username, SUM(o.total_amount) AS total_amount_spent -- calculate total amount spent
FROM Users u
    JOIN Orders o ON u.user_id = o.user_id -- join orders table on user id
GROUP BY
    u.user_id,
    u.username -- ensure unqiue users
ORDER BY total_amount_spent DESC
LIMIT 5; -- limit the results to the top 5 users