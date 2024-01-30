-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
-- Problem 1
SELECT p.* FROM Products p
    LEFT JOIN Categories c
        ON p.category_id=c.category_id
    WHERE LOWER(c.category_name) like '%sports%'

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
-- Problem 2
SELECT u.user_id, u.username, count(o.order_id) FROM Users u
    JOIN Orders o
        ON u.user_id=o.user_id
    GROUP BY u.user_id

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
-- Problem 3
SELECT r.product_id, p.product_name, AVG(r.rating) FROM Products p
    JOIN Reviews r
        ON p.product_id=r.product_id
    GROUP BY r.product_id

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
-- Problem 4
SELECT u.user_id, u.username, sum(o.total_amount) FROM Users u
    JOIN Orders o
        ON u.user_id=o.user_id
    GROUP BY u.user_id, u.username
    ORDER BY 3 DESC
    LIMIT 5











