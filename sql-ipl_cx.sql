-- Practice 
-- 1. find the top 5 batsman
SELECT * FROM ipl

SELECT batter, SUM(batsman_run) AS "runs"
FROM ipl
GROUP BY batter
ORDER BY runs DESC 
LIMIT 5

-- 2. find the 2nd highest 6 hitter in ipl

SELECT * FROM ipl

SELECT batter, count(*) AS "count"
FROM ipl
WHERE batsman_run = 6
GROUP BY batter
ORDER BY count DESC
LIMIT 1,1

-- 3. find virat kohli performance against all ipl team(info not available)

SELECT * FROM ipl
WHERE batter = "V Kohli"

-- 4. find top 10 batsman with centuries in ipl
--  (not possible till now we have to use CTE)
SELECT batter,ID,sum(batsman_run) AS "score"
FROM ipl
GROUP BY batter,ID
HAVING score >=100
ORDER BY batter

-- 5. find the top 5 batsman with highest strike rate who have 
--    played a min of 1000 balls 
SELECT * FROM ipl

SELECT batter, sum(batsman_run) AS "runs",count(batsman_run) AS "balls",
ROUND(sum(batsman_run)/count(batsman_run)*100,2) AS "strike_rate"
FROM ipl
GROUP BY batter
HAVING balls > 1000
ORDER BY strike_rate DESC LIMIT 5