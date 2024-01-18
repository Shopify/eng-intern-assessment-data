-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT * 
FROM Products
WHERE category_id = (SELECT category_id FROM Categories WHERE category_name = 'Sports & Outdoors');
--In the  where clause we fetch the category id of Sports & Outdoors

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT 
    Usr.user_id,
    Usr.username,
    COUNT(Odr.order_id) AS total_orders
FROM Users Usr
LEFT JOIN Orders Odr ON Usr.user_id = Odr.user_id
GROUP BY Usr.user_id, Usr.username
ORDER BY Usr.user_id;
--Order By is done to ensure the data is shown in ascending order of user_id

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT 
    Rvw.product_id,
    Prdt.product_name,
    AVG(Rvw.rating) AS average_rating
FROM Reviews Rvw
JOIN Products Prdt ON Rvw.product_id = Prdt.product_id
GROUP BY Rvw.product_id, Prdt.product_name
ORDER BY Rvw.product_id

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT 
    Usr.user_id,
    Usr.username,
    SUM(Odr.total_amount) AS total_amount_spent
FROM Users Usr
JOIN Orders Odr ON Usr.user_id = Odr.user_id
GROUP BY Usr.user_id, Usr.username
ORDER BY total_amount_spent DESC
LIMIT 5;
