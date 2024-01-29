--Problem 5
SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating
FROM review_data r
JOIN product_data p ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
ORDER BY average_rating DESC
LIMIT 5;

--Problem 6
SELECT u.user_id, u.username
FROM user_data u
JOIN order_data o ON u.user_id = o.user_id
JOIN order_items_data oi ON o.order_id = oi.order_id
GROUP BY u.user_id, u.username;

--Problem 7
SELECT p.product_id, p.product_name
FROM product_data p
LEFT JOIN review_data r ON p.product_id = r.product_id
WHERE r.rating IS NULL AND r.review_text IS NULL;

--Problem 8
SELECT u.user_id, u.username
FROM user_data u
JOIN order_data o1 on u.user_id = o1.user_id
JOIN order_data o2 on u.user_id = o2.user_id AND o2.order_date = DATE_ADD(o1.order_date, INTERVAL 1 DAY)
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT o1.order_id) > 1;
