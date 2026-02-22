-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT p.product_id, p.product_name  -- Select product_id and product_name from the Products table
FROM 
    Products p  -- A variable 'p' is used for the Products table
    JOIN Categories c  -- Joining with the categories, variable 'c' is used
    ON p.category_id = c.category_id  -- only join where category_id matches
WHERE 
    c.category_name = 'Sports & Outdoors'  -- filtering only 'Sports & Outdoors' category




-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT 
    u.user_id,  -- Selecting user_id from  Users table
    u.username,  -- Selecting username from the Users table
    COUNT(o.order_id) as TotalOrders  -- counting the total number of orders for each user
FROM 
    Users u  -- variable 'u' is used for the Users table
    JOIN Orders o  -- Joining with the Orders table, variable 'o' is used
    ON u.user_id = o.user_id  -- Join only when user_id is matching
GROUP BY u.user_id  -- Finally grouping the results by user_id





-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT 
    p.product_id,  -- Selecting product_id from the Products table
    p.product_name,  -- Selecting product_name from the Products table
    AVG(r.rating) as AverageRating  -- Calculating the average rating for each product
FROM 
    Products p  -- variable 'p' is used for the Products table
    JOIN Reviews r  -- Joining with the Reviews table, variable 'r' is used
    ON p.product_id = r.product_id  -- Join only when product_id is matching
GROUP BY p.product_id  -- Finally grouping the results by product_id






-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT 
    u.user_id,  -- Selecting user_id from the Users table
    u.username,  -- Selecting username from the Users table
    SUM(o.total_amount) as TotalSpent  -- Calculating the total amount spent by each user
FROM 
    Users u  -- variable 'u' is used for the Users table
    JOIN Orders o  -- Joining with the Orders table, variable 'o' is used
    ON u.user_id = o.user_id  -- Join only when user_id is matching
GROUP BY u.user_id  -- Grouping the results by user_id
ORDER BY TotalSpent DESC  -- Ordering the results by total amount spent in descending order
LIMIT 5  --  Finaly limiting the results to the top (5) users
