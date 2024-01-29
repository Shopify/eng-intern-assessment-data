-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

SELECT products.product_id, products.product_name, AVG(reviews.rating) AS average_rating 
FROM reviews
JOIN products ON reviews.product_id = products.product_id
GROUP BY products.product_id

-- The subquery calculates the average rating for each product, orders them in descending order,
-- and selects the highest average rating by limiting to 1
HAVING AVG(reviews.rating) = (SELECT (AVG(rating)) avg_rating FROM reviews
                              GROUP BY reviews.product_id
                              ORDER BY avg_rating DESC
                              LIMIT 1);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT users.user_id, users.username 
FROM users
JOIN orders ON users.user_id = orders.user_id
JOIN order_items ON orders.order_id = order_items.order_id
JOIN products ON order_items.product_id = products.product_id
GROUP BY users.user_id
-- The logic here is that if the number of distinct categories that the user has ordered from is equal to the total number of categories,
-- then the user has made at least one order in each category
HAVING COUNT(DISTINCT products.category_id) = (SELECT COUNT(DISTINCT category_id) FROM categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT products.product_id, products.product_name 
FROM products
LEFT JOIN reviews ON products.product_id = reviews.product_id
-- If the review_id is NULL, then the product has not received any reviews since we
-- are performing a left join.
WHERE reviews.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH cte AS (
    SELECT users.user_id, users.username, orders.order_date, 
    LAG(orders.order_date) OVER (PARTITION BY users.user_id ORDER BY orders.order_date) AS previous_order_date
    FROM users
    JOIN orders ON users.user_id = orders.user_id
)
SELECT DISTINCT user_id , username
FROM cte
-- If the previous order date is one day before the current order date, then the user has made consecutive orders on consecutive days.
WHERE order_date = DATE_ADD(previous_order_date, INTERVAL 1 DAY); 