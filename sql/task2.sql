-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH ProdAvgRating AS (
    SELECT products.product_id, products.product_name, AVG(rating) as average_rating
    FROM reviews
    JOIN products ON reviews.product_id = products.product_id
    GROUP BY products.product_id
)

SELECT product_id, product_name, average_rating
FROM ProdAvgRating
WHERE average_rating = (SELECT MAX(average_rating) FROM ProdAvgRating);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT username
FROM users
WHERE (
    SELECT COUNT(Distinct category_id) 
    FROM orders 
    JOIN order_items 
    ON orders.order_id = order_items.order_id 
    JOIN products 
    ON products.product_id = order_items.product_id
    WHERE orders.user_id = users.user_id) 
    = 
    (SELECT COUNT(Distinct category_id) 
     FROM categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT products.product_id, product_name
FROM products
LEFT JOIN reviews
ON products.product_id = reviews.review_id
WHERE reviews.product_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH ConsDays AS (
    SELECT user_id, order_date, LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) as prev_order_date
    FROM orders
)

SELECT Distinct(users.user_id, username)
FROM users
JOIN ConsDays
ON users.user_id = ConsDays.user_id
WHERE order_date = prev_order_date + 1;