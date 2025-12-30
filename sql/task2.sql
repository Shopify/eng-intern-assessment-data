-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

DROP VIEW IF EXISTS ProductAverageRatings CASCADE;
CREATE VIEW ProductAverageRatings AS
SELECT product_id, AVG(rating) AS average_rating
FROM Reviews
GROUP BY product_id;

SELECT P.product_id, P.product_name, PAR.average_rating
FROM Products P
JOIN ProductAverageRatings PAR ON P.product_id = PAR.product_id
WHERE PAR.average_rating = (SELECT MAX(average_rating) FROM ProductAverageRatings);


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
DROP VIEW IF EXISTS UserCategories CASCADE;
DROP VIEW IF EXISTS UniqueCategories CASCADE;
CREATE VIEW UniqueCategories AS
SELECT DISTINCT category_id
FROM Categories;

CREATE VIEW UserCategories AS
SELECT DISTINCT U.user_id, P.category_id
FROM Users U
JOIN Orders O ON U.user_id = O.user_id
JOIN Order_Items OI ON O.order_id = OI.order_id
JOIN Products P ON OI.product_id = P.product_id;

SELECT U.user_id, U.username
FROM Users U
WHERE NOT EXISTS (
    SELECT 1
    FROM UniqueCategories UC
    WHERE NOT EXISTS (
        SELECT 1
        FROM UserCategories UC2
        WHERE UC2.user_id = U.user_id AND UC2.category_id = UC.category_id
    )
)
GROUP BY U.user_id, U.username;


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT P.product_id, P.product_name
FROM Products P
LEFT JOIN Reviews R ON P.product_id = R.product_id
WHERE R.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

DROP VIEW IF EXISTS UserOrderDates CASCADE;
DROP VIEW IF EXISTS ConsecutiveUserOrders CASCADE;

CREATE VIEW UserOrderDates AS
SELECT
    user_id,
    order_date,
    LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS previous_order_date
FROM Orders;
CREATE VIEW ConsecutiveUserOrders AS
SELECT
    user_id
FROM UserOrderDates
WHERE order_date - previous_order_date = 1;
SELECT DISTINCT U.user_id, U.username
FROM Users U
JOIN ConsecutiveUserOrders CUO ON U.user_id = CUO.user_id;
