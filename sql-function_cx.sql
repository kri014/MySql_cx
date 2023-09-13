-- Inbuilt function 
-- 1. Aggregate Function  2. Scalar Function

-- Aggregate function 
-- 1. MAX/MIN
-- ** find the minimum and maximum price/ram_capacity
SELECT max(price) from smartphones
SELECT min(price) from smartphones
 
SELECT max(ram_capacity) FROM smartphones
SELECT min(ram_capacity) FROM smartphones
-- ** find the price of costlier samsung phone
 
SELECT max(price),model FROM smartphones
WHERE brand_name="samsung"

SELECT * FROM smartphones 
WHERE price=163980 and brand_name="samsung"

--  2. AVG
-- ** find avg rating/price of apple phones 

SELECT AVG(rating) FROM smartphones 
WHERE brand_name="apple" 

SELECT AVG(price) FROM smartphones 
WHERE brand_name="apple" 

-- 3. SUM
SELECT SUM(price) FROM smartphones


SELECT AVG(rating) FROM smartphones 
WHERE brand_name="oneplus" 


SELECT AVG(rating) FROM smartphones 
WHERE brand_name="samsung" 


-- 4. COUNT
-- ** find the number of oneplus phones 
SELECT COUNT(*) FROM smartphones 
WHERE brand_name="oneplus"

SELECT COUNT(*) FROM smartphones 
WHERE brand_name="apple"

-- 5. COUNT(DISTINCT)
-- ** find the no. of brands available

SELECT COUNT(DISTINCT (brand_name)) FROM smartphones

-- 6. STD/VARIANCE 
-- ** find std of screen sizes  
SELECT * FROM smartphones 
SELECT STD(screen_size) FROM smartphones 
SELECT VARIANCE(screen_size) FROM smartphones 

-- ----------------------------------------------------------------
-- 2. Scalar Function
-- 1. ABS- Absolute function
SELECT ABS(price-200000) AS "TEMP" FROM smartphones 
 
-- 2. ROUND
-- ** Round the PPI to 1 DECIMAL place 
SELECT model,
ROUND(SQRT(resolution_width*resolution_width+resolution_height*resolution_height)/screen_size,1) AS "PPI"
from smartphones

-- 3. CEIL/FLOOR
-- ** floor/ceil the rating 
SELECT CEIL(rating) FROM smartphones 
SELECT floor(rating) FROM smartphones 

-------------------------------------------------------------------
-- Practice Question 
-- ** Find the average battery capacity and the average primary rear 
-- camera resolution for all smartphones with 
-- a price greater than or equal to 100000 ** 

SELECT * FROM smartphones
 
SELECT ROUND(AVG(battery_capacity),1) AS "avg_barrery", ROUND(AVG(primary_camera_rear),1) AS "avg_canmera" 
FROM smartphones 
WHERE price >= 100000

-- ** Find the avearge internal memeory capicity of smartphones 
-- that have a refresh rate of 120Hz or higher and 
-- a front facing camera resolution graeter than or equal to 20 megapixel**

SELECT AVG(internal_memory) FROM smartphones
WHERE refresh_rate >120 and primary_camera_front > 20

-- ** find the number of smartphones with 5G capablity

SELECT COUNT(*) FROM smartphones
WHERE has_5G = "TRUE"
 