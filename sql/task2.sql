-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Solution 5:
-- The CTE `AverageRatings` computes the average rating for each product.
WITH AverageRatings AS (
    SELECT 
        product_id, 
        AVG(rating) AS avg_rating  
    FROM 
        Reviews
    GROUP BY 
        product_id  
),

-- The CTE `MaxAverageRating` finds the highest average rating from the `AverageRatings` CTE.
MaxAverageRating AS (
    SELECT 
        MAX(avg_rating) AS max_avg_rating 
    FROM 
        AverageRatings
)
-- The final SELECT statement joins the `Products` table with the `AverageRatings` CTE.
-- It then filters these joined results to only include products whose average rating matches the highest average rating.
SELECT 
    p.product_id, 
    p.product_name, 
    ar.avg_rating  
FROM 
    Products p
JOIN 
    AverageRatings ar ON p.product_id = ar.product_id  
JOIN 
    MaxAverageRating mar ON ar.avg_rating = mar.max_avg_rating


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Solution 6:
SELECT 
    u.user_id, 
    u.username
FROM 
    Users u
-- Joining the Orders table with the Users table.
-- This join links each user with their orders based on the user_id field.
JOIN 
    Orders o ON u.user_id = o.user_id
-- Joining the Order_Items table with the Orders table.
-- This join links each order with its items based on the order_id field.
JOIN 
    Order_Items oi ON o.order_id = oi.order_id
-- Joining the Products table with the Order_Items table.
-- This join links each order item with its corresponding product based on the product_id field.
JOIN 
    Products p ON oi.product_id = p.product_id
-- Joining the Categories table with the Products table.
-- This join links each product with its category based on the category_id field.
JOIN 
    Categories c ON p.category_id = c.category_id

-- Grouping the results by user ID and username.
-- This is necessary for the aggregate function COUNT to work correctly in the HAVING clause.
GROUP BY 
    u.user_id, u.username
-- The HAVING clause filters the grouped results.
-- It ensures that only users who have ordered products from every category are selected.
-- COUNT(DISTINCT c.category_id) counts the unique categories from which a user has ordered products.
-- (SELECT COUNT(*) FROM Categories) is a subquery that returns the total number of categories.
HAVING 
    COUNT(DISTINCT c.category_id) = (SELECT COUNT(*) FROM Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Solution 7: 
SELECT 
    p.product_id, 
    p.product_name
FROM 
    Products p
-- Performing a LEFT JOIN with the Reviews table.
-- This type of join includes all records from the Products table
-- and the matched records from the Reviews table. 
LEFT JOIN 
    Reviews r ON p.product_id = r.product_id
-- Filtering to find products without reviews.
-- The WHERE clause checks for cases where the Reviews table returns NULL,
-- which indicates that there are no reviews for the product.
WHERE 
    r.review_id IS NULL;
-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Solution 8:
SELECT DISTINCT 
    u.user_id, 
    u.username
FROM 
    Users u
-- Joining the Orders table to associate each user with their orders.
JOIN 
    Orders o ON u.user_id = o.user_id
-- Joining a subquery that uses window functions.
JOIN (
    -- This subquery selects the user ID and calculates the difference in days
    -- between each order and the previous order for the same user.
    SELECT 
        user_id, 
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
    FROM 
        Orders
) AS subq ON u.user_id = subq.user_id
-- Where condition to check for consecutive orders.
-- The DATEDIFF function calculates the difference in days between two dates.
-- We are looking for cases where this difference is exactly 1,
-- indicating orders on consecutive days.
WHERE 
    DATEDIFF(subq.order_date, subq.prev_order_date) = 1;

