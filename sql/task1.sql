-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- My thought process is to use a join to match the products to their respective category names. Specifically, since the category name is 'Sports & Outdoors', not
-- 'Sports', we need to match to 'Sports & Outdoors'.
SELECT p.product_id,p.product_name,p.description,p.price
FROM Products p
INNER JOIN
    Categories c ON p.category_id = c.category_id
WHERE 
    c.category_name = 'Sports & Outdoors';
-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- Similarly to the last question, we can use a join to match the orders with their respective users.
-- We then get the count of orders for each user (order_id) and return the user_id, username and the total number of orders
SELECT u.user_id, u.username, COUNT(o.order_id) AS total_num_of_orders
FROM Users u
LEFT JOIN -- we use left join to ensure we don't miss any users with no orders
    Orders o ON u.user_id = o.user_id
GROUP BY
    u.user_id, u.username;
-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- In this question, I also used another join, to get the products and their respective reviews, and then using the AVG function to get the average
SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating
FROM Products p
LEFT JOIN
    Reviews r ON p.product_id = r.product_id -- we use left join to ensure we don't miss any products with no reviews
GROUP BY
    p.product_id, p.product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- We can use a join to match the orders with their respective users and then group by user_id and username, and use the SUM function to get the total amount spent
-- on orders. We also need to order by descending to get the top orders, and limit it to the top 5.
SELECT u.user_id, u.username, SUM(o.total_amount) AS total_spent_on_orders -- calculate total amount spent by each user
FROM Users u
JOIN
    Orders o ON u.user_id = o.user_id 
GROUP BY
    u.user_id, u.username
ORDER BY
    total_spent_on_orders DESC -- descending order
LIMIT 5; -- only show top 5