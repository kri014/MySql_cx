-- 1. UPDATE Query 
--  UPDATE query to update row(s)
-- we can change the item of the table with some given criteria 
-- ** find the smartphone with processor name mediatech 
--  and change its processor name to diffent name dimencity ** 

SELECT  * FROM smartphones
WHERE  processor_brand = "mediatek"

UPDATE smartphones
SET processor_brand = "dimencity"
WHERE processor_brand = "mediatek"

-- update in multiple columns 
-- update email and password in users table 
SELECT * FROM users

UPDATE users
SET email="ankit@gmail.com" , password="ydvf5652"
WHERE name= "ankit"

--------------------------------------------------------------------
-- 2. DELETE Query
-- ** delete all the phones price > 200000 which is act as outliers 

SELECT * FROM smartphones 
WHERE price>200000

DELETE FROM smartphones
WHERE price>200000

-- deletion with multiple condition 
-- ** delete the phone with rear camera more the 150 pixel 
--  and it is samsung phone **
SELECT * FROM smartphones 
WHERE primary_camera_rear >150 and brand_name ="samsung"

DELETE FROM smartphones 
WHERE primary_camera_rear >150 and brand_name ="samsung"