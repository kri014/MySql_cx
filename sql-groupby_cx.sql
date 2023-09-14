-- Grouping Data

-- In grouping we group the table on the basis of categorical columns and 
--  then we perform certain aggregate function (count,avg,max,min)
 
-- 1. Group smartphones by brand and get the count,average price, 
--    max price, avg screen size and avg battery capacity 

SELECT brand_name,count(*) AS "total_brand",
ROUND(AVG(price)) AS "avg_price",
MAX(price) AS "max_price",
ROUND(AVG(screen_size)) AS "avg_screensize",
ROUND(AVG(battery_capacity)) AS "avg_battery_capacity"
FROM smartphones 
GROUP BY brand_name
ORDER BY total_brand DESC
LIMIT 5 

-- 2. Group smartphones by whether they have an NFC/fast_charging 
--    and get the average price and rating 

SELECT has_nfc, 
ROUND(AVG(rating)) AS "avg rating", 
ROUND(AVG(price)) AS "avg price" 
FROM smartphones 
GROUP BY has_nfc


SELECT fast_charging_available, 
ROUND(AVG(rating)) AS "avg rating", 
ROUND(AVG(price)) AS "avg price" 
FROM smartphones 
GROUP BY fast_charging_available

-- 3. Group smartphones by the extended memeory availabale 
--     and get the average price
SELECT * FROM smartphones 

SELECT extended_memory_available, 
-- ROUND(AVG(rating)) AS "avg rating", 
ROUND(AVG(price)) AS "avg price" 
FROM smartphones 
GROUP BY extended_memory_available

-- GROUP BY on multiple columns 

-- 4. Group smartphones by the brand and the processor 
--     brand and get the count of model and the average 
--     primary camera resolution(rear)

SELECT * FROM smartphones 

SELECT brand_name,
processor_brand,
count(*) AS "total_mobile",
ROUND(AVG(primary_camera_rear)) 
FROM smartphones 
GROUP BY brand_name , processor_brand
ORDER BY total_mobile DESC

SELECT brand_name,
processor_brand,os,
count(*) AS "total_mobile",
ROUND(AVG(primary_camera_rear)) 
FROM smartphones 
GROUP BY brand_name , processor_brand,os

-- 5. find top 5 most costly phone brands 
SELECT brand_name, ROUND(AVG(price)) AS "avg_price"
FROM smartphones 
GROUP BY brand_name
ORDER BY avg_price DESC
LIMIT 5

-- 6. which brand makes a smallest screen smartphones
SELECT brand_name, ROUND(AVG(screen_size)) AS "screen_size"
FROM smartphones 
GROUP BY brand_name
ORDER BY screen_size ASC
LIMIT 1

-- 7. Avg price of 5G phones vs avg price of non 5g phones 
SELECT has_5g, AVG(price) AS "avg_price"
FROM smartphones 
GROUP BY has_5g

-- 8. Group smartphone by the brand,and find the brand with 
--    the highest number of model that have both NFC and an IR blaster 

SELECT brand_name,count(*) AS "count"
FROM smartphones
WHERE has_nfc="True" and has_ir_blaster="True" 
GROUP BY brand_name 
ORDER BY count DESC
LIMIT 1

-- 9. find all samsung 5g enable smartphones and
--    find out the average price for NFC and Non-NFC

SELECT has_nfc, AVG(price) AS "avg_price"
FROM smartphones 
WHERE brand_name="samsung" and has_5g="True"
GROUP BY has_nfc

-- 10. Find the phone name,price of costlier phone
SELECT model, price 
FROM smartphones
ORDER BY price DESC LIMIT 1

-- -------------------HAVING Clause-------------------------------------
-- select -> where 
-- group by -> having 

-- 1. find the avg rating/price of smartphones brands which have 
--    more than 20 phones 

SELECT brand_name,
ROUND(AVG(price))  AS "avg_price",
COUNT(*) as "Count"
FROM smartphones 
GROUP BY brand_name
HAVING Count >20
ORDER BY avg_price DESC

SELECT brand_name,
ROUND(AVG(rating))  AS "avg_rating",
COUNT(*) as "Count"
FROM smartphones 
GROUP BY brand_name
HAVING Count >20
ORDER BY avg_rating DESC

-- 2. find the top 3 brands with the highest avg ram that
--    have a refresh rate of at least 90 Hz and fast charging availbe 
--    and dont consider brands which have less than 10 phones. 

SELECT * FROM smartphones 

SELECT brand_name, count(*) as "count", ROUND(AVG(ram_capacity)) as "avg_ram"
FROM smartphones 
WHERE fast_charging_available=1 and refresh_rate >=90
GROUP BY brand_name
HAVING count >= 10
ORDER BY avg_ram DESC
LIMIT 3

-- 3. find the avg price of all the phones brand with avg rating> 70 
--    and num_phones more than 10 among all 5g enable phones

SELECT brand_name, 
AVG(rating) AS "avg_rating",
count(*) AS "count"
FROM smartphones 
WHERE has_5g="True"
GROUP BY brand_name 
HAVING avg_rating> 70 and count>10

 