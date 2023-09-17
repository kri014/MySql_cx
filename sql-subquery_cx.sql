 --  ---------------------  SUBQUERY -----------------------------------

SELECT * FROM movies 
-- find the maximum rated movies 
SELECT MAX(score) FROM movies -- here we get the maximum score 9.3

SELECT * FROM MOVIES 
WHERE score = 9.3 -- we can hard code it as 9.3

SELECT * FROM MOVIES 
WHERE score = (SELECT max(score) FROM movies) 
-- we can use it as subquery to find the data 

-- ****Independent Subquery - Scalar Subquery **** ----------------
-- 1. Find the movies with highest profit (vs order by)
-- profit = gross-budget


SELECT MAX(gross-budget) FROM movies -- we get the maximum profit 

-- With subquery - O(n)+O(n)=O(2n) it will take more time 
SELECT * FROM movies 
WHERE (gross- budget)=(SELECT MAX(gross-budget) 
                       FROM movies)
                       
-- Without subquery - O(nlogn)+O(1)=O(..) and indexing to here so it is faster 					
SELECT * FROM movies 
ORDER BY (gross-budget) DESC LIMIT  1


-- 2. Find how many movies have a rating > the average of all 
--    the movies rating (find the count average movies )

SELECT * FROM movies 
WHERE score > (SELECT AVG(score)
                FROM movies)
                
                
SELECT count(*) FROM movies 
WHERE score > (SELECT AVG(score)
                FROM movies)-- 2077

-- 3. Find the highest rated movies of 2000
SELECT MAX(score) FROM movies 
WHERE year= 2000

SELECT * FROM movies 
WHERE year= 2000 and score=(SELECT MAX(score) 
                            FROM movies 
							WHERE year= 2000)
-- 4. Find the highest rated movies among all movies 
--     whose number of votes are > the dataset avg votes

SELECT AVG(votes) FROM movies
SELECT max(score) FROM movies

SELECT * FROM movies 
WHERE votes > (SELECT AVG(votes) FROM movies) 
ORDER BY score DESC LIMIT 1
 
SELECT * FROM movies 
WHERE score =( SELECT max(score) 
               FROM movies 
               WHERE votes > (SELECT AVG(votes)  
                               FROM movies))
                               
-- **Independent Subquery - Row Subquery (One Col Multi Rows)***----------
-- 1. find all users whow never ordered
#  USE zomato 

SELECT * FROM users 
WHERE user_id NOT IN (SELECT DISTINCT user_id FROM orders
                      )

-- 2. Find all movies made by top 3 directors (in term of all gross income)
 
 SELECT * FROM join_bd.movies
 
 SELECT director,SUM(gross)  FROM join_bd.movies
 GROUP BY director
 ORDER BY SUM(gross) DESC
 LIMIT 3
 
-- here we get top three director 
SELECT director  FROM join_bd.movies
GROUP BY director
ORDER BY SUM(gross) DESC
LIMIT 3
-- throwing error 
SELECT * FROM join_bd.movies 
WHERE director IN (SELECT director  FROM join_bd.movies
                   GROUP BY director
                   ORDER BY SUM(gross) DESC
                   LIMIT 3)

-- using CTE to solve the question                    
with top_director AS (SELECT director  FROM join_bd.movies
                   GROUP BY director
                   ORDER BY SUM(gross) DESC
                   LIMIT 3)
SELECT * FROM join_bd.movies 
WHERE director IN (SELECT * FROM top_director)

-- 3. find all moveis of all those actors whose filmography avg rating >8.5 
--     (take 25000 votes as cutoff)
SELECT * FROM join_bd.movies
WHERE star IN (SELECT star FROM join_bd.movies 
               WHERE votes >25000
               GROUP BY star
               HAVING avg(score) >8.5) AND score>8.5
               
-- ** Independent Subquery - Table Subquery (Multi Col Multi Rows)
-- 1. Find the most profitable movies of each year
-- first we find the year wise maximum profit 
SELECT year, MAX(gross-budget) FROM join_bd.movies
GROUP BY year

SELECT * FROM join_bd.movies 
WHERE (year,(gross-budget)) IN (SELECT year, MAX(gross-budget) 
                                FROM join_bd.movies
                                GROUP BY year)

-- 2. Find the highest rated movies of each genere votes cutoff of 25000

SELECT genre, max(score) FROM join_bd.movies 
GROUP BY genre

SELECT * FROM join_bd.movies
WHERE (genre,score) IN (SELECT genre, max(score) 
					    FROM join_bd.movies
                        WHERE votes >25000
                       GROUP BY genre)
                       AND votes>25000

-- 3. Find the highest grossing movies of top 5 actors/director combo in 
--    term of total gross income  

SELECT star,director,sum(gross), max(gross)
FROM join_bd.movies
GROUP BY star,director
ORDER BY sum(gross) DESC
LIMIT 5

-- we get the max gross for both actor and director combo
SELECT star,director, max(gross)
FROM join_bd.movies
GROUP BY star,director
ORDER BY sum(gross) DESC
LIMIT 5
-- again code not work as limit is given 
SELECT * FROM join_bd.movies
WHERE (star,director,gross) IN (SELECT star,director, max(gross)
                                FROM join_bd.movies
                                GROUP BY star,director
								ORDER BY sum(gross) DESC
                                LIMIT 5)
-- use cte 
WITH duo_combo AS (SELECT star,director, max(gross)
                                FROM join_bd.movies
                                GROUP BY star,director
								ORDER BY sum(gross) DESC
                                LIMIT 5)
SELECT * FROM join_bd.movies 
WHERE (star,director,gross) IN (SELECT * FROM duo_combo)

-- ** Correlated Subquery--> Inner query related to the outer query 
-- 1. Find all the movies that have a rating higher 
--    than the average rating of movies in tha same genre [Animation]

-- step-1--> outer query
SELECT * FROM join_bd.movies
WHERE score> AVG(genre)
-- step-2--> inner subquery
SELECT AVG(score) FROM join_bd.movies
WHERE genre=?
-- step-3 ->genre value will come from the outer query 
SELECT * FROM join_bd.movies
WHERE score> (SELECT AVG(score) FROM join_bd.movies
              WHERE genre=?)

-- step- 4-> alisa the m1, m2 and provide the condition 

SELECT * FROM join_bd.movies m1
WHERE score>(SELECT AVG(score) FROM join_bd.movies m2 WHERE m2.genre=m1.genre)

-- 2. Find the favorite food of each customer.
USE zomato

WITH fav_food AS (
	SELECT t1.user_id,name,f_name,count(*) AS "frequency"  FROM users t1
	JOIN orders t2 ON t1.user_id= t2.user_id
	JOIN order_details t3 ON t2.order_id=t3.order_id 
	JOIN food t4 ON t3.f_id=t4.f_id
	GROUP BY t1.user_id,t4.f_id
    )
    
SELECT * FROM fav_food m1
WHERE frequency = (SELECT MAX(frequency) FROM fav_food m2
                   WHERE m2.user_id=m1.user_id)
                   
-- ---------------** Usage of subquery**---------------------------------
-- 1. Usage with SELECT 

-- 1.1 Get the percetage of votes for each movies compared to 
--  the total number of votes
USE join_bd
SELECT * FROM movies 

SELECT name,(votes/(SELECT SUM(votes) FROM movies )) *100 from movies

-- 1.2. Display all movies name, genere, score and avg(score) of genre

SELECT name, genre,score, ROUND((SELECT AVG(score) FROM movies m2 WHERE m2.genre=m1.genre),1) AS "avg_rating"
FROM movies m1


-- 2. Usage with FROM 

-- 2.1. Display average rating of all the resturants  
USE zomato
SELECT * FROM orders

SELECT r_name,rating FROM (
SELECT r_id, avg(restaurant_rating) AS "rating" FROM orders 
GROUP BY r_id) t1
JOIN restaurants t2
ON t1.r_id=t2.r_id


-- 3. Usage with HAVING

-- 3.1. find genres having avg score > avg score of all the movies 
use join_bd
SELECT * FROM movies 

SELECT genre, avg(score) as "avg_rating" 
FROM movies 
GROUP BY genre
HAVING avg_rating > (SELECT AVG(score) FROM movies )

-- 4. Subquery In INSERT
-- 1. Populate a already create loyal_customers table with records of 
--    only those customer who have ordered food more than 3 times
use Zomato  

CREATE TABLE loyal_user(
user_id INTEGER,
name VARCHAR(255),
money FLOAT(6,2)
)

SELECT * FROM loyal_user

INSERT INTO loyal_user (user_id,name)
SELECT t1.user_id, name
FROM orders t1
JOIN users t2 ON t1.user_id=t2.user_id
GROUP BY user_id
HAVING count(*) >3

SELECT * FROM loyal_user

-- 5. Subquery in UPDATE 
-- 5.1. Populate the money col of loyal_customers table using the orders table.
--  Proviide a 10% app money to all customers based on theire order value.

SELECT * FROM orders 

UPDATE loyal_user
SET money= (
		SELECT sum(amount)*0.1
		FROM orders 
		WHERE orders.user_id=loyal_user.user_id) 
        
SELECT * FROM loyal_user


--  6. Subquery in Delete
-- 1. Delete all customers records who have never ordered  

SELECT * FROM menu

DELETE FROM users 
WHERE user_id IN (
				SELECT user_id FROM users 
				WHERE user_id 
                NOT IN (SELECT DISTINCT user_id FROM  orders))

SELECT * FROM users 