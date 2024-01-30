-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.



-- Query to Calculate Average Rating for Each Product
-- This query calculates the average rating for each product by joining the 'Products' table with the 'Reviews' table using a LEFT JOIN.
-- It groups the results by product_id and product_name and calculates the average rating as 'average_rating' using the AVG() function.
-- The HAVING clause filters the results to include only products with the highest average rating, which is determined by a subquery.
SELECT product_id, product_name, AVG(Ratings.rating) as average_rating
FROM Products
LEFT JOIN Reviews ON Products.product_id = Reviews.product_id
GROUP BY Products.product_id, Products.product_name
HAVING average_rating = 
    (SELECT AVG(rating) AS average_rating
    FROM Reviews
    GROUP BY product_id
    ORDER BY average_rating DESC
    LIMIT 1);

-- Query to Find Users Who Have Ordered All Categories
-- This query retrieves user_id and username from the 'Users' table for users who have ordered at least one product from each category.
-- It uses NOT EXISTS subqueries to check if there are no categories that a user has not ordered from.
SELECT user_id, username
FROM Users
WHERE NOT EXISTS (
    SELECT category_id
    FROM Categories
    WHERE NOT EXISTS (
        SELECT 1
        FROM Orders
        JOIN Order_Items ON Orders.order_id = Order_Items.order_id
        JOIN Products ON Order_Items.product_id = Products.product_id
        WHERE Products.category_id = Categories.category_id AND Orders.user_id = Users.user_id
    )
);

-- Query to Retrieve Products with No Reviews
-- This query selects product_id and product_name from the 'Products' table for products that have no associated reviews.
-- It uses a subquery with the NOT IN clause to filter out products that have at least one review.
SELECT product_id, product_name
FROM Products  
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM Reviews);

-- Query to Find Users Who Placed Orders One Day Apart
-- This query retrieves distinct user_id and username pairs from the 'Users' table.
-- It joins the 'Users' table with the 'Orders' table twice (as o1 and o2) to find users who placed orders one day apart.
-- The ABS(DATEDIFF()) function calculates the absolute difference in days between the order dates from the two joined tables.
-- Users with orders placed one day apart are included in the results.
SELECT DISTINCT Users.user_id, Users.username
FROM Users
JOIN Orders o1 ON Users.user_id = o1.user_id
JOIN Orders o2 ON Users.user_id = o2.user_id
WHERE ABS(DATEDIFF(o1.order_date, o2.order_date)) = 1;
