
--------------------- Task-32 ---------------------------------------

-- 1. Show records of 'male' patient from 'southwest' region

SELECT * FROM insurance_data

SELECT * FROM insurance_data 
WHERE gender="male" and region="southwest"

-- 2. Show all records having bmi in range 30 to 45 both inclusive.

SELECT * FROM insurance_data
WHERE bmi BETWEEN 30 and 45

-- 3. Show minimum and maximum bloodpressure of diabetic patient who smokes. 
--    Make column names as MinBP and MaxBP respectively.

SELECT MAX(bloodpressure) AS "MaxBp", MIN(bloodpressure) AS 'MinBp'
FROM insurance_data
WHERE diabetic="YES"
-- 4. Find no of unique patients who are not from southwest region.

SELECT * FROM insurance_data

SELECT count(DISTINCT(PatientID)) FROM insurance_data
WHERE region NOT IN ("southwest")

-- 5. Total claim amount from male smoker.
SELECT * FROM insurance_data

SELECT round(sum(claim),2) FROM insurance_data
WHERE smoker="Yes" -- '8781763.56'
-- 6. Select all records of south region.
SELECT * FROM insurance_data

SELECT DISTINCT (region) FROM insurance_data

SELECT * FROM insurance_data
WHERE region IN ("southeast","southwest")

-- 7. No of patient having normal blood pressure. Normal range[90-120]
SELECT count(*) FROM insurance_data
WHERE bloodpressure BETWEEN 90 and 120 -- 758

-- 8. No of pateint below 17 years of age having normal blood pressure as per below formula -
--     -> BP normal range = 80+(age in years × 2) to 100 + (age in years × 2)
--     -> Note: Formula taken just for practice, don't take in real sense.

SELECT * FROM insurance_data

SELECT 80+age*2 as "MinBp",100+age*2 AS "MaxBP", count(*)FROM insurance_data
WHERE age <40

SELECT * from insurance_data
where age <17

-- 9. What is the average claim amount for non-smoking female 
--    patients who are diabetic?
SELECT ROUND(AVG(claim),2) from insurance_data
WHERE diabetic="Yes" and smoker="No"-- 8268.42
-- 10. Write a SQL query to update the claim amount 
--     for the patient with PatientID = 1234 to 5000.

SELECT * FROM insurance_data
WHERE PatientID=1234

UPDATE insurance_data
SET claim=5000
WHERE PatientID=1234

SELECT * FROM insurance_data
WHERE PatientID=1234

-- 11. Write a SQL query to delete all records for 
--     patients who are smokers and have no children.
SELECT * FROM insurance_data
WHERE smoker="No" and children=0

DELETE  FROM insurance_data
WHERE smoker="No" and children=0