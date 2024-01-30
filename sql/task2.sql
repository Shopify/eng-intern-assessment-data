-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH AvgProductRatings AS (
    SELECT products.product_id, products.product_name, AVG(ratings.rating) AS average_rating
    FROM products
    LEFT JOIN ratings ON products.product_id = ratings.product_id
    GROUP BY products.product_id, products.product_name
)
SELECT product_id, product_name, average_rating
FROM AvgProductRatings
WHERE average_rating = (
    SELECT MAX(average_rating) FROM AvgProductRatings
);


SELECT users.user_id, users.username
FROM users
WHERE users.user_id IN (
    SELECT DISTINCT users.user_id
    FROM users
    JOIN orders ON users.user_id = orders.user_id
    JOIN order_details ON orders.order_id = order_details.order_id
    JOIN products ON order_details.product_id = products.product_id
    GROUP BY users.user_id
    HAVING COUNT(DISTINCT products.category) = (
        SELECT COUNT(DISTINCT category) FROM products
    )
);

SELECT products.product_id, products.product_name
FROM products
LEFT JOIN ratings ON products.product_id = ratings.product_id
WHERE ratings.rating IS NULL;

WITH UserOrdersWithDates AS (
    SELECT orders.user_id, orders.order_date, LAG(orders.order_date) OVER (PARTITION BY orders.user_id ORDER BY orders.order_date) AS prev_order_date
    FROM orders
)
SELECT DISTINCT user_id, username
FROM users
JOIN UserOrdersWithDates ON users.user_id = UserOrdersWithDates.user_id
WHERE DATEDIFF(order_date, prev_order_date) = 1;

