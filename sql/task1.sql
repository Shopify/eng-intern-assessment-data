-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT p.*
FROM Products p
INNER JOIN Categories c ON c.category_id = p.category_id
WHERE c.category_name LIKE '%Sports%';
-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT u.user_id, u.username, COUNT(o.order_id) AS "Number of Orders"
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username;


-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT p.product_id, p.product_name, 
    CASE 
        WHEN COUNT(r.rating) > 0 
        THEN CAST(CONVERT(DECIMAL(5,2), SUM(r.rating) / COUNT(r.rating)) AS varchar)
        ELSE 'No reviews'
    END AS "Average Rating"
FROM Products p
LEFT JOIN Reviews r ON p.product_id = t.product_id
GROUP BY p.product_id, p.product_name;
-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT TOP 5 u.user_id, u.username, 
    CASE 
        WHEN COUNT(o.total_amount) > 0 
        THEN SUM(o.total_amount)
        ELSE 0.00
    END AS "Total Amount Spent"
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username
ORDER BY [Total Amount Spent] DESC;