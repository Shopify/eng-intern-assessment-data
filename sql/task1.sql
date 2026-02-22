-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

SELECT 
    * -- Selects everything
FROM 
    Products
JOIN 
    Categories ON Products.category_id = Categories.category_id -- Joins the Categories table
WHERE 
    Categories.category_name = "Sports & Outdoors"; -- Filters products in the "Sports & Outdoors" category

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT 
    Users.user_id, -- Selects user_id
    Users.username, -- Selects username
    count(Orders.order_id) -- Counts the number of orders per user
FROM 
    Users
LEFT JOIN 
    Orders ON Users.user_id = Orders.user_id -- Left joins the order_data table
GROUP BY 
    Users.user_id, Users.username -- Groups results by user_id and username

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

SELECT 
    Products.product_id, -- Selects product_id
    Products.product_name, -- Selects product_name
    AVG(Reviews.rating) -- Calculates the average rating per product
FROM 
    Products
LEFT JOIN 
    Reviews ON Products.product_id = Reviews.product_id -- Left joins the Reviews table
GROUP BY 
    Products.product_id, Products.product_name; -- Groups results by product_id and product_name

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT 
    Users.user_id, -- Selects user_id
    Users.username, -- Selects username
    SUM(Orders.total_amount) -- Sums the total amount spent on orders per user
FROM 
    Users
JOIN 
    Orders ON Users.user_id = Orders.user_id  -- Joins with the Orders table
GROUP BY 
    Users.user_id, Users.username -- Groups results by user_id and username
ORDER BY 
    SUM(Orders.total_amount) DESC -- Orders by the total amount spent in descending order
LIMIT 5; -- Limits the result to the top 5 users
