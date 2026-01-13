--  1. Count the customer base based on customer type to identify current customer preferences and sort them in descending order.

 select Cust_TYPE,count(*) as total_customers from customer
group by Cust_TYPE
order by total_customers  desc;

-- 2. Count the customer base based on their status of payment in descending order.

 select PAYMENT_STATUS, count(*) as count_pay_stat from payment_details
group by PAYMENT_STATUS
order by count_pay_stat desc;

-- 3. Count the customer base based on their payment mode in descending order of count.

select PAYMENT_MODE , count(distinct C_ID) as count_paymode from payment_details
group by PAYMENT_MODE
order by count_paymode desc;

-- 4. Count the customers as per shipment domain in descending order.

select SH_DOMAIN, count(distinct C_ID) as count_domain from shipment_details
group by SH_DOMAIN
order by count_domain desc;

-- 5. Count the customer according to service type in descending order of count.

select SER_TYPE, count(distinct C_ID) as count_service from shipment_details
group by SER_TYPE
order by count_service desc;

-- 6. Explore employee count based on the designation-wise count of employees' IDs in descending order.

SELECT Emp_DESIGNATION, COUNT(Emp_ID) AS employee_count
FROM Employee_Details
GROUP BY Emp_DESIGNATION
ORDER BY employee_count DESC;

-- 7. Branch-wise count of employees for efficiency of deliveries in descending order.

SELECT Emp_BRANCH, COUNT(Emp_ID) AS employee_branchcount
FROM Employee_Details
GROUP BY Emp_BRANCH
ORDER BY employee_branchcount DESC;

-- 8. Finding C_ID, M_ID, and tenure for those customers whose membership is over 10 years.

with customer_tenure as 
(
select c.Cust_ID,m.M_ID, TIMESTAMPDIFF(year,START_DATE,END_DATE) as tenure from Membership M 
inner join 
customer c 
on 
c.M_ID=m.M_ID
)
select cust_Id,M_id, tenure from customer_tenure
where tenure>10
order by tenure desc;

-- **X customers** with >10yr membership
-- VIP segment for retention campaigns
-- Cross-sell premium services
-- Case study for customer success stories

-- 9. Considering average payment amount based on customer type having payment mode as COD in descending order.

select c.Cust_TYPE,
	   round(avg(p.AMOUNT),2) as average_payment
	    from payment_details p
join customer c 
	on p.C_ID=c.Cust_ID
where p.PAYMENT_MODE = 'COD'
group by c.Cust_TYPE 
order by average_payment desc;

-- 10. Calculate the average payment amount based on payment mode where the payment date is not null.

select PAYMENT_MODE	,
	    round(avg(AMOUNT),2) as average_payment from payment_details
       where PAYMENT_DATE is not null
       group by PAYMENT_MODE
       order by average_payment desc;


-- Comparing paid vs all payments


select PAYMENT_MODE	,
	   round(avg(case when PAYMENT_DATE is not null then amount end),2) as average_payment,
       round(avg(amount),2) as avg_all,
       count(case when PAYMENT_DATE is not null then 1 end) as paid_count
       from payment_details
       group by PAYMENT_MODE
       order by average_payment desc;
       
-- 11. Calculate the average shipment weight based on payment_status where shipment content does not start with "H."

select p.PAYMENT_STATUS, round(avg(s.SH_WEIGHT),2) as average_shpweight from shipment_details s
join 
payment_details p
on
s.SH_ID = p.SH_ID
where SH_CONTENT not like 'H%'
group by p.PAYMENT_STATUS
order by average_shpweight desc;

-- revenue per weight

select p.PAYMENT_STATUS,
round(avg(s.SH_WEIGHT),2) as average_shpweight,
round(avg(p.amount/nullif(s.SH_WEIGHT,0)),2) as revenue_per_kg 
from shipment_details s
join 
payment_details p
on
s.SH_ID = p.SH_ID
WHERE s.SH_CONTENT NOT LIKE 'H%'
GROUP BY p.PAYMENT_STATUS
ORDER BY average_shpweight DESC;

-- 12. Retrieve the names and designations of all employees in the 'NY' E_Branch.


select Emp_NAME,Emp_DESIGNATION from Employee_Details
where Emp_BRANCH = 'NY';

-- 13. Calculate the total number of customers in each C_TYPE (Wholesale, Retail, Internal Goods).(same as Q1)

select Cust_TYPE, count(*) as count_cust from customer
group by Cust_TYPE
order by count_cust desc;


-- 14. Find the membership start and end dates for customers with 'Paid' payment status.

SELECT 
    c.Cust_NAME,
    m.START_DATE,
    m.END_DATE,
    TIMESTAMPDIFF(YEAR, m.START_DATE, COALESCE(m.END_DATE, CURDATE())) AS tenure_years
FROM Membership m
JOIN customer c ON m.M_ID = c.M_ID
WHERE EXISTS (
    SELECT 1 
    FROM payment_details p 
    WHERE p.C_ID = c.Cust_ID 
      AND p.PAYMENT_STATUS = 'PAID'
)
ORDER BY c.Cust_NAME;

-- 15. List the clients who have made 'Card Payment' and have a 'Regular' service type.

select 
	c.Cust_NAME from customer c
    join payment_details p
    on
    c.Cust_ID = p.C_ID 
  join shipment_details s
  on
  p.SH_ID=s.SH_ID
  where s.SER_TYPE='regular' and p.PAYMENT_MODE='card payment';
  
  -- 16. Calculate the average shipment weight for each shipment domain (International and Domestic).
  
  select SH_DOMAIN , round(avg(SH_WEIGHT),2) as average_weight from shipment_details
  group by SH_DOMAIN
  order by average_weight desc;

-- 17. Identify the shipment with the highest charges and the corresponding client's name.

select s.SH_ID,c.Cust_NAME ,s.SH_CHARGES from customer c
join shipment_details s
on
c.Cust_ID=s.C_ID
order by s.SH_CHARGES desc
limit 1;

-- 18. Count the number of shipments with the 'Express' service type that are yet to be delivered.

select count(*) from shipment_details s
join status t
on
s.SH_ID = t.SH_ID
where s.SER_TYPE='Express' and t.Current_Status = 'Not delivered';

-- 19. List the clients who have 'Not Paid' payment status and are based in 'CA'

select c.Cust_NAME from customer c
join payment_details p
on
c.Cust_ID=p.C_ID
where p.PAYMENT_STATUS = 'NOT PAID'  and c.Cust_ADDR like '%CA%';

-- 20. Retrieve the current status and delivery date of shipments managed by employees with the designation 'Delivery Boy'

select s.Current_Status,s.Delivery_date from status s
join employee_manages_shipment e
on
s.SH_ID = e.Status_SH_ID
join Employee_Details ed
on e.Employee_E_ID=ed.Emp_ID
where ed.Emp_DESIGNATION ='Delivery boy'
order by s.Delivery_date desc;

-- 21. Find the membership start and end dates for customers whose 'Current Status' is 'Not Delivered'. 

select m.START_DATE , m.END_DATE , c.Cust_NAME from Membership m 
join customer c
on
m.M_ID = c.M_ID
join shipment_details s
on c.Cust_ID = s.C_ID
join status st
on
s.SH_ID=st.SH_ID
where st.Current_Status='NOT DELIVERED';

-- 22. Driver Performance Leaderboard

with performance as (

select e.Emp_NAME as name,
ems.Employee_E_ID as id,
 count(*) as total_shipments , 
count(case  when s.Current_Status='DELIVERED' then 1 end) as Delv_count ,
 avg(datediff(s.Delivery_date,s.Sent_date)) as avg_delvtime 
 from status s
join employee_manages_shipment ems
on
s.SH_ID = ems.Status_SH_ID
join Employee_Details e
on
ems.Employee_E_ID=e.Emp_ID
where e.Emp_DESIGNATION = 'Delivery Boy'
group by ems.Employee_E_ID,e.Emp_NAME
)

select name ,
id,
 total_shipments, 
(Delv_count*100)/total_shipments as percentage_delivered ,
avg_delvtime , 
rank()over( order by avg_delvtime asc) from performance
 where avg_delvtime is not null;

-- 23.Customer Lifetime Value by Cohort
-- date_format(p.PAYMENT_DATE,'%Y-%m'
with cte as 
(
select c.Cust_TYPE as TYPE ,
 sum(p.AMOUNT)  as revenue ,
year(p.PAYMENT_DATE) as payment_year,
count(distinct c.Cust_ID) as active_customers
 from customer c
join payment_details p
on
c.Cust_ID=p.C_ID
GROUP BY c.Cust_TYPE, YEAR(p.PAYMENT_DATE)

),
prev as 
(
select TYPE,
revenue,
payment_year,
active_customers,
lag(revenue)over(partition by TYPE order by payment_year ) as prev_year,
lag(active_customers)over(partition by TYPE order by payment_year) as prev_cust
 from cte
 )
select TYPE,
revenue,
payment_year,
round(((revenue- prev_year)*100)/prev_year,2) as yoy_growth,
round((active_customers*100)/Prev_cust,2) as ret_rate
from prev
where prev_year is not null
order by TYPE,payment_year ;













