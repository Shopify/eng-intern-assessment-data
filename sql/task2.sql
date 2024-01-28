-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- We can solve this problem using CTEs by first calculating the average rating for each product, 
-- and then finding the max of these averages to identify the products with the highest average rating.
WITH avgratedproducts AS (
    SELECT product_id, AVG(rating) AS average_rating
    FROM Reviews
    GROUP BY product_id
), ratingmax AS (
    SELECT MAX(average_rating) AS max_rating
    FROM avgratedproducts
)
SELECT p.product_id, p.product_name,rp.average_rating
FROM Products p
JOIN
    avgratedproducts rp ON p.product_id = rp.product_id
JOIN
    ratingmax mr ON rp.average_rating = mr.max_rating;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
-- Retrieve users who have made at least one order in each category

-- We can identify users who have placed at least one order in every product category by joining Users, Orders, Order_Items, and Products
-- and groping hte results by user. The having clause then is used to compare the count of distinct categories versus the total amount of categories,
SELECT u.user_id, u.username
FROM Users u
JOIN 
    Orders o ON u.user_id = o.user_id
JOIN 
    Order_Items oi ON o.order_id = oi.order_id
JOIN 
    Products p ON oi.product_id = p.product_id
GROUP BY u.user_id, u.username
HAVING 
COUNT(DISTINCT p.category_id) = (SELECT COUNT(DISTINCT category_id) FROM Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- We can use a left join between products and reviews, and then to find products with no matching review entries we can
-- check whether it is null or not.
SELECT p.product_id, p.product_name
FROM Products p
    LEFT JOIN Reviews r ON p.product_id = r.product_id 
WHERE
    r.review_id IS NULL 

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- We can use a window function within a CTE to find hte previous order date for each order.
-- We then select users where the difference between consective order dates is 1 day.
WITH consorders AS (
    SELECT o.user_id, o.order_date,
        LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_order_date
    FROM orders o
)
SELECT DISTINCT co.user_id, u.username
FROM consorders co
JOIN users u ON co.user_id = u.user_id
WHERE DATEDIFF(co.order_date, co.prev_order_date) = 1;