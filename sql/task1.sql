-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

SELECT 
    * -- Selects everything
FROM 
    product_data -- From the product_data table
JOIN 
    category_data ON product_data.category_id = category_data.category_id -- Joins the category_data table
WHERE 
    category_data.category_name = "Sports & Outdoors"; -- Filters products in the "Sports & Outdoors" category

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT 
    user_data.user_id, -- Selects user_id
    user_data.username, -- Selects username
    count(order_data.order_id) -- Counts the number of orders per user
FROM 
    user_data -- From the user_data table
LEFT JOIN 
    order_data ON user_data.user_id = order_data.user_id -- Left joins the order_data table
GROUP BY 
    user_data.user_id, user_data.username -- Groups results by user_id and username

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

SELECT 
    product_data.product_id, -- Selects product_id
    product_data.product_name, -- Selects product_name
    AVG(review_data.rating) -- Calculates the average rating per product
FROM 
    product_data -- From the product_data table
LEFT JOIN 
    review_data ON product_data.product_id = review_data.product_id -- Left joins the review_data table
GROUP BY 
    product_data.product_id, product_data.product_name; -- Groups results by product_id and product_name

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT 
    user_data.user_id, -- Selects user_id
    user_data.username, -- Selects username
    SUM(order_data.total_amount) -- Sums the total amount spent on orders per user
FROM 
    user_data -- From the user_data table
JOIN 
    order_data ON user_data.user_id = order_data.user_id  -- Joins with the order_data table
GROUP BY 
    user_data.user_id, user_data.username -- Groups results by user_id and username
ORDER BY 
    SUM(order_data.total_amount) DESC -- Orders by the total amount spent in descending order
LIMIT 5; -- Limits the result to the top 5 users
