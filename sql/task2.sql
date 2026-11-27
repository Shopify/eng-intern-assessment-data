-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

select p.product_id, p.product_name, average.avg_rating as Average_rating
from Products p, (select product_id, avg(rating) as avg_rating    -- subqueries that creates a temporary table that stores average rating of each product
                    from Reviews
                    group by product_id) average
where p.product_id = average.product_id and average.avg_rating >=  ALL(select avg(rating)   -- Want to find the product with highest average rating
                                                                    from Reviews
                                                                    group by product_id );

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

select u.user_id, u.username
from Users u join Orders o1 on u.user_id = o1.user_id join Order_Items o2 on o2.order_id = o1.order_id  
                join Products p on p.product_id = o2.product_id 
                join Categories c on c.category_id = p.category_id
group by u.user_id
having count(Distinct c.category_id) = (select count(*)    -- If the distinct catogeries of the products that a user purchased is the same amount of categories,   
                                        from Categories);  -- then that user made at least one order in each category
        

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

select p.product_id, p.product_name
from Products p left join Reviews r on p.product_id = r.product_id
group by p.product_id, p.product_name
having count(r.review_id) = 0;  -- if the count of reviews is 0 then that means the product have not received any reviews

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

with Find_consecutive as (   -- Temporary table to store all the user that placed orders on at least 2 days.
    select o1.user_id
    from Orders o1, Orders o2
    where o1.user_id = o2.user_id and o1.order_date = o2.order_date + INTERVAL '1 day'
    group by o1.user_id
)
select u.user_id, u.username
from Users u join Find_consecutive f on u.user_id = f.user_id;