//KAMELIN PAJANG
-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT 
    Products.product_id,
    Products.product_name,
    Products.description,
    Products.price,
    Products.category_id
FROM 
    Products
JOIN 
    Categories ON Products.category_id = Categories.category_id
WHERE 
    Categories.category_name = 'Sports & Outdoors';


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT 
    U.user_id, 
    U.username, 
    COUNT(O.order_id) AS total_orders
FROM 
    Users U
LEFT JOIN 
    Orders O ON U.user_id = O.user_id
GROUP BY 
    U.user_id, U.username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT 
    P.product_id, 
    P.product_name, 
    AVG(R.rating) AS average_rating
FROM 
    Products P
LEFT JOIN 
    Reviews R ON P.product_id = R.product_id
GROUP BY 
    P.product_id, P.product_name;



-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT 
    U.user_id,
    U.username,
    SUM(O.total_amount) AS total_spent
FROM 
    Users U
JOIN 
    Orders O ON U.user_id = O.user_id
GROUP BY 
    U.user_id, U.username
ORDER BY 
    total_spent DESC
LIMIT 5;

