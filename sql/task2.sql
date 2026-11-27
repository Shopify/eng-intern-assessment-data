-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH AverageRatings AS (
    SELECT product_id, AVG(rating) AS average_rating
    FROM Reviews
    GROUP BY product_id
)
SELECT Products.product_id, Products.product_name, AverageRatings.average_rating
FROM Products
JOIN AverageRatings ON Products.product_id = AverageRatings.product_id
WHERE AverageRatings.average_rating = (
    SELECT MAX(average_rating)
    FROM AverageRatings
);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT Users.user_id, Users.username
FROM Users
WHERE NOT EXISTS (
    SELECT Categories.category_id
    FROM Categories
    WHERE NOT EXISTS (
        SELECT Orders.order_id
        FROM Orders
        JOIN Order_Items ON Orders.order_id = Order_Items.order_id
        JOIN Products ON Order_Items.product_id = Products.product_id
        WHERE Orders.user_id = Users.user_id AND Products.category_id = Categories.category_id
    )
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
WITH OrderedUsers AS (
    SELECT 
        user_id, 
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS previous_order_date
    FROM Orders
)
SELECT DISTINCT Users.user_id, Users.username
FROM Users
JOIN OrderedUsers ON Users.user_id = OrderedUsers.user_id
WHERE DATEDIFF(day, OrderedUsers.previous_order_date, OrderedUsers.order_date) = 1;
