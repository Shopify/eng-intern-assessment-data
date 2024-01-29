-- Problem 5: Retrieve the products with the highest average rating

-- This command returns the product(s) with the highest average rating, with the product_id, product_name, and average_rating
-- In case of a tie, it returns all those with the highest average rating, ordered by the number of reviews (more reviews -> higher confidence)
WITH AverageRatings AS (
    SELECT product_id, AVG(rating) as avg_rating, COUNT(rating) as num_reviews
    FROM reviews
    GROUP BY product_id
)
SELECT products.product_id, products.product_name, AverageRatings.avg_rating
FROM products
JOIN AverageRatings ON products.product_id = AverageRatings.product_id
WHERE AverageRatings.avg_rating = (SELECT MAX(avg_rating) FROM AverageRatings)
ORDER BY AverageRatings.num_reviews DESC;



-- Problem 6: Retrieve the users who have made at least one order in each category

-- This command returns the users who have made at least one order in each category, with the user_id and username
SELECT users.user_id, users.username FROM Users
JOIN orders ON users.user_id = orders.user_id
JOIN order_items ON orders.order_id = order_items.order_id
JOIN products ON order_items.product_id = products.product_id
GROUP BY users.user_id
HAVING COUNT(DISTINCT products.category_id) = (SELECT COUNT(*) FROM categories);



-- Problem 7: Retrieve the products that have not received any reviews

-- This command returns the products that have not received any reviews, with the product_id and product_name
SELECT products.product_id, products.product_name FROM products
LEFT JOIN reviews ON products.product_id = reviews.product_id
WHERE reviews.product_id IS NULL;



-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days

-- This command returns the users who have made consecutive orders on consecutive days, with the user_id and username
WITH ConsecutiveOrders AS (
    SELECT orders.user_id, orders.order_date, LAG(orders.order_date) OVER (PARTITION BY orders.user_id ORDER BY orders.order_date) AS previous_order_date
    FROM orders
)
SELECT users.user_id, users.username
FROM users
JOIN ConsecutiveOrders ON users.user_id = ConsecutiveOrders.user_id
WHERE ConsecutiveOrders.order_date = ConsecutiveOrders.previous_order_date + INTERVAL '1 day';