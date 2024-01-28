-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH AvgRatings AS (
    SELECT 
        Products.product_id, 
        Products.product_name, 
        -- Calculate the average rating for each product
        AVG(Reviews.rating) AS average_rating
    FROM 
        Products
    -- Perform a LEFT JOIN with the Reviews table based on the product_id
    LEFT JOIN 
        Reviews ON Products.product_id = Reviews.product_id
    -- Group the results by product_id and product_name
	GROUP BY 
        Products.product_id, Products.product_name
)
SELECT 
    product_id, 
    product_name, 
    average_rating
FROM 
    AvgRatings   -- From the CTE defined above
WHERE 
    -- Condition to check if the average_rating is the maximum among all products
    average_rating = (SELECT MAX(average_rating) FROM AvgRatings);


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT 
    Users.user_id, 
    Users.username
FROM 
    Users
-- Perform a JOIN with the Orders table based on the user_id
JOIN 
    Orders ON Users.user_id = Orders.user_id
-- Perform another JOIN with the Order_Items table based on the order_id
JOIN 
    Order_Items ON Orders.order_id = Order_Items.order_id
-- Perform a final JOIN with the Products table based on the product_id
JOIN 
    Products ON Order_Items.product_id = Products.product_id
GROUP BY Users.user_id, Users.username
-- Filter the results to include only those users who have ordered items from all categories
HAVING 
    COUNT(DISTINCT Products.category_id) = (SELECT COUNT(DISTINCT category_id) FROM Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT
    Products.product_id,
    Products.product_name
FROM Products
-- Perform a LEFT JOIN with the Reviews table based on the product_id
LEFT JOIN Reviews ON Products.product_id = Reviews.product_id
WHERE 
    -- Filter out the products that have reviews
    Reviews.product_id IS NULL
ORDER BY Products.product_id;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
-- Define a Common Table Expression (CTE) named ConsecutiveOrders
WITH ConsecutiveOrders AS (
    SELECT
        Users.user_id,
        Users.username,
        Orders.order_date,
        -- Use LAG function to get the date of the previous order made by the same user
        LAG(Orders.order_date) OVER (PARTITION BY Users.user_id ORDER BY Orders.order_date) AS previous_order_date
    FROM
        Users
    JOIN
        Orders ON Users.user_id = Orders.user_id
)
SELECT
    user_id,
    username
FROM
    ConsecutiveOrders  -- From the CTE defined above
WHERE
    -- Condition to check if the order_date is exactly one day after the previous_order_date
    order_date = previous_order_date + INTERVAL '1 day';