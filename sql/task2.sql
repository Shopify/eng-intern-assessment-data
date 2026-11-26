-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Select the product ID, product name, and the average rating of reviews for each product
SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating
FROM Products p
-- Joining the products and the reviews table on product_id
JOIN Reviews r ON p.product_id = r.product_id
-- Grouping the results by product_id to get the average rating per product
GROUP BY p.product_id, p.product_name
-- Ordering the results by average_rating in descending order to get the highest ratings at the top
ORDER BY average_rating DESC;




-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Selecting the user ID and username from the Users table
SELECT DISTINCT u.user_id, u.username
FROM Users u
-- Joining the orders table to get the orders for each user
JOIN Orders o ON u.user_id = o.user_id
-- Joining the order_items table to get the items within those orders
JOIN Order_Items oi ON o.order_id = oi.order_id
-- Joining the products' table to get the category of those items
JOIN Products p ON oi.product_id = p.product_id
-- Grouping the results by user_id and category_id to count orders per category per user
GROUP BY u.user_id, u.username, p.category_id
-- Having count of orders >= 1 for each category ensures at least one order per category
HAVING COUNT(DISTINCT p.category_id) >= (SELECT COUNT(*) FROM Categories);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Select product ID and product name from the Products table
SELECT p.product_id, p.product_name
FROM Products p
--  Joining the reviews table to find products without reviews
LEFT JOIN Reviews r ON p.product_id = r.product_id
-- Where there are no reviews, the review_id will be NULL
WHERE r.review_id IS NULL;



-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

SELECT user_id, username
-- Using LAG to compare each order date to the previous one per user
FROM (
    SELECT u.user_id, u.username, o.order_date,
           LAG(o.order_date) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS prev_order_date
    FROM Users u
    JOIN Orders o ON u.user_id = o.user_id
) AS subquery
  -- filtering for those where the current order date is one day after the previous order date (consecutive orders)

WHERE order_date = prev_order_date + INTERVAL '1 day'
  -- grouping the results by user_id to ensure there are only users with more than one consecutive order.
GROUP BY user_id, username
HAVING COUNT(*) > 1;
