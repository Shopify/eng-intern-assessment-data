-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Ans. Comments added in lines for better explanation
select p.product_id, p.product_name, avg_rating
from Products p
-- inner join Products and avg_rating from Reviews 
inner join 
    (select product_id, avg(rating) as avg_rating
     from Reviews
     group by product_id) as avg_ratings
on p.product_id = avg_ratings.product_id
-- calculate the max avg_rating and filter out avg_rating against each product with just the max avg_rating
where avg_rating = (select max(avg_rating) from (select avg(rating) as avg_rating from Reviews group by product_id) as sub);


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

select u.user_id, u.username
from Users u
-- all orders made by each user
left join Orders o on u.user_id = o.user_id
-- all items in each order 
inner join Order_Items oi on o.order_id = oi.order_id
-- get the product_id of the item in the order
inner join Products p on oi.product_id = p.product_id
-- inner join to find the category of each item in the order
inner join Categories c on p.category_id = c.category_id
group by u.user_id, u.username
-- filter out to check the number of categories for each user's order is equal to the actual number of categories in total
having count(distinct c.category_id) = (
    select count(*) from Categories
);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

select p.product_id, p.product_name
from Products p
-- left join Reviews on Products where a review doesn't exist
left join Reviews r on p.product_id = r.product_id
where r.review_id is null;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

select distinct a.user_id, u.username
-- new table with next order date using lead(), partition the data by user_id
from (select user_id, order_date, lead(order_date) over (partition by user_id order by order_date) as next_order_date
     from Orders) as a
join Users u on a.user_id = u.user_id
-- where clause to check the next order date is exactly 1 day apart
where a.next_order_date = a.order_date + INTERVAL '1' day;
