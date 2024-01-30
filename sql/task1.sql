-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
select *
from Products
where category_id = (select category_id from Categories where category_name = 'Sports & Outdoors');

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
with stat as
    (select user_id, count(order_id) as cnt
    from Orders
    group by user_id)
select u.user_id, u.username, stat.cnt
from Users u
inner join stat
on u.user_id = o.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
with rating as 
    (select product_id, AVG(rating) as rate
    from Reviews
    group by product_id)
select p.product_id, p.product_name, r.rate
from Products p
inner join rating r
on p.product_id=r.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
with spent as
    (select user_id, sum(total_amount) as amt
    from Orders
    group by user_id)
select u.user_id, u.username, s.amt
from Users u
inner join spent s
on u.user_id = s.user_id
order by s.amt desc
limit 5;
