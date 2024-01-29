--Problem 9
SELECT c.category_id, c.category_name, SUM(odi.quantity * odi.unit_price) AS total_sales_amount
FROM category_data c
JOIN product_data p ON c.category_id = p.category_id
JOIN order_items_data odi ON p.product_id = odi.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;

--Problem 10


--Problem 11


--Problem 12
--Selecting id and username of users from user_data tables
--Joining the order_data table and user_data table with primary key user_id
--Second join is to check the second day of buying a product from the same user_id
--Third join is to check the third day of buying a product from the same user_id
--Having count makes sure the users made consecutive orders on consecutive 3 days
SELECT u.user_id, u.username
FROM user_data u
JOIN order_data o1 on u.user_id = o1.user_id
JOIN order_data o2 on u.user_id = o2.user_id AND o2.order_date = DATE_ADD(o1.order_date, INTERVAL 1 DAY)
JOIN order_data o3 on u.user_id = o3.user_id AND o3.order_date = DATE_ADD(o1.order_date, INTERVAL 2 DAY)
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT o1.order_id) > 2;
