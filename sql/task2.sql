-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH AvgRatingOfProduct AS (
    SELECT 
        Rvw.product_id,
        Prdt.product_name,
        AVG(Rvw.rating) AS average_rating
    FROM Reviews Rvw
    JOIN Products Prdt ON Rvw.product_id = Prdt.product_id
    GROUP BY Rvw.product_id, Prdt.product_name
)
--AvgRatingOfProduct is created to calculate the average rating for each product. It joins the Reviews table with the Products table based on the product_id.
--The AVG(Rvw.rating) calculates the average rating for each product.
SELECT 
    product_id,
    product_name,
    average_rating
FROM AvgRatingOfProduct
WHERE average_rating = (SELECT MAX(average_rating) FROM AvgRatingOfProduct);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT 
    Usr.user_id,
    Usr.username
FROM Users Usr
JOIN Orders Odr ON Usr.user_id = Odr.user_id
JOIN Order_Items OdrItm ON Odr.order_id = OdrItm.order_id
JOIN Products Prdt ON OdrItm.product_id = Prdt.product_id
JOIN Categories Ctg ON Prdt.category_id = Ctg.category_id
GROUP BY Usr.user_id, Usr.username
HAVING COUNT(DISTINCT Ctg.category_id) = (SELECT COUNT(*) FROM Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT 
    Prdt.product_id,
    Prdt.product_name
FROM Products Prdt
LEFT JOIN Reviews Rvw ON Prdt.product_id = Rvw.product_id
WHERE Rvw.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
WITH ConsecutiveDayOrders AS (
    SELECT 
        user_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
    FROM Orders
)
--ConsecutiveDayOrders uses the LAG window function to fetch the previous order date.
--The PARTITION BY user_id ORDER BY order_date ensures that the LAG function operates within the scope of each user and orders the result by the order date.
SELECT DISTINCT 
    Usr.user_id,
    Usr.username
FROM Users Usr
JOIN ConsecutiveDayOrders CnsOdr ON Usr.user_id = CnsOdr.user_id
WHERE CnsOdr.order_date = CnsOdr.prev_order_date + INTERVAL '1 day';
--The condition CnsOdr.order_date = CnsOdr.prev_order_date + INTERVAL '1 day' checks if the order dates are consecutive. If the current order date is one day after the previous order date, it implies consecutive orders.
