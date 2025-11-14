-- Problem 5:--Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- CTE to get average rating per product
WITH ProductsAverageRated AS (
    SELECT 
        product_id, 
        AVG(rating) AS average_rating
    FROM Reviews
    GROUP BY product_id
)
-- select only whats mentioned
SELECT 
    Products.product_id, 
    Products.product_name, 
    ProductsAverageRated.average_rating
FROM Products
INNER JOIN ProductsAverageRated ON Products.product_id = ProductsAverageRated.product_id -- inner join only products with averating to them
WHERE ProductsAverageRated.average_rating = (
    SELECT MAX(average_rating) FROM ProductsAverageRated -- selct biggest
)
ORDER BY Products.product_id; -- order by product id when there is more than 1


-- Problem 6:--Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint You may need to use subqueries or joins to solve this problem.

--select only whats mentioned
SELECT 
    Users.user_id, 
    Users.username
FROM Users
INNER JOIN Orders ON Users.user_id = Orders.user_id
INNER JOIN Order_Items ON Orders.order_id = Order_Items.order_id
INNER JOIN Products ON Order_Items.product_id = Products.product_id -- join all users, orders, order_items, and products
GROUP BY Users.user_id, Users.username
-- use subquery
-- count number of distic cateegories per user's orders, then compare to total number of categories
-- no need to match category by category, just need to compare total number of distincts
HAVING COUNT(DISTINCT Products.category_id) = (
    SELECT COUNT(*) FROM Categories
);

-- Problem 7:--Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint You may need to use subqueries or left joins to solve this problem.

--only select mentioned
SELECT 
    Products.product_id, 
    Products.product_name
FROM Products
LEFT JOIN Reviews ON Products.product_id = Reviews.product_id -- left join to include all products regardless of reviews
WHERE Reviews.review_id IS NULL; -- select only the ones that show NULL


-- Problem 8:--Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint You may need to use subqueries or window functions to solve this problem.

-- use CTE
WITH OrderedUsers AS (
    SELECT 
        Users.user_id, 
        Users.username, 
        Orders.order_date,
        LAG(Orders.order_date) OVER (PARTITION BY Users.user_id ORDER BY Orders.order_date) AS prev_order_date -- use LAG() to retrieve previous row. partition by userid, based on date
        -- got to learn about LAG()!
    FROM Users
    INNER JOIN Orders ON Users.user_id = Orders.user_id -- inner join to get users only with orders
)
-- select only mentioned, and select disctinct users
SELECT DISTINCT
    user_id, 
    username
FROM OrderedUsers
WHERE order_date = prev_order_date + INTERVAL '1 day' -- filter for consecutive day orders