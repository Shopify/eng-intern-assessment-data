--Problem 5
SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating
FROM review_data r
JOIN product_data p ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
ORDER BY average_rating DESC
LIMIT 5;
