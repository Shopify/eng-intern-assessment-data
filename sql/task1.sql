-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Select all details from the 'Products' table for items in the 'Sports & Outdoors' category.
SELECT 
    prod_details.*   -- Selects all columns from the 'Products' table, renamed as 'prod_details' in this query.

FROM 
    Products AS prod_details  -- Specifies the 'Products' table and renames it as 'prod_details' for this query.

INNER JOIN 
    Categories AS cat_details  -- Performs an INNER JOIN with the 'Categories' table, renamed as 'cat_details'.
ON 
    prod_details.category_id = cat_details.category_id  -- Joins 'Products' and 'Categories' on their shared 'category_id' column.

WHERE 
    cat_details.category_name = 'Sports & Outdoors';  -- Filters the results to only include products in the 'Sports & Outdoors' category.

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- Select the user ID and username from the 'Users' table, and count the number of orders for each user from the 'Orders' table.
SELECT 
    user_data.user_id,     -- Selects the user ID from the Users table.
    user_data.username,    -- Selects the username from the Users table.
    COUNT(order_data.order_id) AS order_count  -- Counts the number of orders for each user, labeled as 'order_count'.

FROM 
    Users AS user_data     -- Specifies the 'Users' table and renames it as 'user_data' for this query.

LEFT JOIN 
    Orders AS order_data   -- Performs a LEFT JOIN with the 'Orders' table, renamed as 'order_data'.
ON 
    user_data.user_id = order_data.user_id  -- Joins the two tables on the user ID, including all users even if they have no orders.

GROUP BY 
    user_data.user_id, user_data.username;  -- Groups the results by user ID and username, ensuring the order count is calculated per user.

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- Retrieve each product's unique identifier, name, and compute its average review rating.
SELECT
    ProductTbl.id AS ProductID,                  -- Product ID from 'Products' table
    ProductTbl.name AS ProductName,              -- Product Name from 'Products' table
    AVG(ReviewTbl.star_rating) AS AvgRating      -- Average star rating for each product

FROM
    Products AS ProductTbl                       -- 'Products' table aliased as 'ProductTbl'

LEFT JOIN
    Reviews AS ReviewTbl                         -- 'Reviews' table aliased as 'ReviewTbl'
ON
    ProductTbl.id = ReviewTbl.product_id         -- Join condition based on product ID

GROUP BY
    ProductTbl.id;                               -- Grouping by product ID to calculate average

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

WITH UserSpending AS (
    -- This CTE calculates the total spending per user
    SELECT 
        u.user_id,                   -- Selects the user ID from the 'Users' table
        u.username,                  -- Selects the username from the 'Users' table
        SUM(o.amount) AS total_spent -- Sums the total amount spent in orders for each user
    FROM 
        Users u                      -- Specifies the 'Users' table
    INNER JOIN 
        Orders o                     -- Joins with the 'Orders' table
    ON 
        u.user_id = o.user_id        -- The join condition is based on the user ID
    GROUP BY 
        u.user_id, u.username        -- Groups the results by user ID and username
)
-- Main query to select from the CTE
SELECT TOP 5 
    user_id, 
    username, 
    total_spent
FROM 
    UserSpending
ORDER BY 
    total_spent DESC; -- Orders the results by total spent in descending order, to get the top spenders