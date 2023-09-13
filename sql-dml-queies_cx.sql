-- 1.  create data base 
CREATE DATABASE campus_x

-- 2. create table 
CREATE TABLE users(
     user_id INTEGER PRIMARY KEY AUTO_INCREMENT,
     name VARCHAR(255) NOT NULL,
     email VARCHAR(255) NOT NULL UNIQUE,
     password VARCHAR(255) NOT NULL

)
-- ----------------------------------------------
-- 3. Inserting values in the table
-- 3.a. Inserting only single row (and its varations)

INSERT INTO users(user_id,name, email, password) -- this is optional
values (null,"ankit","ankit@gmail","1234")

SELECT * FROM users

INSERT INTO users  
VALUES (null,"vihan","vihan@gmail.com","34536") -- order should be maintain 

INSERT INTO users (name,email) -- providing the seleted columns insertion 
values("tushar","tushar@gmail.com")

INSERT INTO users(user_id,email,name,password) -- order is not necessarily to insertion 
values(null,"sameer@gmail.com","sameer","457567")

-- 3.b. Inserting Multiple rows
INSERT INTO users values
(null,"rishab","rishabh@gmail.com","2456"),
(null,"kunal","kunal@gmail.com","455646"),
(null,"tarun","tarun@gmail.com","5r563rr")
 
SELECT * FROM users 
