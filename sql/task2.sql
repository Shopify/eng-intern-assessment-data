-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

select p.product_id, p.product_name, avg(r.rating) as rating
from Products p, Reviews r
where p.product_id = r.product_id
group by p.product_id, p.product_name
where rating = (
    select max(rating) from (
        select avg(r.rating) as rating 
        from Products p, Reviews r
        where p.product_id = r.product_id
        group by p.product_id, p.product_name
    )
);
-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

select u.user_id, u.username 
from Users u, Orders o, Order_Items oi, Products p
where u.user_id = o.user_id and o.order_id = oi.order_id and oi.product_id = p.product_id
group by u.user_id, u.username 
having count(distinct p.category_id) = (select count(*) from Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

select p.product_id, p.product_name
from Products p
where p.product_id not in (select r.product_id from Reviews r);


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

select distinct u.user_id, u.username
from Users u, Orders o1, Orders o2
where u.user_id = o1.user_id and u.user_id = o2.user_id
and o1.order_date = o2.order_date - interval 1 day; -- subtract 1 day from the date to check if it is consecutive