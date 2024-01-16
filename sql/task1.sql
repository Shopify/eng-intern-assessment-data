-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT *
FROM 
(Products LEFT JOIN Categories ON Products.category_id=Categories.category_id) 
WHERE Categories.category_name="Sports & Outdoors";

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT Users.user_id AS UserID, Users.username AS Username, 
    COUNT(Orders.order_id) AS TotalOrders
FROM
(Orders LEFT JOIN Users ON Orders.user_id=Users.user_id)
GROUP BY Users.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT Products.product_id AS ProductID, 
    Products.product_name AS ProductName, 
    AVG(Reviews.rating) AS AverageRating 
FROM
(Products LEFT JOIN Reviews ON Products.product_id=Reviews.product_id)
GROUP BY Products.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT Users.user_id AS UserID, Users.username AS Username, 
    SUM(Orders.total_amount) AS TotalSpent 
FROM
(Users LEFT JOIN Orders ON Users.user_id=Orders.user_id)
GROUP BY Users.user_id
ORDER BY TotalSpent DESC
LIMIT 5;
