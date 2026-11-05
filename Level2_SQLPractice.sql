-- =====================================================================
-- LEVEL 2 - SQL-PRACTICE.COM  (database: hospital.db, SQLite dialect)
-- Tables: patients(patient_id, first_name, last_name, gender, birth_date, city,
--         province_id, allergies, height, weight)
--         admissions(patient_id, admission_date, discharge_date, diagnosis, attending_doctor_id)
--         doctors(doctor_id, first_name, last_name, specialty)
--         province_names(province_id, province_name)
-- Format:  Q = question, A = answer
-- =====================================================================

-- ############################ EASY ############################
-- Q1. Show first name, last name and gender of male patients.
SELECT first_name, last_name, gender FROM patients WHERE gender = 'M';

-- Q2. Show first and last name of patients who have no allergies (NULL).
SELECT first_name, last_name FROM patients WHERE allergies IS NULL;

-- Q3. Show first names that start with the letter 'C'.
SELECT first_name FROM patients WHERE first_name LIKE 'C%';

-- Q4. Show first and last name of patients whose weight is between 100 and 120.
SELECT first_name, last_name FROM patients WHERE weight BETWEEN 100 AND 120;

-- Q5. Replace NULL allergies with 'NKA'.
UPDATE patients SET allergies = 'NKA' WHERE allergies IS NULL;

-- Q6. Show first and last name joined into one full_name column.
SELECT first_name || ' ' || last_name AS full_name FROM patients;

-- Q7. Show first name, last name and the full province name of each patient.
SELECT p.first_name, p.last_name, pn.province_name
FROM patients p JOIN province_names pn ON p.province_id = pn.province_id;

-- Q8. How many patients were born in 2010?
SELECT COUNT(*) AS total_patients FROM patients
WHERE birth_date BETWEEN '2010-01-01' AND '2010-12-31';

-- Q9. Show first name, last name and height of the tallest patient.
SELECT first_name, last_name, height FROM patients
WHERE height = (SELECT MAX(height) FROM patients);

-- Q10. Show all columns for patient_ids 1, 45, 534, 879, 1000.
SELECT * FROM patients WHERE patient_id IN (1, 45, 534, 879, 1000);

-- Q11. Show the total number of admissions.
SELECT COUNT(*) AS total_admissions FROM admissions;

-- Q12. Show admissions where the patient was admitted and discharged the same day.
SELECT * FROM admissions WHERE admission_date = discharge_date;

-- Q13. Show patient_id and number of admissions for patient 579.
SELECT patient_id, COUNT(*) AS total_admissions FROM admissions WHERE patient_id = 579;

-- Q14. Show the unique cities in province_id 'NS'.
SELECT DISTINCT city FROM patients WHERE province_id = 'NS';

-- Q15. First name, last name, birth date of patients taller than 160 and heavier than 70.
SELECT first_name, last_name, birth_date FROM patients WHERE height > 160 AND weight > 70;

-- Q16. First name, last name, allergies of patients from Hamilton who have allergies.
SELECT first_name, last_name, allergies FROM patients
WHERE city = 'Hamilton' AND allergies IS NOT NULL;

-- ############################ MEDIUM ############################
-- Q17. Show the unique birth years, ascending.
SELECT DISTINCT strftime('%Y', birth_date) AS birth_year FROM patients ORDER BY birth_year;

-- Q18. Show first names that occur only once.
SELECT first_name FROM patients GROUP BY first_name HAVING COUNT(*) = 1;

-- Q19. patient_id and first_name where first_name starts and ends with 's' and has 6+ letters.
SELECT patient_id, first_name FROM patients
WHERE first_name LIKE 's%s' AND LENGTH(first_name) >= 6;

-- Q20. patient_id, first_name, last_name of patients diagnosed with 'Dementia'.
SELECT p.patient_id, p.first_name, p.last_name
FROM patients p JOIN admissions a ON p.patient_id = a.patient_id
WHERE a.diagnosis = 'Dementia';

-- Q21. Every patient's first_name, ordered by name length then alphabetically.
SELECT first_name FROM patients ORDER BY LENGTH(first_name), first_name;

-- Q22. Total number of male and female patients in two columns.
SELECT SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_count,
       SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female_count
FROM patients;

-- Q23. Patients allergic to Penicillin or Morphine, ordered by allergies, first_name, last_name.
SELECT first_name, last_name, allergies FROM patients
WHERE allergies IN ('Penicillin', 'Morphine')
ORDER BY allergies, first_name, last_name;

-- Q24. patient_id and diagnosis for patients admitted more than once with the same diagnosis.
SELECT patient_id, diagnosis FROM admissions
GROUP BY patient_id, diagnosis HAVING COUNT(*) > 1;

-- Q25. Each city and its patient count, most patients first then by city name.
SELECT city, COUNT(*) AS num_patients FROM patients
GROUP BY city ORDER BY num_patients DESC, city;

-- Q26. First name, last name and role (Patient / Doctor) for every patient and doctor.
SELECT first_name, last_name, 'Patient' AS role FROM patients
UNION ALL
SELECT first_name, last_name, 'Doctor' FROM doctors;

-- Q27. All allergies ordered by how many patients have them (exclude NULL).
SELECT allergies, COUNT(*) AS total_diagnosis FROM patients
WHERE allergies IS NOT NULL GROUP BY allergies ORDER BY total_diagnosis DESC;

-- Q28. Patients born in the 1970s, earliest birth_date first.
SELECT first_name, last_name, birth_date FROM patients
WHERE birth_date >= '1970-01-01' AND birth_date < '1980-01-01'
ORDER BY birth_date;

-- Q29. Full name as LASTNAME,firstname (last upper, first lower), ordered by first_name descending.
SELECT UPPER(last_name) || ',' || LOWER(first_name) AS new_name_format
FROM patients ORDER BY first_name DESC;

-- Q30. province_id and total height where the province's total height is >= 7000.
SELECT province_id, SUM(height) AS sum_height FROM patients
GROUP BY province_id HAVING SUM(height) >= 7000;

-- Q31. Difference between largest and smallest weight for patients with last name 'Maroni'.
SELECT MAX(weight) - MIN(weight) AS weight_delta FROM patients WHERE last_name = 'Maroni';

-- Q32. For days of the month 1-31, the number of admissions on that day, busiest first.
SELECT CAST(strftime('%d', admission_date) AS INTEGER) AS day_number,
       COUNT(*) AS number_of_admissions
FROM admissions GROUP BY day_number ORDER BY number_of_admissions DESC;

-- Q33. All columns of patient 542's most recent admission.
SELECT * FROM admissions WHERE patient_id = 542 ORDER BY admission_date DESC LIMIT 1;

-- Q34. Admissions that meet either rule:
--  (1) odd patient_id AND attending_doctor_id in (1,5,19)
--  (2) attending_doctor_id contains a 2 AND patient_id is 3 characters long
SELECT patient_id, attending_doctor_id, diagnosis FROM admissions
WHERE (patient_id % 2 = 1 AND attending_doctor_id IN (1, 5, 19))
   OR (attending_doctor_id LIKE '%2%' AND LENGTH(patient_id) = 3);

-- Q35. Each doctor's first name, last name and total admissions attended.
SELECT d.first_name, d.last_name, COUNT(*) AS admissions_total
FROM doctors d JOIN admissions a ON d.doctor_id = a.attending_doctor_id
GROUP BY d.doctor_id;

-- Q36. For each doctor: id, full name, first and last admission date attended.
SELECT d.doctor_id, d.first_name || ' ' || d.last_name AS full_name,
       MIN(a.admission_date) AS first_admission_date,
       MAX(a.admission_date) AS last_admission_date
FROM doctors d JOIN admissions a ON d.doctor_id = a.attending_doctor_id
GROUP BY d.doctor_id;

-- Q37. Total patients per province (full name), highest first.
SELECT pn.province_name, COUNT(*) AS patient_count
FROM patients p JOIN province_names pn ON p.province_id = pn.province_id
GROUP BY pn.province_name ORDER BY patient_count DESC;

-- Q38. For every admission: patient full name, diagnosis, doctor full name.
SELECT p.first_name || ' ' || p.last_name AS patient_name,
       a.diagnosis,
       d.first_name || ' ' || d.last_name AS doctor_name
FROM admissions a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.attending_doctor_id = d.doctor_id;

-- Q39. First name, last name and number of duplicates for patients sharing both names.
SELECT first_name, last_name, COUNT(*) AS num_of_duplicates FROM patients
GROUP BY first_name, last_name HAVING COUNT(*) > 1;

-- Q40. Full name, height in feet (1 decimal), weight in pounds, birth_date, gender spelled out.
SELECT first_name || ' ' || last_name AS patient_name,
       ROUND(height / 30.48, 1) AS height_feet,
       ROUND(weight * 2.205) AS weight_pounds,
       birth_date,
       CASE WHEN gender = 'M' THEN 'MALE' ELSE 'FEMALE' END AS gender_type
FROM patients;

-- Q41. Patients who have never been admitted: patient_id, first_name, last_name.
SELECT p.patient_id, p.first_name, p.last_name FROM patients p
WHERE p.patient_id NOT IN (SELECT patient_id FROM admissions);

-- ############################ HARD ############################
-- Q42. Group patients by weight in tens (70-79, 80-89 ...); show group and patient count, heaviest group first.
SELECT (weight / 10) * 10 AS weight_group, COUNT(*) AS patients_in_group
FROM patients GROUP BY weight_group ORDER BY weight_group DESC;

-- Q43. patient_id, weight, height and isObese (BMI >= 30 -> 1 else 0).
SELECT patient_id, weight, height,
       CASE WHEN weight / ((height / 100.0) * (height / 100.0)) >= 30 THEN 1 ELSE 0 END AS isObese
FROM patients;

-- Q44. patient_id, first_name, last_name and doctor's specialty for 'Epilepsy' patients seen by a doctor named Lisa.
SELECT p.patient_id, p.first_name, p.last_name, d.specialty
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
JOIN doctors d ON a.attending_doctor_id = d.doctor_id
WHERE a.diagnosis = 'Epilepsy' AND d.first_name = 'Lisa';

-- Q45. Temporary password = patient_id + length of last name + birth year, for admitted patients.
SELECT DISTINCT p.patient_id,
       p.patient_id || LENGTH(p.last_name) || strftime('%Y', p.birth_date) AS temp_password
FROM patients p JOIN admissions a ON p.patient_id = a.patient_id;

-- Q46. Admission costs $10 (insured, even patient_id) or $50 (not insured). Total cost per has_insurance group.
SELECT CASE WHEN patient_id % 2 = 0 THEN 'Yes' ELSE 'No' END AS has_insurance,
       SUM(CASE WHEN patient_id % 2 = 0 THEN 10 ELSE 50 END) AS cost_after_insurance
FROM admissions GROUP BY has_insurance;

-- Q47. Provinces (full name) that have more male patients than female patients.
SELECT pn.province_name
FROM patients p JOIN province_names pn ON p.province_id = pn.province_id
GROUP BY pn.province_name
HAVING SUM(CASE WHEN p.gender = 'M' THEN 1 ELSE 0 END) > SUM(CASE WHEN p.gender = 'F' THEN 1 ELSE 0 END);

-- Q48. Find one patient: first_name has 'r' as 2nd letter, female, born in Feb/May/Dec,
--      weight 60-80, odd patient_id, lives in Kingston.
SELECT * FROM patients
WHERE first_name LIKE '_r%' AND gender = 'F'
  AND strftime('%m', birth_date) IN ('02', '05', '12')
  AND weight BETWEEN 60 AND 80 AND patient_id % 2 = 1 AND city = 'Kingston';

-- Q49. Percentage of male patients, rounded to 2 decimals, shown with a % sign.
SELECT ROUND(100.0 * SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) / COUNT(*), 2) || '%' AS percent_of_male_patients
FROM patients;

-- Q50. For each admission date: admissions that day and change versus the previous day.
SELECT admission_date, COUNT(*) AS admission_day,
       COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY admission_date) AS admission_count_change
FROM admissions GROUP BY admission_date;

-- Q51. Province names ascending, with 'Ontario' always on top.
SELECT province_name FROM province_names
ORDER BY CASE WHEN province_name = 'Ontario' THEN 0 ELSE 1 END, province_name;

-- Q52. Per doctor per year: doctor_id, full name, specialty, year, total admissions.
SELECT d.doctor_id, d.first_name || ' ' || d.last_name AS doctor_name, d.specialty,
       strftime('%Y', a.admission_date) AS selected_year, COUNT(*) AS total_admissions
FROM doctors d JOIN admissions a ON d.doctor_id = a.attending_doctor_id
GROUP BY d.doctor_id, selected_year ORDER BY d.doctor_id, selected_year;
