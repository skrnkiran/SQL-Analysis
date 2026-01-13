use logistics_sql;

LOAD DATA LOCAL INFILE '/Users/saikiranbiradar/Downloads/archive-2/Membership.csv'
INTO TABLE Membership
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(M_ID, START_DATE, END_DATE);

SELECT COUNT(*) FROM Membership;
SELECT * FROM Membership LIMIT 10;

LOAD DATA LOCAL INFILE '/Users/saikiranbiradar/Downloads/Customer  .csv'
INTO TABLE Customer
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Cust_ID , M_ID, Cust_NAME, Cust_EMAIL_ID ,Cust_TYPE, Cust_ADDR , Cust_CONT_NO);

SELECT COUNT(*) FROM customer;
SELECT * FROM Customer LIMIT 10;

SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA LOCAL INFILE '/Users/saikiranbiradar/Downloads/archive-2/employee_manages_shipment.csv'
INTO TABLE Employee_Manages_Shipment
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Employee_E_ID, Shipment_SH_ID, Status_SH_ID);

SET FOREIGN_KEY_CHECKS = 1;

SELECT COUNT(*) FROM Employee_Manages_Shipment;
SELECT * FROM Employee_Manages_Shipment LIMIT 5;

DROP TABLE IF EXISTS Payment_Details;

CREATE TABLE Payment_Details (
  PAYMENT_ID     VARCHAR(36) PRIMARY KEY,  -- UUID
  C_ID           INT,
  SH_ID          INT,
  AMOUNT         DECIMAL(10,2),
  PAYMENT_STATUS VARCHAR(50),
  PAYMENT_MODE   VARCHAR(50),
  PAYMENT_DATE   DATE
);

SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA LOCAL INFILE '/Users/saikiranbiradar/Downloads/Payment_Details 2.csv'
INTO TABLE Payment_Details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(PAYMENT_ID, C_ID, SH_ID, AMOUNT, PAYMENT_STATUS, PAYMENT_MODE, @PAYMENT_DATE)
SET PAYMENT_DATE = IF(@PAYMENT_DATE = '', NULL, STR_TO_DATE(@PAYMENT_DATE, '%d/%m/%Y'));


SET FOREIGN_KEY_CHECKS = 1;

SELECT COUNT(*) FROM Payment_Details; 
SELECT * FROM Payment_Details LIMIT 5;

-- 2. Load data
SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA LOCAL INFILE '/Users/saikiranbiradar/Downloads/archive-2/Shipment_Details.csv'
INTO TABLE Shipment_Details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(SH_ID, C_ID, SH_CONTENT, SH_DOMAIN, SER_TYPE, SH_WEIGHT, SH_CHARGES, SR_ADDR, DS_ADDR);

SET FOREIGN_KEY_CHECKS = 1;


SELECT COUNT(*) FROM Shipment_Details;  -- Should be ~500
SELECT * FROM Shipment_Details LIMIT 5;

-- 1. Create table
DROP TABLE IF EXISTS Status;

CREATE TABLE Status (
  SH_ID          INT PRIMARY KEY,
  Current_Status VARCHAR(20),
  Sent_date      DATE,
  Delivery_date  DATE
);

-- 2. Load data (handles empty dates as NULL)
SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA LOCAL INFILE '/Users/saikiranbiradar/Downloads/archive-2/Status.csv'
INTO TABLE Status
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(SH_ID, Current_Status, @Sent_date, @Delivery_date)
SET 
  Sent_date = IF(@Sent_date = '', NULL, STR_TO_DATE(@Sent_date, '%m/%d/%Y')),
  Delivery_date = IF(@Delivery_date = '', NULL, STR_TO_DATE(@Delivery_date, '%m/%d/%Y'));

SET FOREIGN_KEY_CHECKS = 1;

 SELECT COUNT(*) FROM Status;  -- Should be ~500
SELECT * FROM Status LIMIT 5;

-- creating indexes

use logistics_sql;

CREATE INDEX idx_customer_mid ON customer(M_ID);
CREATE INDEX idx_ship_cid ON shipment_details(C_ID);
CREATE INDEX idx_status_shid ON status(SH_ID);
CREATE INDEX idx_pay_shid ON payment_details(SH_ID);
CREATE INDEX idx_ems_eid ON employee_manages_shipment(Employee_E_ID);
CREATE INDEX idx_ems_shid ON employee_manages_shipment(Shipment_SH_ID);














