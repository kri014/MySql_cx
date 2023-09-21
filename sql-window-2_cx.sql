-- **********************Window Function -2 *****************************
-- 1. Ranking 
-- --> Ranking within any categorical columns

-- 1.1. find the top 5 batstman for each team 
USE campus_x

SELECT * FROM ipl

SELECT * FROM (SELECT BattingTeam,batter,SUM(batsman_run) AS "total_runs",
				DENSE_RANK() OVER(PARTITION BY BattingTeam ORDER BY SUM(batsman_run) DESC) AS "rank_within_team"
				FROM ipl
				GROUP BY BattingTeam,batter) t 
WHERE t.rank_within_team<6
GROUP BY t.BattingTeam,t.rank_within_team

-- 2. Cummulative Sum 
-- 2.1 find the runs make by V-Kohli till 50th,100th,200th match 

SELECT * FROM (
			SELECT CONCAT("Match-",CAST(ROW_NUMBER() OVER(ORDER BY ID ) AS CHAR)) AS "match_no",
			SUM(batsman_run) AS "run_scored",
			SUM(SUM(batsman_run)) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "career_score"
			FROM ipl 
			WHERE batter= "V Kohli" 
			GROUP BY Id) t 
WHERE t.match_no ="Match-50" OR t.match_no ="Match-100" OR t.match_no ="Match-200"

-- 3. Cumulative Average 
-- 3.1. Find the career avg run kohli
SELECT * FROM (
			SELECT CONCAT("Match-",CAST(ROW_NUMBER() OVER(ORDER BY ID ) AS CHAR)) AS "match_no",
			SUM(batsman_run) AS "run_scored",
			SUM(SUM(batsman_run)) OVER w AS "career_score",
            AVG(SUM(batsman_run)) OVER w AS "avg_score"
			FROM ipl 
			WHERE batter= "V Kohli" 
			GROUP BY Id
            WINDOW w AS (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)) t 

-- 4. Running Average
-- 4.1 find the running avg of kohli take 10 matches as window 
SELECT * FROM (
			SELECT CONCAT("Match-",CAST(ROW_NUMBER() OVER(ORDER BY ID ) AS CHAR)) AS "match_no",
			SUM(batsman_run) AS "run_scored",
			SUM(SUM(batsman_run)) OVER w AS "career_score",
            AVG(SUM(batsman_run)) OVER w AS "avg_score",
            AVG(SUM(batsman_run)) OVER( ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) AS "running_avg"
			FROM ipl 
			WHERE batter= "V Kohli" 
			GROUP BY Id
            WINDOW w AS (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)) t 
 
 -- 5. Percent of Total
 USE zomato
 
 
 SELECT t.f_id,f_name,
 (total_value/SUM(total_value) OVER())*100  AS "total_percentage"
 FROM ( SELECT f_id,SUM(amount) AS "total_value" 
         FROM zomato.orders t1
		 JOIN order_details t2
		 ON t1.order_id=t2.order_id
		 WHERE t1.r_id =1
		 GROUP BY f_id) t
         
JOIN food t3
ON t.f_id=t3.f_id
ORDER BY total_percentage DESC

-- 6. Percentage Change 
USE campus_x

SELECT YEAR(date) AS "year",MONTHNAME(date) AS "month",
SUM(fossil_coal) AS "fuel_consumption",
(SUM(fossil_coal)-(LAG(SUM(fossil_coal)) OVER(ORDER BY YEAR(date),MONTH(date))))/(LAG(SUM(fossil_coal)) OVER(ORDER BY YEAR(date),MONTH(date)))*100 AS "percentage_change"
FROM energy
GROUP BY YEAR(date),MONTHNAME(date) 
ORDER BY YEAR(date),MONTH(date) 



SELECT YEAR(date) AS "year",QUARTER(date) AS "month",
SUM(fossil_coal) AS "fuel_consumption",
(SUM(fossil_coal)-(LAG(SUM(fossil_coal)) OVER(ORDER BY YEAR(date),QUARTER(date))))/(LAG(SUM(fossil_coal)) OVER(ORDER BY YEAR(date),QUARTER(date)))*100 AS "percentage_change"
FROM energy
GROUP BY YEAR(date),QUARTER(date) 
ORDER BY YEAR(date),QUARTER(date)

-- weekly basis percentage change 
SELECT *,
((fossil_coal-LAG(fossil_coal,7) OVER(ORDER BY date))/(LAG(fossil_coal,7) OVER(ORDER BY date)))*100 AS "weekly_percentage"
FROM energy
GROUP BY DATE(date)

-- 7. Percentile/ Quartile
-- PERCENTLE_DISC -> discreate data seleceted 
-- PERCENTILE_CONT -> Continous data is selected to find the values  
-- 7.1. Find the median marks of all the student
 

SELECT *,
PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY marks) OVER() AS "median_marks"
FROM marks
-- 7.2. Find branch wise median of student marks 

SELECT *,
PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY marks) OVER(PARTITION BY branch) AS "median_marks",
PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY marks) OVER(PARTITION BY branch) AS "median_count_marks"
FROM marks

-- showing the data without outliers 
SELECT * FROM (SELECT *,
				PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY marks) OVER() AS "Q1",
				PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY marks) OVER() AS "Q3"
				FROM marks) t 
WHERE t.marks > t.Q1-(1.5*(t.Q3-t.Q1)) AND t.marks < t.Q3+(1.5*(t.Q3-t.Q1))
ORDER BY t.student_id

SELECT * FROM marks
-- showing the outliers
SELECT * FROM (SELECT *,
				PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY marks) OVER() AS "Q1",
				PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY marks) OVER() AS "Q3"
				FROM marks) t 
WHERE t.marks <= t.Q1-(1.5*(t.Q3-t.Q1)) OR t.marks > t.Q3+(1.5*(t.Q3-t.Q1))

-- 8. Segmentation (NTILE-> small small bucket within the data )
SELECT *,
NTILE(3) OVER(ORDER BY marks DESC) AS "bbuckets"
FROM marks
ORDER BY student_id

SELECT brand_name,model,price,
CASE 
   WHEN bucket = 1 THEN "budget"
   WHEN bucket = 2 THEN "mid_range"
   WHEN bucket = 3 THEN "premium"
END AS "phone_price_range"
FROM(SELECT brand_name,model,price, 
	NTILE(3) OVER(ORDER BY price) AS "bucket"
	FROM smartphones) t


SELECT brand_name,model,price,
CASE 
   WHEN bucket = 1 THEN "budget"
   WHEN bucket = 2 THEN "mid_range"
   WHEN bucket = 3 THEN "premium"
END AS "phone_price_range"
FROM(SELECT brand_name,model,price, 
	NTILE(3) OVER(PARTITION BY brand_name ORDER BY price) AS "bucket"
	FROM smartphones) t
    
-- 9. Cumulative Distribution (CUME_DIST)
-- 9.1 find the number of student greater than 90 percentile 

SELECT * FROM(SELECT *,
		CUME_DIST() OVER(ORDER BY marks) AS "percentile"
		FROM marks) t 
WHERE t.percentile>0.9

-- 10. Partition by multiple columuns 
-- 10.1 Find the cheapest price of the flights

use flights 

SELECT * FROM (SELECT source,destination,airline, AVG(price) AS "avg_price",
			DENSE_RANK() OVER (PARTITION BY source,destination ORDER BY avg_price) AS "ranking" 
			FROM flights
			GROUP BY source,destination,airline ) t
WHERE t.ranking<2
