-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

SELECT Products.product_id, Products.product_name, AVG(Reviews.rating) as average_rating
FROM Products
LEFT JOIN Reviews ON Reviews.product_id = Products.product_id
GROUP BY Products.product_id, Products.product_name
ORDER BY average_rating DESC
HAVING AVG(Reviews.rating) = (SELECT MAX(avg_rating) FROM (SELECT AVG(rating) AS avg_rating FROM Reviews GROUP BY product_id) AS subquery);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT Users.user_id, Users.username
FROM Users
JOIN Orders ON Users.user_id = Orders.user_id
WHERE Orders.order_id IN (
    SELECT Orders.order_id
    FROM Orders
    JOIN Order_Items ON Orders.order_id = Order_Items.order_id
    JOIN Products ON Order_Items.product_id = Products.product_id
    JOIN Categories ON Products.category_id = Categories.category_id
    GROUP BY Orders.order_id, Categories.category_id
    HAVING COUNT(DISTINCT Categories.category_id) = (SELECT COUNT(*) FROM Categories)
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT Products.product_id, Products.product_name
FROM Products
LEFT JOIN Reviews ON Products.product_id = Reviews.product_id
WHERE Reviews.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH UserConsecutiveOrders AS (
    SELECT
        user_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
    FROM Orders
)
SELECT DISTINCT Users.user_id, Users.username
FROM UserConsecutiveOrders
JOIN Users ON UserConsecutiveOrders.user_id = Users.user_id
WHERE order_date = DATE_ADD(prev_order_date, INTERVAL 1 DAY);
