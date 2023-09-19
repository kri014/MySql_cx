--   *******************Window Finction******************************--
-- create a table of marks 
CREATE TABLE marks (
 student_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    branch VARCHAR(255),
    marks INTEGER
);

INSERT INTO marks (name,branch,marks)VALUES 
('Nitish','EEE',82),
('Rishabh','EEE',91),
('Anukant','EEE',69),
('Rupesh','EEE',55),
('Shubham','CSE',78),
('Ved','CSE',43),
('Deepak','CSE',98),
('Arpan','CSE',95),
('Vinay','ECE',95),
('Ankit','ECE',88),
('Anand','ECE',81),
('Rohit','ECE',95),
('Prashant','MECH',75),
('Amit','MECH',69),
('Sunny','MECH',39),
('Gautam','MECH',51)

SELECT * FROM marks

-- 1. Aggregate function with OVER()

SELECT AVG(marks) FROM marks-- > will get arregate function in one 

SELECT AVG(marks) OVER() FROM marks -- > Will give arregate for all each

SELECT *,AVG(marks) OVER() FROM marks -- > it consider all data in single window

SELECT *,AVG(marks) OVER(PARTITION BY branch) FROM marks 
-- > with the help of PARTITION clause we create a separate window for each branch 
-- > On the basis of seperate window we can perform the aggregate function 

-- 1.1 min/max for overall and min/max for each branch

SELECT *,min(marks) OVER() AS "overall min", max(marks) OVER() AS "overall max",
min(marks) OVER(PARTITION BY branch) AS "min_per_branch",
max(marks) OVER (PARTITION BY branch) AS "max_per_branch"
FROM marks 

-- 1.2 Find all the students who have marks higher/lower than 
--     the average marks of respective branch

SELECT * FROM (SELECT *,
			  AVG(marks) OVER (PARTITION BY branch) AS "avg_mark"
              FROM marks) t
WHERE t.avg_mark>t.marks


SELECT * FROM (SELECT *,
			  AVG(marks) OVER (PARTITION BY branch) AS "avg_mark"
              FROM marks) t
WHERE t.avg_mark<t.marks

-- 2. RANK/DENSE_RANK/ROW_RANK
-- 2.1. Find top 2 most paying customer of each month
-- 2.2. create roll no from branch and marks 

SELECT *,
RANK() OVER(ORDER BY marks) -- whole columns is one window 
FROM marks 

SELECT *,
RANK() OVER(PARTITION BY branch ORDER BY marks) AS "rank",
DENSE_RANK() OVER(PARTITION BY branch ORDER BY marks) AS "dense_rank"-- window on branch
FROM marks 

SELECT *,
ROW_NUMBER() OVER(PARTITION BY branch)
FROM marks

SELECT *,
CONCAT(branch,"-", ROW_NUMBER() OVER(PARTITION BY branch))
FROM marks

-- 2.1. Find top 2 most paying customer of each month
USE zomato
SELECT * FROM (
				SELECT MONTHNAME(date),user_id, SUM(amount),
				RANK() OVER(PARTITION BY MONTHNAME(date) ORDER BY SUM(amount) DESC) AS "monthly_expense"
				FROM orders
				GROUP BY MONTHNAME(date),user_id
				ORDER BY MONTHNAME(date) DESC) t 
                WHERE monthly_expense <3
                
-- 3. FIRST_VALUE/LAST_VALUE/NTH_VALUE
use campus_x
 
SELECT *,
FIRST_VALUE(name) OVER ( ORDER BY marks DESC)
FROM marks  -- will show the maxumim marks of the name 

SELECT *, 
FIRST_VALUE(marks) OVER(ORDER BY marks DESC)
FROM marks -- maximum marks in th whole columns 

-- 
SELECT *, 
LAST_VALUE(marks) OVER(ORDER BY marks DESC)
FROM marks -- something wrong in the opreration 

-- Frame
-- next level of grouping in window  
-- 1. ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW (1st and current)
-- 2. ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING (just beofore , current, just after)
-- 3. ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING (1st, last)
-- 4. ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING (3 before, current, 3 last)   

-- lowest number gain by total student 
SELECT *, 
LAST_VALUE(marks) OVER(ORDER BY marks DESC
                       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM marks	            

-- branch wise lowest number 
SELECT *, 
LAST_VALUE(marks) OVER(PARTITION BY branch ORDER BY marks DESC
                       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM marks

-- 2nd topper using nth value (
SELECT *, 
NTH_VALUE(name,2) OVER(PARTITION BY branch ORDER BY marks DESC
                       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM marks

-- 5th topper using nth -> since no. of students is less than 5 it will give null value 
SELECT *, 
NTH_VALUE(name,5) OVER(PARTITION BY branch ORDER BY marks DESC
                       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM marks

-- Find the branch topper/lowest  
SELECT name,branch,marks FROM (SELECT *,
FIRST_VALUE(name) OVER(PARTITION BY branch ORDER BY marks DESC) "topper_name",
FIRST_VALUE(marks) OVER(PARTITION BY branch ORDER BY marks DESC) "topper_marks"
FROM marks ) t
WHERE t.name = t.topper_name and t.marks=t.topper_marks


SELECT name,branch,marks FROM (SELECT *,
LAST_VALUE(name) OVER(PARTITION BY branch ORDER BY marks DESC
                       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) "last_name",
LAST_VALUE(marks) OVER(PARTITION BY branch ORDER BY marks DESC
					   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) "low_marks"
FROM marks ) t
WHERE t.name = t.last_name and t.marks=t.low_marks

-- we can also give a name of window operation --> some error came  

SELECT name,branch,marks FROM (SELECT *,
LAST_VALUE(name) OVER w "last_name",
LAST_VALUE(marks) OVER w "low_marks"
FROM marks ) t
WHERE t.name = t.last_name and t.marks=t.low_marks

WINDOW w AS (PARTITION BY branch ORDER BY marks DESC
                       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
                       
-- 4. LAG/LEAD 
-- LAG --> it will give the previous value of the columns
-- LEAD--> it will give the next value as laeding columns  
SELECT *,
LAG(marks) OVER (ORDER BY student_id),
LEAD(marks) OVER (ORDER BY student_id) 
FROM marks 

SELECT *,
LAG(marks) OVER (PARTITION BY branch ORDER BY student_id),
LEAD(marks) OVER (PARTITION BY branch ORDER BY student_id) 
FROM marks 

-- 1. Find the MOM revenue growth of zomato
USE zomato

SELECT MONTHNAME(date), SUM(amount),
LAG(sum(amount)) OVER(ORDER BY MONTH(date))  
FROM orders 
GROUP BY MONTHNAME(date)
ORDER BY MONTH(date) ASC 

SELECT MONTHNAME(date), SUM(amount),
((SUM(amount)-LAG(sum(amount)) OVER(ORDER BY MONTH(date)))/LAG(sum(amount)) OVER(ORDER BY MONTH(date)))*100 AS "profit" 
FROM orders 
GROUP BY MONTHNAME(date)
ORDER BY MONTH(date) ASC 


	