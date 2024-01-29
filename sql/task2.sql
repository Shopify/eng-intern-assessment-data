-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

SELECT 
    Products.product_id, -- Selects product_id 
    Products.product_name, -- Selects product name
    Reviews.average_rating -- Selects the average rating from the subquery
FROM 
    Products
JOIN (
    SELECT 
        product_id,
        AVG(rating) AS average_rating -- Calculates average rating for each product
    FROM 
        Reviews
    GROUP BY 
        product_id
) Reviews ON Products.product_id = Reviews.product_id -- Joins the subquery with the Products table
WHERE 
    Reviews.average_rating = (
        SELECT MAX(average_rating) FROM ( -- Finds the highest average rating
            SELECT 
                product_id,
                AVG(rating) AS average_rating
            FROM 
                Reviews
            GROUP BY 
                product_id
        ) AS subquery
    );

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT 
    Users.user_id, -- Selects user_ID
    Users.username -- Selects usernames
FROM 
    Users
JOIN 
    Orders ON Users.user_id = Orders.user_id -- Joins with Orders table
JOIN 
    Order_Items ON Orders.order_id = Order_Items.order_id -- Joins with Order_Items table
JOIN 
    Products ON Order_Items.product_id = Products.product_id -- Joins with Products table
GROUP BY 
    Users.user_id, Users.username -- Groups by user_ID and username
HAVING 
    COUNT(DISTINCT Products.category_id) = (SELECT COUNT(DISTINCT category_id) FROM Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT 
    Products.product_id, -- Selects product_ID
    Products.product_name -- Selects product names
FROM 
    Products
LEFT JOIN 
    Reviews ON Products.product_id = Reviews.product_id -- Left joins with Reviews table
WHERE 
    Reviews.review_id IS NULL; -- Selects products with no matching record in Reviews

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

SELECT DISTINCT
    u1.user_id, -- Selects user_ID
    u1.username -- Selects username
FROM 
    Users u1
JOIN 
    Orders o1 ON u1.user_id = o1.user_id  -- Joins Users with Orders (first instance)
JOIN 
    Orders o2 ON u1.user_id = o2.user_id  -- Joins Users with Orders (second instance)
WHERE 
    DATEDIFF(o2.order_date, o1.order_date) = 1  -- Checks for consecutive days
    AND o1.order_id <> o2.order_id; -- Ensures different orders are compared
