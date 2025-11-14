-- Hello Shopify Hiring Team! Thank you so much for taking the time out of your day to look
-- at my code. I hope it exceeds your expectations! 

-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

SELECT 
    p.product_id, 
    p.product_name, 
    p.description, 
    p.price
FROM Products p
JOIN Categories c ON p.category_id = c.category_id  -- We only need the intersection
WHERE c.category_name LIKE 'Sports%';
-- Using LIKE here because of the specific question wording.
-- Since the Sports & Outdoors category starts with Sports, it is valid to put the suffix at the end 

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT 
    u.user_id, 
    u.username, 
    COUNT(o.order_id) AS total_orders
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.user_id -- LEFT JOIN  considers the case where User has 0 orders
GROUP BY u.user_id, u.username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

SELECT 
    r.product_id, 
    p.product_name, 
    AVG(r.rating) AS average_rating -- calculating average
FROM Reviews r
RIGHT JOIN Products p ON r.product_id = p.product_id -- RIGHT JOIN considers the case where a product does not have ratings
GROUP BY r.product_id, p.product_name;


-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- The approach to this query was to SUM the total cost of each Order, and then sort in descending order

SELECT 
    o.user_id, 
    u.username, 
    SUM(o.total_amount) AS total_spent -- Total spent by each user
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY o.user_id, u.username
ORDER BY total_spent DESC -- Sorting by descending order
LIMIT 5; -- Taking the top 5