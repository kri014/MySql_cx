-- 1. Imported smartphone table 

-- 2. Select all columns
SELECT * FROM smartphones

-- 3. selecting few columns , order of columns could be anything
SELECT brand_name,model, price FROM smartphones
SELECT os, model, price FROM smartphones

-- 4. alias -> naming columns on output 
-- using AS 
SELECT os AS "Operating System", model, battery_capacity AS 'mAH' FROM smartphones

-- 5. creating expression using cols
-- calculating ppi for phones 

SELECT model,
SQRT(resolution_width*resolution_width+resolution_height*resolution_height)/screen_size AS "PPI"
from smartphones

-- calculating rating columns on scale of 10  
SELECT model, rating/10 AS "rating" FROM smartphones

-- 6. adding constants columns 
-- adding one columns name of type having item as smartphones 
SELECT model, "smartphone" AS "type" FROM smartphones 

-- 7. Distincts (unique) values from a cols

-- shows total brand of phones 
SELECT DISTINCT (brand_name) AS "All Brand" 
FROM smartphones

-- total brand in processor  
select DISTINCT (processor_brand) AS "all_processors" 
FROM smartphones 

select DISTINCT os AS "all_os" 
FROM smartphones 

-- Distincts combos

SELECT DISTINCT brand_name,processor_brand FROM smartphones 

-- 8. filter rows WHERE claues

-- find all samsung phones 
SELECT * FROM smartphones 
WHERE brand_name="samsung"

SELECT * FROM smartphones 
WHERE brand_name="apple"

SELECT * FROM smartphones 
WHERE price> 50000

-- 9. BETWEEN 
-- find the mobile in certain price range (10000,50000)

SELECT * FROM smartphones 
WHERE price> 10000 and price <50000

SELECT * FROM smartphones 
WHERE price between 10000 and 50000
-- find all phones with rating >80 and price <25000
SELECT * FROM smartphones 
WHERE rating> 80 AND price< 25000 AND processor_brand="snapdragon"

-- find all samsung phones with ram > 8GB
SELECT * FROM smartphones 
WHERE brand_name="samsung" and ram_capacity >8

-- find all samsung phones with snapdragon processor
SELECT * FROM smartphones 
where processor_brand ="snapdragon" AND brand_name="samsung"

-- find brands who sells phones with  price > 50000

SELECT DISTINCT (brand_name) as "all_brand"  FROM smartphones
WHERE price> 50000

-- 10. IN and NOT IN 
-- find all the brand where porcessor name "snapdragon" , "exynos","bionic"

SELECT DISTINCT brand_name FROM smartphones
WHERE processor_brand="snapdragon" 
OR processor_brand="exynos" OR processor_brand="bionic"

-- uning IN opertor 
SELECT * FROM smartphones 
WHERE processor_brand IN ("snapdragon","exynos","bionic")