/*
Problem 1: Retrieve all products in the Sports category
This query fetches all products belonging to a category that includes the word "Sports" in its name.
The output includes the product ID and product name.
*/

SELECT 
    p.product_id,
    p.product_name
FROM 
   products p
-- Joining products with categories on category ID   
JOIN 
   categories c ON p.category_id = c.category_id
-- Filtering for categories that include 'Sports' in their name   
WHERE 
    c.category_name Like '%Sports%';

/*
Problem 2: Retrieve the total number of orders for each user
This query calculates the total number of orders placed by each user.
The output includes the user ID, username, and the total number of orders.
*/

SELECT 
    u.user_id,
    u.username,
	-- Counting the total number of orders for each user
    COUNT(o.order_id) AS total_number_of_orders
FROM 
   users u
-- Performing a left join to include users who may not have any orders   
LEFT JOIN 
   orders o ON u.user_id = o.user_id
GROUP BY 
    u.user_id,
    u.username;


/*
Problem 3: Retrieve the average rating for each product
This query calculates the average rating for each product.
The output includes the product ID, product name, and the calculated average rating.
*/

SELECT 
    p.product_id,
    p.product_name,
	-- Calculating the average rating for each product and rounding it to 2 decimal places
    ROUND(AVG(r.rating), 2) AS average_rating
FROM 
    products p
-- Performing a left join with the reviews table to include products that might not have any reviews	
LEFT JOIN 
    reviews r ON p.product_id = r.product_id
GROUP BY 
    p.product_id,
    p.product_name
ORDER BY 
    product_id ASC;


/*
Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
This query identifies the top 5 users based on the total amount they have spent on orders.
The result includes the user ID, username, and the total amount spent.
*/

SELECT 
    u.user_id,
    u.username,
	-- Calculating the total amount spent by each user
    SUM(o.total_amount) AS total_amount_spent
FROM 
    users u
-- Joining the orders table to the users table on user ID to relate orders to specific users	
JOIN 
    orders o ON u.user_id = o.user_id
GROUP BY 
    u.user_id,
    u.username
ORDER BY 
    total_amount_spent DESC
LIMIT 5;
