-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Use CTE to get average rating for each product
-- Join Product and AverageRating to match each product to its average rating
-- Order results by DESC rating and limit to 5 results to only return top 5 highest ratings
WITH AverageRatings AS (
    SELECT product_id, AVG(rating) AS Average_Rating
    FROM Reviews
    GROUP BY product_id
)
SELECT Products.product_id, Products.product_name, AverageRatings.Average_Rating AS Average_Product_Rating
FROM Products
JOIN AverageRatings 
ON Products.product_id = AverageRatings.product_id
ORDER BY AverageRatings.Average_Rating DESC
LIMIT 5;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- HAVING clause used to check if number of distinct categories user has ordered from equals the total number of categories
SELECT Users.user_id, Users.username
FROM Users
JOIN Orders ON Users.user_id = Orders.user_id
JOIN Order_Items ON Orders.order_id = Order_Items.order_id
JOIN Products ON Order_Items.product_id = Products.product_id
JOIN Categories ON Products.category_id = Categories.category_id
GROUP BY Users.user_id, Users.username, Categories.category_id
HAVING COUNT(DISTINCT Categories.category_id) = (SELECT COUNT(*) FROM Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.


-- Left join to match products to reviews while still returning products that do not have any reviews
-- review_id field will be null for products with no reviews, so return such products
SELECT Products.product_id, Products.product_name
FROM Products
LEFT JOIN Reviews 
ON Products.product_id = Reviews.product_id
WHERE Reviews.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- CTE OrderDates gets the order_Date and 
-- LAG window function used to get previous order date for each user
-- DATEDIFF function used to check if the date difference is one day, indicating a consecutive order
WITH OrderDates AS (
    SELECT
        user_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS previous_order_date
    FROM Orders
)
SELECT DISTINCT Users.user_id, Users.username
FROM Users
JOIN OrderDates
ON Users.user_id = OrderDates.user_id
WHERE DATEDIFF(OrderDates.order_date, OrderDates.previous_order_date) = 1 