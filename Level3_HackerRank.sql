-- =====================================================================
-- LEVEL 3 - HACKERRANK SQL  (MySQL dialect, as accepted on HackerRank)
-- Format:  Q = question, A = answer
-- =====================================================================

-- ############################ BASIC SELECT ############################
-- Q1. Revising the Select Query I: all columns for US cities with population > 100000.
SELECT * FROM CITY WHERE COUNTRYCODE = 'USA' AND POPULATION > 100000;

-- Q2. Revising the Select Query II: names of US cities with population > 120000.
SELECT NAME FROM CITY WHERE COUNTRYCODE = 'USA' AND POPULATION > 120000;

-- Q3. Select All: every column of CITY.
SELECT * FROM CITY;

-- Q4. Select By ID: the city with ID 1661.
SELECT * FROM CITY WHERE ID = 1661;

-- Q5. Japanese Cities' Attributes: all columns for Japanese cities.
SELECT * FROM CITY WHERE COUNTRYCODE = 'JPN';

-- Q6. Japanese Cities' Names: names of Japanese cities.
SELECT NAME FROM CITY WHERE COUNTRYCODE = 'JPN';

-- Q7. Weather Observation Station 1: CITY and STATE of every station.
SELECT CITY, STATE FROM STATION;

-- Q8. Weather Observation Station 3: distinct cities with an even ID.
SELECT DISTINCT CITY FROM STATION WHERE ID % 2 = 0;

-- Q9. Weather Observation Station 4: (total city entries) - (distinct city entries).
SELECT COUNT(CITY) - COUNT(DISTINCT CITY) FROM STATION;

-- Q10. Weather Observation Station 5: shortest and longest city name (ties -> alphabetical first).
(SELECT CITY, LENGTH(CITY) FROM STATION ORDER BY LENGTH(CITY), CITY LIMIT 1)
UNION ALL
(SELECT CITY, LENGTH(CITY) FROM STATION ORDER BY LENGTH(CITY) DESC, CITY LIMIT 1);

-- Q11. Weather Observation Station 6: distinct cities starting with a vowel.
SELECT DISTINCT CITY FROM STATION WHERE LEFT(CITY, 1) IN ('a', 'e', 'i', 'o', 'u');

-- Q12. Weather Observation Station 7: distinct cities ending with a vowel.
SELECT DISTINCT CITY FROM STATION WHERE RIGHT(CITY, 1) IN ('a', 'e', 'i', 'o', 'u');

-- Q13. Weather Observation Station 8: cities that both start AND end with a vowel.
SELECT DISTINCT CITY FROM STATION
WHERE LEFT(CITY, 1) IN ('a', 'e', 'i', 'o', 'u') AND RIGHT(CITY, 1) IN ('a', 'e', 'i', 'o', 'u');

-- Q14. Weather Observation Station 9: cities that do NOT start with a vowel.
SELECT DISTINCT CITY FROM STATION WHERE LEFT(CITY, 1) NOT IN ('a', 'e', 'i', 'o', 'u');

-- Q15. Weather Observation Station 10: cities that do NOT end with a vowel.
SELECT DISTINCT CITY FROM STATION WHERE RIGHT(CITY, 1) NOT IN ('a', 'e', 'i', 'o', 'u');

-- Q16. Weather Observation Station 11: cities that do not start OR do not end with a vowel.
SELECT DISTINCT CITY FROM STATION
WHERE LEFT(CITY, 1) NOT IN ('a', 'e', 'i', 'o', 'u') OR RIGHT(CITY, 1) NOT IN ('a', 'e', 'i', 'o', 'u');

-- Q17. Weather Observation Station 12: cities that do not start AND do not end with a vowel.
SELECT DISTINCT CITY FROM STATION
WHERE LEFT(CITY, 1) NOT IN ('a', 'e', 'i', 'o', 'u') AND RIGHT(CITY, 1) NOT IN ('a', 'e', 'i', 'o', 'u');

-- Q18. Higher Than 75 Marks: names of students scoring > 75, ordered by last 3 characters of name, then ID.
SELECT Name FROM STUDENTS WHERE Marks > 75 ORDER BY RIGHT(Name, 3), ID;

-- Q19. Employee Names: employee names in alphabetical order.
SELECT name FROM Employee ORDER BY name;

-- Q20. Employee Salaries: names of employees earning > 2000 per month with under 10 months of service, by employee_id.
SELECT name FROM Employee WHERE salary > 2000 AND months < 10 ORDER BY employee_id;

-- ############################ ADVANCED SELECT ############################
-- Q21. Type of Triangle: classify each triangle from sides A, B, C.
SELECT CASE
         WHEN A + B <= C OR A + C <= B OR B + C <= A THEN 'Not A Triangle'
         WHEN A = B AND B = C THEN 'Equilateral'
         WHEN A = B OR B = C OR A = C THEN 'Isosceles'
         ELSE 'Scalene'
       END
FROM TRIANGLES;

-- Q22. The PADS (part 1): names followed by first letter of occupation, e.g. Ashely(P).
SELECT CONCAT(Name, '(', LEFT(Occupation, 1), ')') FROM OCCUPATIONS ORDER BY Name;
-- Q22. The PADS (part 2): count of each occupation as a sentence, ordered by count then name.
SELECT CONCAT('There are a total of ', COUNT(*), ' ', LOWER(Occupation), 's.')
FROM OCCUPATIONS GROUP BY Occupation ORDER BY COUNT(*), Occupation;

-- Q23. Occupations: pivot so each occupation is a column, names alphabetical.
SELECT MIN(CASE WHEN Occupation = 'Doctor'    THEN Name END) AS Doctor,
       MIN(CASE WHEN Occupation = 'Professor' THEN Name END) AS Professor,
       MIN(CASE WHEN Occupation = 'Singer'    THEN Name END) AS Singer,
       MIN(CASE WHEN Occupation = 'Actor'     THEN Name END) AS Actor
FROM (SELECT Name, Occupation,
             ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) AS rn
      FROM OCCUPATIONS) t
GROUP BY rn ORDER BY rn;

-- Q24. Binary Tree Nodes: label each node Root, Inner or Leaf.
SELECT N,
       CASE WHEN P IS NULL THEN 'Root'
            WHEN N IN (SELECT DISTINCT P FROM BST WHERE P IS NOT NULL) THEN 'Inner'
            ELSE 'Leaf' END
FROM BST ORDER BY N;

-- Q25. New Companies: per company, counts of distinct lead managers, senior managers, managers, employees.
SELECT c.company_code, c.founder,
       COUNT(DISTINCT l.lead_manager_code),
       COUNT(DISTINCT s.senior_manager_code),
       COUNT(DISTINCT m.manager_code),
       COUNT(DISTINCT e.employee_code)
FROM Company c
JOIN Lead_Manager   l ON c.company_code = l.company_code
JOIN Senior_Manager s ON l.lead_manager_code = s.lead_manager_code
JOIN Manager        m ON s.senior_manager_code = m.senior_manager_code
JOIN Employee       e ON m.manager_code = e.manager_code
GROUP BY c.company_code, c.founder
ORDER BY c.company_code;

-- ############################ AGGREGATION ############################
-- Q26. Revising Aggregations - The Count Function: cities with population > 100000.
SELECT COUNT(*) FROM CITY WHERE POPULATION > 100000;

-- Q27. Revising Aggregations - The Sum Function: total population of California.
SELECT SUM(POPULATION) FROM CITY WHERE DISTRICT = 'California';

-- Q28. Revising Aggregations - Averages: average population of California.
SELECT AVG(POPULATION) FROM CITY WHERE DISTRICT = 'California';

-- Q29. Average Population: average city population rounded down to the nearest integer.
SELECT FLOOR(AVG(POPULATION)) FROM CITY;

-- Q30. Japan Population: sum of populations of all Japanese cities.
SELECT SUM(POPULATION) FROM CITY WHERE COUNTRYCODE = 'JPN';

-- Q31. Population Density Difference: max minus min city population.
SELECT MAX(POPULATION) - MIN(POPULATION) FROM CITY;

-- Q32. The Blunder: error from dropping the zeros in salaries, rounded up.
SELECT CEIL(AVG(Salary) - AVG(REPLACE(Salary, '0', ''))) FROM EMPLOYEES;

-- Q33. Top Earners: highest total earnings (months * salary) and how many employees have it.
SELECT months * salary AS earnings, COUNT(*)
FROM Employee GROUP BY earnings ORDER BY earnings DESC LIMIT 1;

-- Q34. Weather Observation Station 2: sum of LAT_N and LONG_W, both rounded to 2 decimals.
SELECT ROUND(SUM(LAT_N), 2), ROUND(SUM(LONG_W), 2) FROM STATION;

-- Q35. Weather Observation Station 13: sum of LAT_N between 38.7880 and 137.2345, truncated to 4 decimals.
SELECT TRUNCATE(SUM(LAT_N), 4) FROM STATION WHERE LAT_N > 38.7880 AND LAT_N < 137.2345;

-- Q36. Weather Observation Station 14: largest LAT_N below 137.2345, truncated to 4 decimals.
SELECT TRUNCATE(MAX(LAT_N), 4) FROM STATION WHERE LAT_N < 137.2345;

-- Q37. Weather Observation Station 15: LONG_W of the station with the largest LAT_N below 137.2345 (4 decimals).
SELECT ROUND(LONG_W, 4) FROM STATION
WHERE LAT_N = (SELECT MAX(LAT_N) FROM STATION WHERE LAT_N < 137.2345);

-- Q38. Weather Observation Station 16: smallest LAT_N greater than 38.7780, rounded to 4 decimals.
SELECT ROUND(MIN(LAT_N), 4) FROM STATION WHERE LAT_N > 38.7780;

-- Q39. Weather Observation Station 17: LONG_W of the station with the smallest LAT_N greater than 38.7780 (4 decimals).
SELECT ROUND(LONG_W, 4) FROM STATION
WHERE LAT_N = (SELECT MIN(LAT_N) FROM STATION WHERE LAT_N > 38.7780);

-- Q40. Weather Observation Station 18: Manhattan distance between (min LAT_N, min LONG_W) and (max LAT_N, max LONG_W).
SELECT ROUND(ABS(MIN(LAT_N) - MAX(LAT_N)) + ABS(MIN(LONG_W) - MAX(LONG_W)), 4) FROM STATION;

-- Q41. Weather Observation Station 19: Euclidean distance between the same two points.
SELECT ROUND(SQRT(POW(MAX(LAT_N) - MIN(LAT_N), 2) + POW(MAX(LONG_W) - MIN(LONG_W), 2)), 4) FROM STATION;

-- Q42. Weather Observation Station 20: median of LAT_N rounded to 4 decimals.
SELECT ROUND(AVG(LAT_N), 4)
FROM (SELECT LAT_N,
             ROW_NUMBER() OVER (ORDER BY LAT_N) AS rn,
             COUNT(*) OVER () AS cnt
      FROM STATION) t
WHERE rn IN (FLOOR((cnt + 1) / 2), CEIL((cnt + 1) / 2));

-- ############################ BASIC JOIN ############################
-- Q43. Asian Population: total population of all cities in Asia.
SELECT SUM(c.POPULATION) FROM CITY c JOIN COUNTRY co ON c.COUNTRYCODE = co.CODE
WHERE co.CONTINENT = 'Asia';

-- Q44. African Cities: names of all cities in Africa.
SELECT c.NAME FROM CITY c JOIN COUNTRY co ON c.COUNTRYCODE = co.CODE
WHERE co.CONTINENT = 'Africa';

-- Q45. Average Population of Each Continent: continent and average city population (rounded down).
SELECT co.CONTINENT, FLOOR(AVG(c.POPULATION))
FROM CITY c JOIN COUNTRY co ON c.COUNTRYCODE = co.CODE
GROUP BY co.CONTINENT;

-- Q46. The Report: name, grade, marks; names shown as NULL for grades below 8.
SELECT CASE WHEN g.Grade < 8 THEN NULL ELSE s.Name END, g.Grade, s.Marks
FROM Students s JOIN Grades g ON s.Marks BETWEEN g.Min_Mark AND g.Max_Mark
ORDER BY g.Grade DESC,
         CASE WHEN g.Grade >= 8 THEN s.Name END,
         CASE WHEN g.Grade < 8 THEN s.Marks END;

-- Q47. Top Competitors: hackers who got full score on more than one challenge.
SELECT h.hacker_id, h.name
FROM Submissions s
JOIN Challenges c  ON s.challenge_id = c.challenge_id
JOIN Difficulty d  ON c.difficulty_level = d.difficulty_level
JOIN Hackers h     ON s.hacker_id = h.hacker_id
WHERE s.score = d.score
GROUP BY h.hacker_id, h.name
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC, h.hacker_id;

-- Q48. Ollivander's Inventory: cheapest non-evil wand for each (age, power).
SELECT w.id, wp.age, w.coins_needed, w.power
FROM Wands w JOIN Wands_Property wp ON w.code = wp.code
WHERE wp.is_evil = 0
  AND w.coins_needed = (SELECT MIN(w2.coins_needed)
                        FROM Wands w2 JOIN Wands_Property wp2 ON w2.code = wp2.code
                        WHERE wp2.age = wp.age AND w2.power = w.power)
ORDER BY w.power DESC, wp.age DESC;

-- Q49. Challenges: hackers with the max number of challenges, plus anyone whose count is not shared.
WITH counts AS (
  SELECT h.hacker_id, h.name, COUNT(*) AS cnt
  FROM Hackers h JOIN Challenges c ON h.hacker_id = c.hacker_id
  GROUP BY h.hacker_id, h.name
),
freq AS (SELECT cnt, COUNT(*) AS n FROM counts GROUP BY cnt)
SELECT hacker_id, name, cnt FROM counts
WHERE cnt = (SELECT MAX(cnt) FROM counts)
   OR cnt IN (SELECT cnt FROM freq WHERE n = 1)
ORDER BY cnt DESC, hacker_id;

-- Q50. Contest Leaderboard: total of each hacker's best score per challenge; skip zero totals.
SELECT h.hacker_id, h.name, SUM(m.max_score) AS total_score
FROM Hackers h
JOIN (SELECT hacker_id, challenge_id, MAX(score) AS max_score
      FROM Submissions GROUP BY hacker_id, challenge_id) m ON h.hacker_id = m.hacker_id
GROUP BY h.hacker_id, h.name
HAVING SUM(m.max_score) > 0
ORDER BY total_score DESC, h.hacker_id;

-- ############################ ADVANCED JOIN ############################
-- Q51. SQL Project Planning: start and end date of each project (consecutive-day tasks form one project),
--      ordered by project length then start date.
SELECT s.Start_Date, MIN(e.End_Date)
FROM (SELECT Start_Date FROM Projects WHERE Start_Date NOT IN (SELECT End_Date FROM Projects)) s,
     (SELECT End_Date FROM Projects WHERE End_Date NOT IN (SELECT Start_Date FROM Projects)) e
WHERE s.Start_Date < e.End_Date
GROUP BY s.Start_Date
ORDER BY DATEDIFF(MIN(e.End_Date), s.Start_Date), s.Start_Date;

-- Q52. Placements: students whose best friend got a higher salary offer; order by the friend's salary.
SELECT s.Name
FROM Students s
JOIN Friends f   ON s.ID = f.ID
JOIN Packages p1 ON s.ID = p1.ID
JOIN Packages p2 ON f.Friend_ID = p2.ID
WHERE p2.Salary > p1.Salary
ORDER BY p2.Salary;
