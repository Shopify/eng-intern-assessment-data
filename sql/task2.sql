-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Calculates average product rating for all products
WITH AverageProductRating AS (
    SELECT
        p.product_id,
        p.product_name,
        AVG(Reviews.rating) AS average_rating
    FROM Products p
    LEFT JOIN Reviews ON p.product_id = Reviews.product_id
    GROUP BY 
        p.product_id, 
        p.product_name
)
-- Selects the top 5 rated products from the AverageProductRating table calculated above
SELECT
    product_id,
    product_name,
    average_rating
FROM AverageProductRating
ORDER BY average_rating DESC
LIMIT 5;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Selects the user_id and username for all users who have made at least one order in each category
-- Tables: Users (U), Orders (O), Order_Items (OI), Products (P), Categories (C)
SELECT 
    u.user_id,
    u.username
FROM Users u
WHERE u.user_id IN (
    SELECT DISTINCT u.user_id
    FROM Users u
    -- Joins Orders(o), Order_Item(oi), Products(p), and Categories(c)
    JOIN Orders o ON u.user_id = o.user_id
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
    JOIN Categories c ON p.category_id = c.category_id
    GROUP BY u.user_id, c.category_id
    HAVING
    -- Checks if the count of distinct categories a user ordered in is equal to the number of categories
        COUNT(DISTINCT c.category_id) = ( 
            SELECT COUNT(*) AS category_count -- Counts the number of categories in Categories
            FROM Categories
        )
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Selects all products where the review is null (hasn't received a review)
SELECT 
    Products.product_id,
    Products.product_name
FROM Products
LEFT JOIN Reviews ON Products.product_id = Reviews.product_id
WHERE Reviews.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Groups users' orders by date
WITH OrdersByDate AS(
    SELECT
        user_id,
        order_date,
        -- Assigns a unique row number to each order within each user's partition
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY order_date) AS row_num 
    FROM Orders
)

-- Uses the above CTE to select users that had orders in consecutive days
-- Tables: Username (u), OrdersByDate (obd/obd2)
SELECT
    obd.user_id,
    u.username
FROM OrdersByDate obd
JOIN Users u on obd.user_id = u.user_id
JOIN OrdersByDate obd2 On obd.user_id = obd2.user_id AND obd.row_num = obd2.row_num - 1
WHERE obd2.order_date - obd.order_date = 1; -- Checks if there is a date difference of 1 between order dates (consecutive days)