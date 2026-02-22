-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Finds category ID corresponding to category name for flexibility.
SELECT * FROM Products WHERE category_id=
    (SELECT category_id FROM Categories WHERE category_name='Sports & Outdoors');

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- Aggregates orders by user first for a smaller join.
-- Right join is used to include users without orders, which have a default order count of 0.
WITH Counted_Orders AS (
    SELECT user_id, COUNT(user_id) AS user_orders FROM Orders GROUP BY user_id
)
SELECT u.user_id, u.username, COALESCE(co.user_orders, 0) FROM Counted_Orders co RIGHT JOIN Users u ON co.user_id=u.user_id
ORDER BY u.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- Aggregates average ratings first for a smaller join.
-- Right join is used to include products without ratings.
-- No default value is provided, as no numerical filler value would make sense here.
-- Sorted by product id since no other ordering was specified.
WITH Average_Ratings AS (
    SELECT product_id, AVG(rating) AS avg_rating FROM Reviews GROUP BY product_id
)
SELECT p.product_id, p.product_name, ar.avg_rating FROM Average_Ratings ar RIGHT JOIN Products p ON ar.product_id=p.product_id
ORDER BY p.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- Performs sum upfront for a smaller join. Right join ensures that spending is calculated for
-- all users, even if no order are made by those users. User total spending is defaulted
-- to 0.
WITH Total_Spending AS (
    SELECT user_id, SUM(total_amount) AS user_total FROM Orders GROUP BY user_id
)
SELECT u.user_id, u.username, COALESCE(ts.user_total, 0) as user_total_nonnull
FROM Total_Spending ts RIGHT JOIN Users u ON ts.user_id = u.user_id
ORDER BY user_total_nonnull DESC
LIMIT 5;