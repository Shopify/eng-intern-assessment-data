-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Select all the products in sports category which the category id is 8
SELECT p.*
FROM Products p 
JOIN Categories c ON p.category_id = c.category_id
WHERE LOWER(c.category_name) LIKE LOWER("%Sports%");

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT u.user_id, u.username, count(o.order_id) as Total_Number_of_Orders
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY o.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT p.product_id, p.product_name, AVG(r.rating) as Average_rating
FROM Products p 
INNER JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- Here is to limit 5 users, However, user_id:29 with the same number of total spending with user_id:17
-- There will be another Query if we need to include the user_id:29 into the result if we need a "fairer" result
SELECT u.user_id, u.username, SUM(o.total_amount) as Total_amount_spent
FROM Users u 
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id
ORDER BY Total_amount_spent DESC
LIMIT 5;
