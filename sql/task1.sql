-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

SELECT                                              -- Specify columns to be returned, preferred to *
    product_id, 
    product_name, 
    description,
    price
FROM Products 
    INNER JOIN Categories USING (category_id)       -- Use 'USING' to reduce clutter unless 'ON' is explicitly needed
WHERE LOWER(category_name) LIKE '%Sports%';         -- Work with input term "Sports" as is to find match

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT 
    user_id, 
    username, 
    COUNT(DISTINCT order_id) AS total_orders        -- Get count without duplicate of the same orders
FROM Users
	 LEFT JOIN Orders USING(user_id)                -- Left join so as to include users with no orders
     LEFT JOIN Order_Items USING(order_id)          -- Count will return 0 for users with no orders
GROUP BY user_id, username;                         -- Group by user to get orders by user

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

SELECT 
    product_id, 
    product_name, 
    COALESCE(AVG(rating), 0) AS average_rating      -- Group by products and use agg functions to get average rating
FROM Products                                       -- Use COALESCE to return 0 for products with no reviews
    LEFT JOIN Reviews USING (product_id)            -- Left join to only include products we have
GROUP BY product_id, product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT 
    user_id, 
    username, 
    total_amount
FROM Users 
    INNER JOIN Orders USING (user_id)              -- Inner join to only include users with orders
ORDER BY total_amount DESC                         -- Order by total amount in descending order to get top 5
LIMIT 5;