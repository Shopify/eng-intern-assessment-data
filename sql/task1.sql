-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
select *
from products
where category_id = 8
;

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
select 
    Users.user_id,
    Users.username,
    count(Orders.order_id) as total_num_orders
from Users
left join Orders on Users.user_id = Orders.user_id
group by 1,2
;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
select  
    Products.product_id,
    Products.product_name,
    AVG(Reviews.rating) as avg_rating
from Products 
left join Reviews on Products.product_id = Reviews.product_id
group by 1,2
;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
select 
    Users.user_id,
    Users.username,
    sum(Orders.total_amount) as total_amount_spent
from Users
left join Orders on Users.user_id = Orders.user_id
group by 1,2
order by sum(Orders.total_amount) desc
limit 5
;