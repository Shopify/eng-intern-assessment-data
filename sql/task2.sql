-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH RankedProducts AS (
    -- This Common Table Expression (CTE) computes the average rating for each product and assigns a rank based on the average rating.
    SELECT 
        p.product_id,                        -- Selects the product ID from the 'products' table.
        p.product_name,                      -- Selects the product name from the 'products' table.
        AVG(r.rating) AS avg_rating,         -- Calculates the average rating for each product.
        RANK() OVER (ORDER BY AVG(r.rating) DESC) as rating_rank -- Assigns a rank to each product based on its average rating, in descending order.

    FROM 
        products p                          -- Specifies the 'products' table.
    JOIN 
        reviews r ON p.product_id = r.product_id -- Joins the 'products' table with the 'reviews' table on the product ID.

    GROUP BY 
        p.product_id, p.product_name         -- Groups the results by product ID and name to calculate average ratings.
)
-- Main query to select the highest-ranked products based on average rating.
SELECT 
    product_id,                             -- Selects the product ID from the CTE.
    product_name,                           -- Selects the product name from the CTE.
    avg_rating                              -- Selects the calculated average rating from the CTE.

FROM 
    RankedProducts                          -- Uses the results from the CTE.

WHERE 
    rating_rank = 1;                        -- Filters to include only the top-ranked products (those with the highest average rating).


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT 
    usr.id AS UserID,                    -- Selects the user's ID and renames it as UserID for clarity.
    usr.name AS UserName                 -- Selects the user's name and renames it as UserName.

FROM 
    users usr                            -- Specifies the 'users' table and aliases it as 'usr' for this query.

JOIN 
    orders ord ON usr.id = ord.user_id   -- Joins the 'orders' table (aliased as 'ord') with 'users' on the user ID.

JOIN 
    order_items ord_items                -- Joins the 'order_items' table (aliased as 'ord_items') with 'orders'.
ON 
    ord.id = ord_items.order_id          -- The join is based on the order ID.

JOIN 
    products prod                        -- Joins the 'products' table (aliased as 'prod') with 'order_items'.
ON 
    ord_items.product_id = prod.id       -- The join is based on the product ID.

GROUP BY 
    usr.id, usr.name                     -- Groups the results by user ID and name.

HAVING 
    COUNT(DISTINCT prod.category_id) =   -- The HAVING clause filters users who have ordered from each category.
    (SELECT COUNT(*) FROM categories);   -- Compares the distinct category count per user against the total number of categories.


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Retrieve products that have not received any reviews.
SELECT 
    p.product_id,       -- Selects the product ID from the 'Products' table.
    p.product_name      -- Selects the product name from the 'Products' table.
FROM 
    Products p          -- Specifies the 'Products' table.

LEFT JOIN 
    Reviews r           -- Performs a LEFT JOIN with the 'Reviews' table.
ON 
    p.product_id = r.product_id -- Joins on the product ID.

WHERE 
    r.review_id IS NULL; -- Filters to include only those products that have no matching reviews.


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
-- Retrieve users who have made consecutive orders on consecutive days.
WITH OrderedDates AS (
    SELECT 
        u.user_id,                    -- Selects the user ID from the 'Users' table.
        u.username,                   -- Selects the username from the 'Users' table.
        o.order_date,                 -- Selects the order date from the 'Orders' table.
        LAG(o.order_date) OVER (
            PARTITION BY u.user_id 
            ORDER BY o.order_date
        ) AS prev_order_date           -- Uses the LAG window function to get the date of the previous order for each user.
    FROM 
        Users u
    JOIN 
        Orders o ON u.user_id = o.user_id -- Joins the 'Users' table with the 'Orders' table on user ID.
)

SELECT DISTINCT
    user_id, 
    username
FROM 
    OrderedDates
-- Filters to include only those records where the difference between the order date and the previous order date is exactly one day.
WHERE 
    DATEDIFF(day, prev_order_date, order_date) = 1;