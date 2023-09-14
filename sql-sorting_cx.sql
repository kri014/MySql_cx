-- Sorting Data --> ORDER BY ASC/DESC, LIMIT [offset,] row_count

-- 1. find top 5 samsung phones with biggest screen size
SELECT * FROM smartphones where brand_name="samsung"
ORDER BY screen_size DESC

SELECT model,screen_size 
FROM smartphones 
where brand_name="samsung"
ORDER BY screen_size DESC 
LIMIT 5

-- 2. sort all the phones with in decending order of number of 
--    total cameras
SELECT * FROM smartphones

SELECT model, num_rear_cameras + num_front_cameras AS "total_camera"
FROM smartphones 
ORDER BY total_camera DESC

-- 3. sort data on the basis of ppi in decreasing order
SELECT model,
ROUND(SQRT(resolution_width*resolution_width+resolution_height*resolution_height)/screen_size) AS "PPI"
FROM  smartphones
ORDER BY PPI DESC

-- 4. find the phone with 2nd largest battery
SELECT model,battery_capacity
FROM smartphones 
ORDER BY battery_capacity DESC 
LIMIT 1,1  -- LIMIT [offset,] row_count;

SELECT model,battery_capacity
FROM smartphones 
ORDER BY battery_capacity ASC 
LIMIT 1,1  -- lowest one 

-- 5. find the name and rating of the wrost rated apple phone

SELECT * FROM smartphones 

SELECT model, rating 
FROM smartphones 
WHERE brand_name="apple"
ORDER BY rating ASC
LIMIT 1

-- Sorting with the combinnation of two columns 
-- we can provide the order of sorting saprately 

-- 6. sort phones alphabatically and then on the 
--    basis of rating/price in desc order
SELECT * FROM smartphones 

SELECT * FROM smartphones 
ORDER BY brand_name ASC, rating ASC

SELECT * FROM smartphones 
ORDER BY brand_name ASC, price DESC