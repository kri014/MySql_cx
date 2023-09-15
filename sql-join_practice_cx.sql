-- 1. Find all the profitable orders 

SELECT t1.order_id, sum(t1.profit) AS "profit"
FROM flipkart.order_details t1
JOIN flipkart.orders t2
ON t1.order_id=t2.order_id
GROUP BY t1.order_id
HAVING profit> 0

-- 2. Find the customer who has place maximum orders

SELECT t2.name,count(*) AS "total_order" 
FROM flipkart.orders t1
JOIN  flipkart.users t2
ON t1.user_id=t2.user_id
GROUP BY t2.name
ORDER BY total_order DESC LIMIT 1

-- 3. Which is the most profitable category 
SELECT * FROM category
SELECT * FROM order_details 

SELECT t2.vertical, sum(profit) AS "profit" FROM flipkart.order_details t1
JOIN flipkart.category t2
ON t1.category_id=t2.category_id
GROUP BY t2.vertical
ORDER BY  profit DESC LIMIT 1

-- 4. Which is most profitable/loss  state

SELECT t3.state,sum(profit) AS "profit" 
FROM flipkart.order_details t1
JOIN flipkart.orders t2
ON t1.order_id=t2.order_id
JOIN flipkart.users t3
ON t2.user_id=t3.user_id
GROUP BY t3.state
ORDER BY profit DESC LIMIT 1

SELECT t3.state,sum(profit) AS "loss" 
FROM flipkart.order_details t1
JOIN flipkart.orders t2
ON t1.order_id=t2.order_id
JOIN flipkart.users t3
ON t2.user_id=t3.user_id
GROUP BY t3.state
ORDER BY loss ASC LIMIT 1

-- find the category with profit greater than 5000

SELECT t2.vertical, sum(profit) AS "profit" 
FROM flipkart.order_details t1
JOIN flipkart.category t2
ON t1.category_id=t2.category_id
GROUP BY t2.vertical
HAVING profit>3000
ORDER BY  profit 