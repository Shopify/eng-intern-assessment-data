-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT *
FROM Products
WHERE category_id = 8;

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
WITH OrderInfo AS (
    SELECT user_id, count(*) as total_order
    FROM Orders
    GROUP BY user_id
)
SELECT Users.user_id, usename, total_order
FROM OrderInfo JOIN Users on OrderIndo.user_id = Users.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
With ProductInfo AS (
    SELECT product_id, avg(rating) as average
    FROM Reviews
    GROUP BY product_id
)
SELECT Products.product_id, product_name, average
FROM ProductInfo JOIN Products ON ProductInfo.product_id = Products.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
WITH TopFive As (
    SELECT user_id, sum(total_amount) as total_spent
    FROM Orders
    GROUP BY user_id
    ORDER BY total_spent DESC
    LIMIT 5
)
SELECT Users.user_id, username, total_spent
FROM TopFive JOIN Users on TopFive.user_id = Users.user_id;