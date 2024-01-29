--Problem 1
/* SELECT is putting all the information of products in the sports category in a table
the data is taken FROM the table product_data
The table product_data and category_data is joined using the primary key which is category_id
Last line is taking products only related to Sports
*/
SELECT p.product_id, p.product_name, p.description, p.price, c.category_name 
FROM product_data p
JOIN category_data c ON p.category_id = c.category_id
WHERE c.category_name = 'Sports & Outdoors'
--I didn't use product_data.csv p because tabel names only use lowercase letters, numbers, and underscores

--Problem 2
/* SELECT is putting all the information about the user in a table and counting the total orders
the data is taken FROM the table user_data
The table user_data and order_data is joined using the primary key which is user_id
Last line is to aggregate the function count
*/
SELECT u.user_id, u.username, COUNT(o.order_id) AS total_orders
FROM user_data u
JOIN order_data o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username

--Problem 3
/* SELECT is putting all the information about the product in a table and getting the average rating
the data is taken FROM the table review_data and product_data
The table review_data and product_data is joined using the primary key which is product_id
*/
SELECT p.product_id, p.product_name, r.rating
FROM review_data r
JOIN product_data p ON p.product_id = r.product_id

--Problem 4
/* SELECT is putting all the information about the user in a table and getting the total amount spent
the data is taken FROM the table user_data but the total_amount if taken from the order_data
The table user_data and order_data is joined using the primary key which is user_id
The total_spent amount coloumn is put into descending order and the first 5 values are taken using LIMIT
*/
SELECT u.user_id, u.username, o.total_amount AS total_amount_spent
FROM user_data u
JOIN order_data o ON u.user_id = o.user_id
ORDER BY total_amount_spent DESC
LIMIT 5;
