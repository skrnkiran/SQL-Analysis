CREATE DATABASE logistics_sql;
USE logistics_sql;

/*creating a table for membership*/
CREATE TABLE Membership (
M_ID INT PRIMARY KEY,
START_DATE DATE,
END_DATE DATE
);

/*creating a table for Employee_Details */

CREATE TABLE Employee_Details (
  Emp_ID         INT PRIMARY KEY,
  Emp_NAME       VARCHAR(100),
  Emp_BRANCH     VARCHAR(100),
  Emp_DESIGNATION VARCHAR(100),
  Emp_ADDR       VARCHAR(255),
  Emp_CONT_NO    VARCHAR(20)
);

/*creating a table for Customer */

CREATE TABLE Customer (
  Cust_ID          INT PRIMARY KEY,
  Cust_NAME        VARCHAR(100),
  Cust_EMAIL_ID    VARCHAR(150),
  Cust_CONT_NO     VARCHAR(20),
  Cust_ADDR        VARCHAR(255),
  Cust_TYPE        VARCHAR(50),
  M_ID  INT,
  CONSTRAINT fk_customer_membership
    FOREIGN KEY (M_ID) REFERENCES Membership(M_ID)
);

/*creating a table for Shipment_Details */


CREATE TABLE Shipment_Details (
  SH_ID            INT PRIMARY KEY,
  SH_CONTENT       VARCHAR(100),
  SH_DOMAIN        VARCHAR(20),
  SER_TYPE          VARCHAR(20),
  SH_WEIGHT        DECIMAL(10,2),
  SH_CHARGES       DECIMAL(10,2),
  SR_ADDR          VARCHAR(255),
  DS_ADDR          VARCHAR(255),
  C_ID INT NOT NULL,
  CONSTRAINT fk_shipment_customer
    FOREIGN KEY (C_ID) REFERENCES Customer(Cust_ID)
);
 
 /*creating a table for Status */
 
 CREATE TABLE Status (
  Status_ID     INT PRIMARY KEY AUTO_INCREMENT,
  CURRENT_ST    VARCHAR(50),
  SENT_DATE     DATE,
  DELIVERY_DATE DATE,
  SH_ID         INT NOT NULL,
  CONSTRAINT fk_status_shipment
    FOREIGN KEY (SH_ID) REFERENCES Shipment_Details(SH_ID)
);


 /*creating a table for Payment_Details*/
 
 CREATE TABLE Payment_Details (
  PAYMENT_ID           INT PRIMARY KEY,
  AMOUNT               DECIMAL(10,2),
  PAYMENT_STATUS       VARCHAR(50),
  PAYMENT_DATE         DATE,
  PAYMENT_MODE         VARCHAR(50),
  SH_ID       INT NOT NULL,
  C_ID INT NOT NULL,
  CONSTRAINT fk_payment_shipment
    FOREIGN KEY (SH_ID) REFERENCES Shipment_Details(SH_ID),
  CONSTRAINT fk_payment_customer
    FOREIGN KEY (C_ID) REFERENCES Customer(Cust_ID)
);

 /*creating a table for Employee_Manages_Shipment*/
 
 CREATE TABLE Employee_Manages_Shipment (
  Employee_E_ID  INT NOT NULL,
  Shipment_SH_ID INT NOT NULL,
  Status_SH_ID   INT NOT NULL,
  PRIMARY KEY (Employee_E_ID, Shipment_SH_ID, Status_SH_ID),
  CONSTRAINT fk_ems_employee
    FOREIGN KEY (Employee_E_ID) REFERENCES Employee_Details(Emp_ID),
  CONSTRAINT fk_ems_shipment
    FOREIGN KEY (Shipment_SH_ID) REFERENCES Shipment_Details(SH_ID)
  
);








