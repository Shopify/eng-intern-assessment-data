-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

select p.product_id, p.product_name, AVG(r.rating) as average_rating
from Products p 
left join Reviews r on p.product_id = r.product_id
group by p.product_id, p.product_name
having average_rating = (select AVG(rating) as average_rating
                        from Reviews
                        group by product_id
                        order by average_rating desc
                        limit 1);


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

with order_data as (
    select o.*, oi.*, p.*
    from Orders o 
    left join Order_Items oi on o.order_id = oi.order_id
    left join Products p on oi.product_id = p.product_id) 

select u.user_id, u.username 
from Users u 
left join order_data od on u.user_id = od.user_id
group by u.user_id, u.username, od.category_id
having COUNT(od.category_id) = (select COUNT(category_id) from Categories);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

select product_id, product_name
from Products  
where product_id not in (select DISTINCT product_id from Reviews);


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.


with PrevOrders as (
    select user_id, order_date, LAG(order_date) over (partition by user_id order by order_date) as prev_order_date
    from Orders
)

select DISTINCT o.user_id, u.username
from PrevOrders o 
left join Users u on o.user_id = u.user_id
where DATEDIFF(o.order_data, o.prev_order_date) = 1;

