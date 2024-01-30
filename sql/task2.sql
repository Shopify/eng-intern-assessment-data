-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH AverageRating AS (
    SELECT product_id, avg(rating) as average
    FROM Reviews
    GROUP BY product_id
)
SELECT Products.product_id, product_name, average
FROM Products JOIN AverageRating ON Products.product_id = AverageRating.product_id
WHERE average >= ALL (SELECT average FROM AverageRating);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
WITH OrderItemInfo AS (
    SELECT user_id, category_id
    FROM Orders 
        JOIN Order_Items ON Orders.order_id = Order_Items.order_id 
        JOIN Products ON Order_Items.product_id = Products.product_id
    GROUP BY user_id, category_id
    HAVING count(DISTINCT category_id) = (SELECT count(DISTINCT category_id) FROM Categories) 
)
SELECT user_id, username
FROM Users
WHERE user_id in (SELECT user_id FROM OrderItemInfo);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
WITH HaveReview AS (
    (SELECT product_id FROM Products)
    EXCEPT
    (SELECT product_id FROM Reviews ) 
)
SELECT product_id, product_name
FROM Products 
WHERE product_id in (SELECT product_id FROM HaveReview);


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
WITH ConsecutiveOrder As (
    SELECT user_id, order_date, LAG(order_date) OVER (PARTITION BY user_id Order by order_date) AS prev_order_date
    FROM Orders
)
SELECT DISTINCT user_id, username
FROM Users JOIN ConsecutiveOrder c ON c.user_id = Users.user_id
WHERE DATE(c.order_date) = DATE(c.prev_order_date) + INTERVAL '1 DAY';