CREATE DATABASE join_bd
SHOW TABLES
SELECT * FROM category

SELECT * FROM users1
SELECT * FROM class
SELECT * FROM groups
-- JOIN Operation on tables 
-- 1. CROSS JOIN - no join condition required 
SELECT * FROM join_bd.users1 t1
CROSS JOIN join_bd.groups t2

-- 2. INNER JOIN -> default in join 
SELECT * FROM join_bd.membership t1
INNER JOIN join_bd.users1 t2 -- INNER word in join is optional as inner join is default
ON t1.user_id=t2.user_id

-- 3. LEFT JOIN -> keep the data all in first table and put null if data not in t2
SELECT * FROM membership t1
LEFT JOIN users1 t2
ON t1.user_id=t2.user_id

-- 4. RIGHT JOIN -> 
SELECT * FROM membership t1
RIGHT JOIN users1 t2
ON t1.user_id=t2.user_id

SELECT * FROM membership t1
RIGHT JOIN users1 t2
USING (user_id)

-- 5. OUTER JOIN 
-- left join + right join = OUTER JOIN 

-- 6. SELF JOIN 
SELECT * FROM users1

SELECT * FROM users1 t1
JOIN users1 t2
ON t1.emergency_contact= t2.user_id

-- -----------------------Set opertion in Sql--------------------------
-- 1. UNION -> remove the duplicates one 
SELECT * FROM person1
UNION 
SELECT * FROM join_bd.person2

-- 2. UNION ALL -> keeps duplicates too
SELECT * FROM join_bd.person1
UNION ALL 
SELECT * FROM join_bd.person2

-- 3. INTERSECT -> keep only the common row

SELECT * FROM join_bd.person1
INTERSECT
SELECT * FROM join_bd.person2

-- 4. EXCEPT-> keep all those are not common 

SELECT * FROM join_bd.person1
EXCEPT
SELECT * FROM join_bd.person2

-- OUTER JOIN 
SELECT * FROM membership t1
RIGHT JOIN users1 t2
ON t1.user_id=t2.user_id
UNION 
SELECT * FROM membership t1
LEFT JOIN users1 t2
ON t1.user_id=t2.user_id


-- JOINING on more than one columns 

SELECT * FROM students
SELECT * FROM class
-- In above two coumns if we need to find the teacher of student 
--  we have to join with class_id and year basis

SELECT * FROM students s
RIGHT JOIN class c
ON s.class_id=c.class_id AND s.enrollment_year=c.class_year

SELECT * FROM students s
LEFT JOIN class c
ON s.class_id=c.class_id AND s.enrollment_year=c.class_year

SELECT * FROM students s
JOIN class c
ON s.class_id=c.class_id AND s.enrollment_year=c.class_year

-- ---- JOINING more than two tables

-- creating one more database and tranfer data from join_bd database 
CREATE DATABASE flipkart
CREATE TABLE flipkart.category SELECT * FROM join_bd.category
CREATE TABLE flipkart.orders SELECT * FROM join_bd.orders
CREATE TABLE flipkart.order_details SELECT * FROM join_bd.order_details
CREATE TABLE flipkart.users SELECT * FROM join_bd.users

USE flipkart 

-- joing three table 
SELECT * FROM flipkart.order_details t1
JOIN flipkart.orders t2
ON t1.order_id=t2.order_id
JOIN users t3
ON t2.user_id=t3.user_id

-- Filtering columns -> we have to provide the alais name to select the col
-- 1. find order_id, name and city from order_details and users
SELECT t1.order_id,t2.name,t2.city
FROM flipkart.orders t1
JOIN flipkart.users t2
ON t1.user_id=t2.user_id

-- 2. order_id and product category from order_details and category
SELECT * FROM category
SELECT * FROM order_details 

SELECT t1.order_id, t2.vertical
FROM flipkart.order_details t1
JOIN flipkart.category t2
ON t1.category_id= t2.category_id

-- Filtering Rows on the basis of some condition 
-- find the details of order of users with city pune 
SELECT * FROM flipkart.orders t1
JOIN flipkart.users t2
ON t1.user_id=t2.user_id
WHERE city ="pune"

-- find the details of order of users with city pune  and name sarita 
SELECT * FROM flipkart.orders t1
JOIN flipkart.users t2
ON t1.user_id=t2.user_id
WHERE city ="pune" AND name ="sarita"

-- Find all orders of chair category 

SELECT * FROM flipkart.order_details t1
JOIN flipkart.category t2
ON t1.category_id=t2.category_id
WHERE vertical ="chairs"
--------------------------------**--------------------------------------