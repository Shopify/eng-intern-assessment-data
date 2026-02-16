--Problem 5
--Returning a table with product id, product name and average rating of product
--Joining the product_data table and review_data table with primary key product_id
--Getting the top 5 ratings after listing it in descending order
SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating
FROM review_data r
JOIN product_data p ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
ORDER BY average_rating DESC
LIMIT 5;

--Problem 6
--Selecting id and username of users from user_data tables
--Joining the order_data table and user_data table with primary key user_id
--Second join is to join the order_items_data and order_data with their primary key order_id
--This will return users who made one purchase in each category
SELECT u.user_id, u.username
FROM user_data u
JOIN order_data o ON u.user_id = o.user_id
JOIN order_items_data oi ON o.order_id = oi.order_id
GROUP BY u.user_id, u.username;

--Problem 7
--Selecting id and name of products from product_data tables
--Joining the review_data table and product_data table with primary key product_id
--Returning product_id and name when rating and review text is null
SELECT p.product_id, p.product_name
FROM product_data p
LEFT JOIN review_data r ON p.product_id = r.product_id
WHERE r.rating IS NULL AND r.review_text IS NULL;

--Problem 8
--Selecting id and username of users from user_data tables
--Joining the order_data table and user_data table with primary key user_id
--Second join is to compare two dates from the same user_id's
--Having count makes sure the users made consecutive orders on consecutive days
SELECT u.user_id, u.username
FROM user_data u
JOIN order_data o1 on u.user_id = o1.user_id
JOIN order_data o2 on u.user_id = o2.user_id AND o2.order_date = DATE_ADD(o1.order_date, INTERVAL 1 DAY)
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT o1.order_id) > 1;
