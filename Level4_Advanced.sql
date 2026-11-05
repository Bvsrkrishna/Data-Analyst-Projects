-- =====================================================================
-- LEVEL 4 - ADVANCED SQL: LeetCode (MySQL), DataLemur (PostgreSQL), SQLZoo (MySQL)
-- Format:  Q = question, A = answer
-- =====================================================================

-- ############################ PART A: LEETCODE (MySQL) ############################
-- Q1. Employees Earning More Than Their Managers.
SELECT e.name AS Employee FROM Employee e JOIN Employee m ON e.managerId = m.id
WHERE e.salary > m.salary;

-- Q2. Second Highest Salary (NULL if it does not exist).
SELECT (SELECT DISTINCT salary FROM Employee ORDER BY salary DESC LIMIT 1 OFFSET 1) AS SecondHighestSalary;

-- Q3. Customers Who Never Order.
SELECT name AS Customers FROM Customers WHERE id NOT IN (SELECT customerId FROM Orders);

-- Q4. Duplicate Emails.
SELECT email AS Email FROM Person GROUP BY email HAVING COUNT(*) > 1;

-- Q5. Rising Temperature: ids of days warmer than the previous day.
SELECT w1.id FROM Weather w1 JOIN Weather w2 ON DATEDIFF(w1.recordDate, w2.recordDate) = 1
WHERE w1.temperature > w2.temperature;

-- Q6. Department Top Three Salaries (top 3 unique salaries per department).
SELECT d.name AS Department, e.name AS Employee, e.salary AS Salary
FROM (SELECT *, DENSE_RANK() OVER (PARTITION BY departmentId ORDER BY salary DESC) AS rnk FROM Employee) e
JOIN Department d ON e.departmentId = d.id
WHERE e.rnk <= 3;

-- Q7. Nth Highest Salary (function; returns NULL if there is no Nth).
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  SET N = N - 1;
  RETURN (SELECT DISTINCT salary FROM Employee ORDER BY salary DESC LIMIT 1 OFFSET N);
END;

-- Q8. Department Highest Salary (ties included).
SELECT d.name AS Department, e.name AS Employee, e.salary AS Salary
FROM Employee e JOIN Department d ON e.departmentId = d.id
WHERE (e.departmentId, e.salary) IN (SELECT departmentId, MAX(salary) FROM Employee GROUP BY departmentId);

-- Q9. Rank Scores (dense ranking, highest first).
SELECT score, DENSE_RANK() OVER (ORDER BY score DESC) AS `rank` FROM Scores;

-- Q10. Not Boring Movies: odd id, description not 'boring', highest rating first.
SELECT * FROM Cinema WHERE id % 2 = 1 AND description <> 'boring' ORDER BY rating DESC;

-- Q11. Exchange Seats: swap every two consecutive students; last odd seat stays.
SELECT CASE WHEN id % 2 = 1 AND id = (SELECT MAX(id) FROM Seat) THEN id
            WHEN id % 2 = 1 THEN id + 1
            ELSE id - 1 END AS id,
       student
FROM Seat ORDER BY id;

-- Q12. Consecutive Numbers: numbers that appear at least three times in a row.
SELECT DISTINCT num AS ConsecutiveNums FROM (
  SELECT num,
         LAG(num, 1) OVER (ORDER BY id) AS p1,
         LAG(num, 2) OVER (ORDER BY id) AS p2
  FROM Logs) t
WHERE num = p1 AND num = p2;

-- Q13. Human Traffic of Stadium: 3+ consecutive ids each with 100+ people.
WITH t AS (
  SELECT *, id - ROW_NUMBER() OVER (ORDER BY id) AS grp FROM Stadium WHERE people >= 100)
SELECT id, visit_date, people FROM t
WHERE grp IN (SELECT grp FROM t GROUP BY grp HAVING COUNT(*) >= 3)
ORDER BY visit_date;

-- Q14. Trips and Users: daily cancellation rate for unbanned users, 2013-10-01 to 2013-10-03.
SELECT t.request_at AS Day,
       ROUND(SUM(CASE WHEN t.status <> 'completed' THEN 1 ELSE 0 END) / COUNT(*), 2) AS `Cancellation Rate`
FROM Trips t
JOIN Users c ON t.client_id = c.users_id AND c.banned = 'No'
JOIN Users d ON t.driver_id = d.users_id AND d.banned = 'No'
WHERE t.request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY t.request_at;

-- Q15. Capital Gain/Loss: net gain or loss per stock.
SELECT stock_name,
       SUM(CASE WHEN operation = 'Buy' THEN -price ELSE price END) AS capital_gain_loss
FROM Stocks GROUP BY stock_name;

-- Q16. Market Analysis I: each user's join date and number of orders placed in 2019.
SELECT u.user_id AS buyer_id, u.join_date, COUNT(o.order_id) AS orders_in_2019
FROM Users u LEFT JOIN Orders o ON u.user_id = o.buyer_id AND YEAR(o.order_date) = 2019
GROUP BY u.user_id, u.join_date;

-- Q17. Tree Node: label each node Root, Inner or Leaf.
SELECT id,
       CASE WHEN p_id IS NULL THEN 'Root'
            WHEN id IN (SELECT p_id FROM Tree WHERE p_id IS NOT NULL) THEN 'Inner'
            ELSE 'Leaf' END AS type
FROM Tree;

-- ############################ PART B: SQLZOO (MySQL) ############################
-- Q18. Richer Than UK: European countries with GDP per capita above the UK's.
SELECT name FROM world
WHERE continent = 'Europe'
  AND gdp / population > (SELECT gdp / population FROM world WHERE name = 'United Kingdom');

-- Q19. Bigger Than Every Country In Europe (by GDP).
SELECT name FROM world
WHERE gdp > ALL (SELECT gdp FROM world WHERE continent = 'Europe' AND gdp > 0);

-- Q20. Neighbours of Argentina and Australia: countries on the same continents, alphabetical.
SELECT name, continent FROM world
WHERE continent IN (SELECT continent FROM world WHERE name IN ('Argentina', 'Australia'))
ORDER BY name;

-- Q21. Teams that have coach Fernando Santos (team names).
SELECT teamname FROM eteam WHERE coach = 'Fernando Santos';
-- Q21 (variant). Dates of matches where Fernando Santos coached team1.
SELECT game.mdate, eteam.teamname FROM game JOIN eteam ON game.team1 = eteam.id
WHERE eteam.coach = 'Fernando Santos';

-- Q22. Busy years for John Travolta: the year(s) with the most movies and the count.
SELECT yr, COUNT(title) FROM movie
JOIN casting ON movie.id = movieid JOIN actor ON actorid = actor.id
WHERE name = 'John Travolta'
GROUP BY yr
HAVING COUNT(title) = (SELECT MAX(c) FROM (
    SELECT COUNT(title) AS c FROM movie
    JOIN casting ON movie.id = movieid JOIN actor ON actorid = actor.id
    WHERE name = 'John Travolta' GROUP BY yr) AS t);

-- ############################ PART C: DATALEMUR (PostgreSQL) ############################
-- Q23. Average Review Ratings: average stars per product per month.
SELECT EXTRACT(MONTH FROM submit_date) AS mth, product_id, ROUND(AVG(stars), 2) AS avg_stars
FROM reviews GROUP BY EXTRACT(MONTH FROM submit_date), product_id ORDER BY mth, product_id;

-- Q24. Data Science Skills: candidates having Python, Tableau and PostgreSQL.
SELECT candidate_id FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id HAVING COUNT(skill) = 3 ORDER BY candidate_id;

-- Q25. Odd and Even Measurements: per day, sum of odd-numbered and even-numbered measurements.
WITH ranked AS (
  SELECT measurement_time::date AS measurement_day, measurement_value,
         ROW_NUMBER() OVER (PARTITION BY measurement_time::date ORDER BY measurement_time) AS rn
  FROM measurements)
SELECT measurement_day,
       SUM(measurement_value) FILTER (WHERE rn % 2 = 1) AS odd_sum,
       SUM(measurement_value) FILTER (WHERE rn % 2 = 0) AS even_sum
FROM ranked GROUP BY measurement_day;

-- Q26. Y-on-Y Growth Rate: yearly spend per product and growth vs the previous year.
WITH yearly AS (
  SELECT EXTRACT(YEAR FROM transaction_date) AS yr, product_id, SUM(spend) AS curr_year_spend
  FROM user_transactions GROUP BY 1, 2),
w AS (
  SELECT yr, product_id, curr_year_spend,
         LAG(curr_year_spend) OVER (PARTITION BY product_id ORDER BY yr) AS prev_year_spend
  FROM yearly)
SELECT yr AS year, product_id, curr_year_spend, prev_year_spend,
       ROUND(100 * (curr_year_spend - prev_year_spend) / prev_year_spend, 2) AS yoy_rate
FROM w ORDER BY product_id, year;

-- Q27. Page With No Likes: page_ids that have zero likes, ascending.
SELECT p.page_id FROM pages p LEFT JOIN page_likes l ON p.page_id = l.page_id
WHERE l.page_id IS NULL ORDER BY p.page_id;

-- Q28. Frequently Purchased Pairs [CHECK]: product pairs bought in the same transaction, with counts.
SELECT p1.product_name AS product1, p2.product_name AS product2, COUNT(*) AS combo_num
FROM transactions t1
JOIN transactions t2 ON t1.transaction_id = t2.transaction_id AND t1.product_id < t2.product_id
JOIN products p1 ON t1.product_id = p1.product_id
JOIN products p2 ON t2.product_id = p2.product_id
GROUP BY p1.product_name, p2.product_name ORDER BY combo_num DESC;

-- Q29. Supercloud Customer: customers who bought at least one product from EVERY product category.
SELECT cc.customer_id FROM customer_contracts cc JOIN products p ON cc.product_id = p.product_id
GROUP BY cc.customer_id
HAVING COUNT(DISTINCT p.product_category) = (SELECT COUNT(DISTINCT product_category) FROM products)
ORDER BY cc.customer_id;

-- Q30. Sending vs. Opening Snap: see Level 5 Q28 (same problem).

-- Q31. User's Third Transaction: third transaction of every user.
SELECT user_id, spend, transaction_date FROM (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS rn
  FROM transactions) t WHERE rn = 3;

-- Q32. Repeated Payments: payments repeated (same merchant, card, amount) within 10 minutes of the previous one.
WITH t AS (
  SELECT transaction_timestamp,
         LAG(transaction_timestamp) OVER (PARTITION BY merchant_id, credit_card_id, amount
                                          ORDER BY transaction_timestamp) AS prev_ts
  FROM transactions)
SELECT COUNT(*) AS payment_count FROM t
WHERE transaction_timestamp - prev_ts <= INTERVAL '10 minutes';

-- Q33. Compressed Mode: the most frequent item_count (all ties), ascending.
SELECT item_count AS mode FROM items_per_order
WHERE order_occurrences = (SELECT MAX(order_occurrences) FROM items_per_order)
ORDER BY item_count;
