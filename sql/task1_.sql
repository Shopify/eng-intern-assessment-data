--Problem 1
SELECT p.product_id, p.product_name, p.description, p.price, c.category_name
FROM product_data p
JOIN category_data c ON p.category_id = c.category_id
WHERE c.category_name = 'Sports & Outdoors'
--I didn't use product_data.csv p because tabel names only use lowercase letters, numbers, and underscores

--Problem 2
SELECT u.user_id, u.username, COUNT(o.order_id) AS total_orders
FROM user_data u
JOIN order_data o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username

--Problem 3
SELECT p.product_id, p.product_name, r.rating
FROM review_data r
JOIN product_data p ON p.product_id = r.product_id
