-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
SELECT Products.product_id, product_name, AVG(rating) AS average_rating -- compute average rating per product
FROM Products 
JOIN Reviews ON Products.product_id = Reviews.product_id
GROUP BY Products.product_id
ORDER BY average_rating DESC -- sort by average rating from highest to lowest
;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT Users.user_id, Users.username
FROM Users
JOIN Orders ON Users.user_id = Orders.user_id
JOIN Order_Items ON Orders.order_id = Order_Items.order_id
JOIN Products ON Order_Items.product_id = Products.product_id
JOIN Categories ON Products.category_id = Categories.category_id
GROUP BY Users.user_id
HAVING COUNT(DISTINCT Categories.category_id) = (SELECT COUNT(DISTINCT Categories.category_id) FROM Categories) -- select only users who have ordered from all categories
;

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT Products.product_id, Products.product_name
FROM Products
LEFT JOIN Reviews ON Products.product_id = Reviews.product_id -- use LEFT JOIN to include all products even though with no review data
GROUP BY Reviews.product_id
WHERE Reviews.review_id IS NULL -- select only products that have no reviews
;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
SELECT user_id, username
FROM
(
    SELECT 
    Users.user_id, 
    Users.username, 
    Orders.order_date, 
    DATEDIFF
    (
        Orders.order_date, 
        LAG(Orders.order_date) OVER (PARTITION BY Users.user_id ORDER BY Orders.order_date) -- compute previous order date using LAG() window function
    ) AS 'days_since_last_order' -- compute date difference between current order date and previous order date
    FROM Users
    JOIN Orders ON Users.user_id = Orders.user_id
) AS subquery
GROUP BY user_id
HAVING 'days_since_last_order' = 1 -- select only users who have ordered on consecutive days (date difference = 1)
;
