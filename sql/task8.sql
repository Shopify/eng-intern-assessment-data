-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH OrderedUsers AS (
  SELECT
    U.user_id,
    U.username,
    O.order_date,
    LAG(O.order_date) OVER (PARTITION BY U.user_id ORDER BY O.order_date) AS prev_order_date
  FROM
    Orders O
    JOIN Users U ON O.user_id = U.user_id
)

SELECT DISTINCT
  user_id,
  username
FROM
  OrderedUsers
WHERE
  order_date = DATE_ADD(prev_order_date, INTERVAL 1 DAY);
