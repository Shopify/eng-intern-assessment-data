-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT * 
FROM Products
WHERE Products.category_id = (
    -- Retrieve the category ID of the Sports & Outdoors category
    SELECT category_id 
    FROM Categories 
    WHERE category_name = 'Sports & Outdoors'
);


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT 
    u.user_id,  
    u.username,
    COUNT(o.user_id) AS total_orders
FROM Users u
-- Left joining to ensure even users with no orders are included
LEFT JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username;


-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT 
    p.product_id,
    p.product_name,
    AVG(r.rating) AS average_rating
FROM Products p
-- Left join since, users maybe able to rate products that do not exist, depending
-- on the way the way the database is setup. We therefore assume, all products are
-- in the product database
LEFT JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name;


-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT 
    Orders.user_id,
    SUM(Orders.total_amount) AS total_amount
FROM Orders
GROUP BY Orders.user_id -- Grouping by the user ID will ensure that the average is calculated for each user
ORDER BY SUM(Orders.total_amount) DESC -- Ordering by descending order leads to the first 5 largest values
LIMIT 5;


