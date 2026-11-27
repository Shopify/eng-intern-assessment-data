-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

Select *
From Products A
inner join Categories b 
on a.category_id = b.category_id 
where a.category_name = 'Sports and Outdoors';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

Select a.user_id, a.username, count(b.order_id) as total_orders
From Users a
Inner Join Orders b 
on a.user_id = b.user_id
group by 1,2;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

Select a.product_id, a.product_name, avg(b.rating) as average_rating
From Products a
Inner Join Reviews b
ON a.user_id = b.user_id
Group By 1,2; 

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

Select a.user_id, a.username, SUM(b.amount) As total_amount
From Users a
inner join Orders c 
on a.user_id = c.user_id
Inner join Payments b
on c.order_id = b.order_id
Group by 1,2
Order by total_amount DESC limit 5;