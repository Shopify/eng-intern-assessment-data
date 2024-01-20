-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- This query retrieves products with the highest average rating.
-- It involves a subquery to find the maximum average rating and then selects products matching this rating.
SELECT 
    Products.product_id,
    Products.product_name,
    AVG(Reviews.rating) AS Average_Rating
FROM 
    Products 
LEFT JOIN 
    Reviews ON Products.product_id = Reviews.product_id
GROUP BY 
    Products.product_id,
    Products.product_name
HAVING 
    AVG(Reviews.rating) = (
        SELECT MAX(AvgRating) FROM (
            SELECT 
                AVG(rating) AS AvgRating
            FROM 
                Reviews
            GROUP BY 
                product_id
        ) AS SubQuery
    );

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- This query selects users who have made at least one order in each product category.
-- It compares the count of distinct categories in orders against the total number of categories.
SELECT 
    Users.user_id,
    Users.username
FROM 
    Users
JOIN 
    Orders ON Users.user_id = Orders.user_id
JOIN 
    Order_Items ON Orders.order_id = Order_Items.order_id
JOIN 
    Products ON Order_Items.product_id = Products.product_id
GROUP BY 
    Users.user_id,
    Users.username
HAVING 
    COUNT(DISTINCT Products.category_id) = (
        SELECT 
            COUNT(DISTINCT category_id) 
        FROM 
            Categories
    );

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- This query uses a subquery in the WHERE clause to identify products that do not appear in the Reviews table.
-- The subquery SELECTs product_id from Reviews, and the main query fetches product_id and product_name
-- from the Products table where the product_id is not in the list obtained from the subquery.
SELECT 
    Products.product_id,
    Products.product_name
FROM 
    Products
WHERE 
    Products.product_id NOT IN (SELECT Reviews.product_id FROM Reviews);

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- This query identifies users who have placed orders on consecutive days using a self-join on the Orders table.
SELECT DISTINCT
    usr.user_id,
    usr.username
FROM 
    Orders ord1
JOIN 
    Orders ord2 ON ord1.user_id = ord2.user_id AND ord2.order_date = DATEADD(day, 1, ord1.order_date)
JOIN 
    Users usr ON ord1.user_id = usr.user_id;