-- =====================================================================
-- LEVEL 5 - DATALEMUR SQL CHALLENGES  (PostgreSQL dialect)
-- Format:  Q = question, A = answer
-- Items marked [CHECK] : I wrote the answer from the standard problem statement,
-- but could not open the page, so confirm table/column names on DataLemur.
-- =====================================================================

-- ############################ EASY ############################
-- Q1. Cities With Completed Trades: top 3 cities by number of completed orders.
SELECT u.city, COUNT(t.order_id) AS total_orders
FROM trades t JOIN users u ON t.user_id = u.user_id
WHERE t.status = 'Completed'
GROUP BY u.city ORDER BY total_orders DESC LIMIT 3;

-- Q2. Page With No Likes: page_ids that have zero likes, ascending.
SELECT p.page_id FROM pages p LEFT JOIN page_likes l ON p.page_id = l.page_id
WHERE l.page_id IS NULL ORDER BY p.page_id;

-- Q3. Laptop vs Mobile Viewership: total laptop views and mobile (tablet+phone) views.
SELECT COUNT(*) FILTER (WHERE device_type = 'laptop') AS laptop_views,
       COUNT(*) FILTER (WHERE device_type IN ('tablet', 'phone')) AS mobile_views
FROM viewership;

-- Q4. Purchasing Activity by Product Type: running total of quantity per product_type by order_date.
SELECT order_date, product_type,
       SUM(quantity) OVER (PARTITION BY product_type ORDER BY order_date) AS cum_purchased
FROM total_trans ORDER BY order_date;

-- Q5. Teams Power Users: top 2 senders by messages sent in August 2022.
SELECT sender_id, COUNT(message_id) AS message_count FROM messages
WHERE sent_date >= '2022-08-01' AND sent_date < '2022-09-01'
GROUP BY sender_id ORDER BY message_count DESC LIMIT 2;

-- Q6. Highest Number of Products [CHECK]: customers ranked by number of distinct products ordered.
SELECT customer_id, COUNT(DISTINCT product_id) AS product_count
FROM orders GROUP BY customer_id ORDER BY product_count DESC LIMIT 3;

-- Q7. Histogram of Tweets: how many users posted 1, 2, 3 ... tweets in 2022.
WITH per_user AS (
  SELECT user_id, COUNT(tweet_id) AS tweet_bucket FROM tweets
  WHERE EXTRACT(YEAR FROM tweet_date) = 2022 GROUP BY user_id)
SELECT tweet_bucket, COUNT(user_id) AS users_num FROM per_user GROUP BY tweet_bucket;

-- Q8. Spare Server Capacity [CHECK]: spare capacity per data center = capacity - forecasted demand.
SELECT d.datacenter_id, d.monthly_capacity - f.monthly_demand AS spare_capacity
FROM datacenters d JOIN forecasted_demand f ON d.datacenter_id = f.datacenter_id
ORDER BY d.datacenter_id;

-- Q9. Repeat Purchases on Multiple Days: users who bought the same product on 2+ different days.
SELECT COUNT(DISTINCT user_id) AS repeat_purchasers FROM (
  SELECT user_id, product_id FROM purchases
  GROUP BY user_id, product_id HAVING COUNT(DISTINCT purchase_date::date) > 1) t;

-- Q10. Duplicate Job Listings: companies that posted the same title+description more than once.
SELECT COUNT(DISTINCT company_id) AS duplicate_companies FROM (
  SELECT company_id FROM job_listings
  GROUP BY company_id, title, description HAVING COUNT(*) > 1) t;

-- Q11. Average Post Hiatus (Part 1): days between each user's first and last post in 2021.
SELECT user_id, MAX(post_date::date) - MIN(post_date::date) AS days_between
FROM posts WHERE post_date >= '2021-01-01' AND post_date < '2022-01-01'
GROUP BY user_id HAVING COUNT(post_id) > 1;

-- Q12. App Clickthrough Rate: CTR = 100 * clicks / impressions per app, 2022.
SELECT app_id,
       ROUND(100.0 * COUNT(*) FILTER (WHERE event_type = 'click')
             / COUNT(*) FILTER (WHERE event_type = 'impression'), 2) AS ctr
FROM events WHERE timestamp >= '2022-01-01' AND timestamp < '2023-01-01'
GROUP BY app_id;

-- Q13. User's Third Transaction: the third transaction of every user.
SELECT user_id, spend, transaction_date FROM (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS rn
  FROM transactions) t WHERE rn = 3;

-- Q14. LinkedIn Power Creators (Part 1): profiles with more followers than their employer's page.
SELECT pp.profile_id FROM personal_profiles pp
JOIN employer_pages ep ON pp.employer_id = ep.employer_id
WHERE pp.followers > ep.followers ORDER BY pp.profile_id;

-- Q15. Photoshop Revenue Analysis: revenue from other Adobe products for Photoshop customers.
SELECT customer_id, SUM(revenue) AS revenue FROM adobe_transactions
WHERE customer_id IN (SELECT customer_id FROM adobe_transactions WHERE product = 'Photoshop')
  AND product <> 'Photoshop'
GROUP BY customer_id ORDER BY customer_id;

-- Q16. Data Science Skills: candidates having Python, Tableau and PostgreSQL.
SELECT candidate_id FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id HAVING COUNT(skill) = 3 ORDER BY candidate_id;

-- Q17. Histogram of Users and Purchases: each user's most recent purchase day and count of products that day.
WITH latest AS (
  SELECT transaction_date, user_id, product_id,
         RANK() OVER (PARTITION BY user_id ORDER BY transaction_date DESC) AS rnk
  FROM user_transactions)
SELECT transaction_date, user_id, COUNT(product_id) AS purchase_count
FROM latest WHERE rnk = 1 GROUP BY transaction_date, user_id ORDER BY transaction_date;

-- Q18. Subject Matter Experts: employees with 8+ years in one domain OR 12+ years across two different domains.
SELECT employee_id FROM employee_expertise
GROUP BY employee_id
HAVING MAX(years_of_experience) >= 8
    OR (COUNT(DISTINCT domain) >= 2 AND SUM(years_of_experience) >= 12)
ORDER BY employee_id;

-- Q19. Final Account Balance: deposits minus withdrawals per account.
SELECT account_id,
       SUM(CASE WHEN transaction_type = 'Deposit' THEN amount ELSE -amount END) AS final_balance
FROM transactions GROUP BY account_id;

-- Q20. Compensation Outliers: Overpaid (> 2x title average) / Underpaid (< 0.5x title average).
WITH avg_by_title AS (SELECT title, AVG(salary) AS avg_salary FROM employee_pay GROUP BY title)
SELECT e.employee_id, e.salary,
       CASE WHEN e.salary > 2 * a.avg_salary THEN 'Overpaid' ELSE 'Underpaid' END AS status
FROM employee_pay e JOIN avg_by_title a ON e.title = a.title
WHERE e.salary > 2 * a.avg_salary OR e.salary < 0.5 * a.avg_salary;

-- Q21. Average Review Ratings: average stars per product per month.
SELECT EXTRACT(MONTH FROM submit_date) AS mth, product_id, ROUND(AVG(stars), 2) AS avg_stars
FROM reviews GROUP BY EXTRACT(MONTH FROM submit_date), product_id ORDER BY mth, product_id;

-- Q22. Unfinished Parts: parts and assembly steps that have no finish date.
SELECT part, assembly_step FROM parts_assembly WHERE finish_date IS NULL;

-- Q23. Unique Money Transfer Relationships: pairs of users who have paid each other in both directions.
SELECT COUNT(*) AS unique_relationships FROM (
  SELECT LEAST(payer_id, recipient_id) AS a, GREATEST(payer_id, recipient_id) AS b
  FROM payments GROUP BY 1, 2 HAVING COUNT(DISTINCT payer_id) = 2) t;

-- Q24. Ad Campaign ROAS: revenue / spend per advertiser.
SELECT advertiser_id, ROUND((SUM(revenue) / SUM(spend))::numeric, 2) AS ROAS
FROM ad_campaigns GROUP BY advertiser_id ORDER BY advertiser_id;

-- Q25. Second Day Confirmation: users who confirmed the day after signing up.
SELECT e.user_id FROM emails e JOIN texts t ON e.email_id = t.email_id
WHERE t.signup_action = 'Confirmed' AND t.action_date::date = e.signup_date::date + 1;

-- Q26. Apple Pay Volume [CHECK]: transaction volume per merchant paid via Apple Pay.
SELECT UPPER(merchant_id) AS merchant_id,
       COALESCE(SUM(transaction_amount) FILTER (WHERE LOWER(payment_method) = 'apple pay'), 0) AS volume
FROM transactions GROUP BY UPPER(merchant_id) ORDER BY volume DESC;

-- Q27. Average Deal Size (Part 1) [CHECK]: average deal value per customer size segment.
SELECT CASE WHEN num_seats < 100 THEN 'SMB' ELSE 'Enterprise' END AS segment,
       ROUND(AVG(num_seats * (yearly_seat_cost + 12 * monthly_seat_cost))::numeric, 2) AS avg_deal_size
FROM contracts GROUP BY 1;

-- ############################ MEDIUM ############################
-- Q28. Sending vs. Opening Snaps: % of time spent sending and opening per age bucket.
SELECT ab.age_bucket,
       ROUND(100.0 * SUM(CASE WHEN a.activity_type = 'send' THEN a.time_spent END)::numeric
             / SUM(a.time_spent)::numeric, 2) AS send_perc,
       ROUND(100.0 * SUM(CASE WHEN a.activity_type = 'open' THEN a.time_spent END)::numeric
             / SUM(a.time_spent)::numeric, 2) AS open_perc
FROM activities a JOIN age_breakdown ab ON a.user_id = ab.user_id
WHERE a.activity_type IN ('send', 'open') GROUP BY ab.age_bucket;

-- Q29. Tweets' Rolling Averages: 3-day rolling average of tweet_count per user.
SELECT user_id, tweet_date,
       ROUND(AVG(tweet_count) OVER (PARTITION BY user_id ORDER BY tweet_date
             ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS rolling_avg_3d
FROM tweets;

-- Q30. Odd and Even Measurements: per day, sum of odd-numbered and even-numbered measurements.
WITH ranked AS (
  SELECT measurement_time::date AS measurement_day, measurement_value,
         ROW_NUMBER() OVER (PARTITION BY measurement_time::date ORDER BY measurement_time) AS rn
  FROM measurements)
SELECT measurement_day,
       SUM(measurement_value) FILTER (WHERE rn % 2 = 1) AS odd_sum,
       SUM(measurement_value) FILTER (WHERE rn % 2 = 0) AS even_sum
FROM ranked GROUP BY measurement_day;

-- Q31. Frequently Purchased Pairs [CHECK]: product pairs bought in the same transaction, with counts.
SELECT p1.product_name AS product1, p2.product_name AS product2, COUNT(*) AS combo_num
FROM transactions t1
JOIN transactions t2 ON t1.transaction_id = t2.transaction_id AND t1.product_id < t2.product_id
JOIN products p1 ON t1.product_id = p1.product_id
JOIN products p2 ON t2.product_id = p2.product_id
GROUP BY p1.product_name, p2.product_name ORDER BY combo_num DESC;

-- Q32. Highest-Grossing Items: top 2 products by spend in each category, 2022.
WITH ranked AS (
  SELECT category, product, SUM(spend) AS total_spend,
         RANK() OVER (PARTITION BY category ORDER BY SUM(spend) DESC) AS rnk
  FROM product_spend WHERE EXTRACT(YEAR FROM transaction_date) = 2022
  GROUP BY category, product)
SELECT category, product, total_spend FROM ranked WHERE rnk <= 2 ORDER BY category, rnk;

-- Q33. First Transaction: number of users whose first transaction was $50 or more.
SELECT COUNT(DISTINCT user_id) AS users FROM (
  SELECT user_id, spend,
         RANK() OVER (PARTITION BY user_id ORDER BY transaction_date) AS rnk
  FROM user_transactions) t WHERE rnk = 1 AND spend >= 50;

-- Q34. LinkedIn Power Creators (Part 2): profiles with more followers than EVERY company they work at.
SELECT pp.profile_id FROM personal_profiles pp
JOIN employee_company ec ON pp.profile_id = ec.personal_profile_id
JOIN company_pages cp ON ec.company_id = cp.company_id
GROUP BY pp.profile_id, pp.followers
HAVING pp.followers > MAX(cp.followers) ORDER BY pp.profile_id;

-- Q35. Top 5 Artists: artists ranked by appearances in the global top 10 (ties share a rank).
WITH appearances AS (
  SELECT s.artist_id, COUNT(*) AS n FROM global_song_rank r
  JOIN songs s ON r.song_id = s.song_id WHERE r.rank <= 10 GROUP BY s.artist_id),
ranked AS (
  SELECT a.artist_name, DENSE_RANK() OVER (ORDER BY ap.n DESC) AS artist_rank
  FROM appearances ap JOIN artists a ON a.artist_id = ap.artist_id)
SELECT artist_name, artist_rank FROM ranked WHERE artist_rank <= 5 ORDER BY artist_rank, artist_name;

-- Q36. Signup Confirmation Rate: confirmed emails / total emails.
SELECT ROUND(COUNT(DISTINCT t.email_id)::numeric / COUNT(DISTINCT e.email_id), 2) AS confirm_rate
FROM emails e LEFT JOIN texts t ON e.email_id = t.email_id AND t.signup_action = 'Confirmed';

-- Q37. Consulting Bench Time [CHECK]: bench days in 2023 = 261 working days - days on client engagements.
SELECT s.employee_id, 261 - SUM(c.end_date - c.start_date + 1) AS bench_days
FROM staffing s JOIN consulting_engagements c ON s.job_id = c.job_id
WHERE s.is_consultant = TRUE GROUP BY s.employee_id;

-- Q38. Spotify Listening History: combine all-time plays with plays from the weekly feed (up to 2022-08-04).
SELECT user_id, song_id, SUM(song_plays) AS song_plays FROM (
  SELECT user_id, song_id, song_plays FROM songs_history
  UNION ALL
  SELECT user_id, song_id, 1 FROM songs_weekly WHERE listen_time <= '2022-08-04 23:59:59') t
GROUP BY user_id, song_id ORDER BY song_plays DESC;

-- Q39. Fill Missing Client Data: carry the last non-null category forward.
WITH g AS (SELECT *, COUNT(category) OVER (ORDER BY product_id) AS grp FROM products)
SELECT product_id, COALESCE(category, MAX(category) OVER (PARTITION BY grp)) AS category, name
FROM g ORDER BY product_id;

-- Q40. User Session Activity [CHECK]: rank users by total duration within each session type (Jan 2022).
SELECT user_id, session_type, SUM(duration) AS total_duration,
       RANK() OVER (PARTITION BY session_type ORDER BY SUM(duration) DESC) AS ranking
FROM sessions WHERE start_date >= '2022-01-01' AND start_date <= '2022-02-01'
GROUP BY user_id, session_type;

-- Q41. Invalid Search Results [CHECK]: total searches and weighted invalid-result % per country.
SELECT country, SUM(num_search) AS total_search,
       ROUND((SUM(num_search * invalid_result_pct) / SUM(num_search))::numeric, 2) AS invalid_pct
FROM search_category WHERE invalid_result_pct IS NOT NULL
GROUP BY country ORDER BY total_search DESC;

-- Q42. Top Rated Businesses [CHECK]: number and % of businesses that have a 4+ star review.
SELECT COUNT(DISTINCT business_id) AS n_top_rated,
       ROUND(100.0 * COUNT(DISTINCT business_id) FILTER (WHERE review_stars >= 4)
             / COUNT(DISTINCT business_id), 2) AS pct_top_rated
FROM reviews;

-- Q43. Same Week Purchases [CHECK]: users who made another purchase within 7 days of their first.
SELECT COUNT(DISTINCT u.user_id) AS users_same_week
FROM users u JOIN user_purchases p ON u.user_id = p.user_id
WHERE p.purchase_date > u.signup_date AND p.purchase_date <= u.signup_date + INTERVAL '7 days';

-- ############################ HARD ############################
-- Q44. Active User Retention: users active in July 2022 who were also active in June 2022.
SELECT 7 AS mth, COUNT(DISTINCT curr.user_id) AS monthly_active_users
FROM user_actions curr
WHERE EXTRACT(MONTH FROM curr.event_date) = 7 AND EXTRACT(YEAR FROM curr.event_date) = 2022
  AND EXISTS (SELECT 1 FROM user_actions prev
              WHERE prev.user_id = curr.user_id
                AND EXTRACT(MONTH FROM prev.event_date) = 6
                AND EXTRACT(YEAR FROM prev.event_date) = 2022);

-- Q45. Y-on-Y Growth Rate: yearly spend per product and growth vs the previous year.
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

-- Q46. User Shopping Sprees: users who bought on 3 or more consecutive days.
SELECT DISTINCT t1.user_id
FROM transactions t1
JOIN transactions t2 ON t1.user_id = t2.user_id AND t2.transaction_date::date = t1.transaction_date::date + 1
JOIN transactions t3 ON t1.user_id = t3.user_id AND t3.transaction_date::date = t1.transaction_date::date + 2
ORDER BY t1.user_id;

-- Q47. Monthly Merchant Balance: running balance within each month (deposits - withdrawals).
WITH daily AS (
  SELECT transaction_date,
         SUM(CASE WHEN type = 'deposit' THEN amount ELSE -amount END) AS net
  FROM transactions GROUP BY transaction_date)
SELECT transaction_date,
       SUM(net) OVER (PARTITION BY DATE_TRUNC('month', transaction_date) ORDER BY transaction_date) AS balance
FROM daily ORDER BY transaction_date;

-- Q48. Bad Delivery Rate [CHECK]: % of first-14-day orders with a bad experience, for June 2022 signups.
WITH o AS (
  SELECT o.order_id, o.status, t.estimated_delivery_timestamp, t.actual_delivery_timestamp
  FROM orders o JOIN customers c ON o.customer_id = c.customer_id
  LEFT JOIN trips t ON o.trip_id = t.trip_id
  WHERE c.signup_timestamp >= '2022-06-01' AND c.signup_timestamp < '2022-07-01'
    AND o.order_timestamp < c.signup_timestamp + INTERVAL '14 days')
SELECT ROUND(100.0 * COUNT(*) FILTER (
         WHERE status IN ('completed incorrectly', 'never_received')
            OR actual_delivery_timestamp > estimated_delivery_timestamp + INTERVAL '30 minutes')
       / COUNT(*), 2) AS bad_experience_pct
FROM o;
