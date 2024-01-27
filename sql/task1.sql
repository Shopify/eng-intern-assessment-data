-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT * FROM Products AS p
LEFT JOIN
	Categories AS c
ON
	p.category_id=c.category_id
WHERE
	c.category_name='Sports & Outdoors';
-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT o.user_id,
	   u.username,
       count(*) AS total_number_of_orders
FROM Orders AS o
JOIN
	Users AS u
ON
	o.user_id=u.user_id
GROUP BY o.user_id;
-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT p.product_id,
	   p.product_name,
       avg(r.rating) as average_rating
FROM Products as p
LEFT JOIN
	Reviews as r
ON
	p.product_id=r.review_id
GROUP BY
    p.product_id;
-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT
	u.user_id,
    u.username,
    SUM(o.total_amount) AS total_spent FROM Orders as o
LEFT JOIN
	Users AS u
ON
	u.user_id=o.user_id
GROUP BY
	u.user_id
order by
	total_spent desc
limit 5;