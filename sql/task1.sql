-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT * 
FROM Products 
WHERE category_id = (
    SELECT category_id
    FROM Categories
    WHERE category_name = 'Sports & Outdoors'
);

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
WITH User_Order_Count AS (
    SELECT 
        ord.user_id, 
        COUNT(ord.user_id) AS total_orders 
    FROM 
        Orders ord 
    GROUP BY 
        ord.user_id
)
SELECT 
    usr.user_id, 
    usr.username, 
    COALESCE(uoc.total_orders, 0) AS total_orders
FROM 
    Users usr
LEFT JOIN 
    User_Order_Count uoc 
ON 
    usr.user_id = uoc.user_id
ORDER BY 
    usr.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
WITH Product_Avg_Ratings AS (
    SELECT 
        rev.product_id, 
        AVG(rev.rating) AS avg_rating 
    FROM 
        Reviews rev 
    GROUP BY 
        rev.product_id
)
SELECT 
    prd.product_id, 
    prd.product_name, 
    COALESCE(par.avg_rating, 0) AS average_rating
FROM 
    Products prd
LEFT JOIN 
    Product_Avg_Ratings par 
ON 
    prd.product_id = par.product_id
ORDER BY 
    prd.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

WITH User_Total_Spending AS (
    SELECT 
        ord.user_id, 
        SUM(ord.total_amount) AS total_spending
    FROM 
        Orders ord
    GROUP BY 
        ord.user_id
)
SELECT 
    usr.user_id, 
    usr.username, 
    COALESCE(uts.total_spending, 0) AS total_spending
FROM 
    Users usr
LEFT JOIN 
    User_Total_Spending uts 
ON 
    usr.user_id = uts.user_id
ORDER BY 
    total_spending DESC
LIMIT 5;

