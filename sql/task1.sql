-- Problem 1: Retrieve all products in the Sports category
SELECT p.product_id, p.product_name, p.description, p.price
FROM products AS p
JOIN categories AS c ON p.category_id = c.category_id
WHERE category_name Like '%Sports%';

-- Problem 2: Retrieve the total number of orders for each user
SELECT u.user_id, u.username, COUNT(order_id) as no_of_orders
FROM orders AS o
JOIN users AS u ON o.user_id = u.user_id
GROUP BY user_id;

-- Problem 3: Retrieve the average rating for each product
SELECT p.product_id, p.product_name, ROUND(AVG(r.rating), 2) AS average_rating
FROM reviews AS r
JOIN products AS p ON r.product_id = p.product_id
GROUP BY p.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
SELECT u.user_id, u.username, SUM(o.total_amount) AS amount_spent
FROM orders AS o
JOIN users AS u ON o.user_id = u.user_id
GROUP BY u.user_id, u.username
ORDER BY amount_spent DESC
LIMIT 5;
