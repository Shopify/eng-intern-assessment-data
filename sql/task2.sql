-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
SELECT 
    p.product_id,  -- Selecting product_id from the Products table
    p.product_name,  -- Selecting product_name from the Products table
    r.AverageRating  -- Selecting the average rating calculated in the subquery
FROM 
    Products p  -- variable 'p' is used for the Products table
    JOIN (
        SELECT 
            product_id,  -- Selecting product_id from the Reviews table
            AVG(rating) as AverageRating  -- Calculating the average rating for each product
        FROM 
            Reviews  -- This is the reviews table
        GROUP BY product_id  -- Grouping the results by product_id
    ) r ON p.product_id = r.product_id  -- Join only when product_id is matching
WHERE 
    r.AverageRating = (  -- Filtering to only include products with the highest average rating
        SELECT MAX(AverageRating)  -- Selecting the the maximum average rating
        FROM (
            SELECT AVG(rating) as AverageRating  -- Calculating the average rating for each product
            FROM Reviews  -- This is the reviews table
            GROUP BY product_id  -- Fiinally Grouping the results by product_id
        )
    )

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT 
    u.user_id,  -- Selecting user_id from the Users table
    u.username  -- Selecting username from the Users table
FROM 
    Users u  -- variable 'u' is used for the Users table
WHERE NOT EXISTS (  -- Filtering to only include users who have made at least one order in each category
    SELECT c.category_id  -- Selecting category_id from the Categories table
    FROM Categories c  -- c is the categories 
    WHERE NOT EXISTS (  -- Filtering to only include categories where the user has made at least one order
        SELECT o.order_id  -- Selecting order_id from the Orders table
        FROM 
            Orders o  -- variable 'o' is used for the Orders table
            JOIN Order_Items oi ON o.order_id = oi.order_id  -- Join only when order_id is matching
            JOIN Products p ON oi.product_id = p.product_id  -- Joining with the Products table on matching product_id
        WHERE 
            o.user_id = u.user_id AND  -- Filtering to only include orders made by the user
            p.category_id = c.category_id  -- Filtering to only include products in the categoryy
    )
)

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT 
    p.product_id,  -- Selecting product_id from the Products table
    p.product_name  -- Selecting product_name from the Products table
FROM 
    Products p  -- variable 'p' is used for the Products table
    LEFT JOIN Reviews r ON p.product_id = r.product_id  -- Using left join with the Reviews table on matching product_id
WHERE 
    r.review_id IS NULL  -- Filtering to only include products that have not received any reviews

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- This SQL query retrieves the users who have made consecutive orders on consecutive days.
-- The result includes the user ID and username.
SELECT 
    u.user_id,  -- Selecting user_id from the Users table
    u.username  -- Selecting username from the Users table
FROM 
    Users u  -- variable 'u' is used for the Users table
    JOIN (
        SELECT o1.user_id  -- Selecting user_id from the Orders table
        FROM 
            Orders o1  -- variable 'o1' is used for the Orders table
            JOIN Orders o2 ON o1.user_id = o2.user_id  -- Join only when user_id is matching
        WHERE 
            julianday(o2.order_date) - julianday(o1.order_date) = 1  -- Filtering to only include orders made on consecutive days (using the julianday helping function)
    ) o ON u.user_id = o.user_id  -- Join only when user_id is matching