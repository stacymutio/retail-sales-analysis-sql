create database sales_analysis;

use sales_analysis;
go 
select * from retail_sales;

--injecting the nulls--

begin transaction;
update retail_sales
set Total_Amount=null 
where Transaction_ID <=15;

update retail_sales
set Product_Category =null
where Age<=20;

--data cleaning--
update retail_sales
set Product_Category='unknown'
where Age<=20;

update retail_sales
set Total_Amount= (select AVG(total_amount)from retail_sales)
where total_amount is null;

with cte_duplicates as (
select *,
row_number() over
(partition by transaction_id,date 
order by transaction_id) as rownum
from retail_sales
)
delete from cte_duplicates
where rownum >1;

--analysis--
select
gender,
product_category,
count(transaction_id) as total_orders
from retail_sales
group by gender, product_category
order by total_orders desc,Gender;

select 
avg(age) as average_age,
product_category
from retail_sales
where product_category='electronics'
group by product_category;

select
Gender,
product_category,
sum(total_amount) as amount_spent
from retail_sales
group by Gender,Product_Category
order by amount_spent desc,Product_Category;

select
case 
when Age <30 then 'below 30'
when Age between 30 and 50 then 'middle aged'
when Age >50 then 'senior'
end as age_group,
sum(Total_Amount) as total_spent
from retail_sales
group by 
case
when age <30 then 'below 30'
when age between 30 and 50 then 'middle aged'
when age >50 then 'senior'
end
order by total_spent desc;

select top 3
Product_Category,
avg(Total_Amount) as average_amount
from retail_sales
group by product_category
order by average_amount desc;

select top 3
Product_Category,
avg(Total_Amount) as average_amount
from retail_sales
group by product_category
order by average_amount asc;

with daily_sales as (
select
date,
sum(total_amount) as daily_total
from retail_sales
group by date
)
select
date,
daily_total,
(select avg(daily_total)from daily_sales) as overall_daily_average,
daily_total-(select AVG(daily_total) from daily_sales) as variance
from daily_sales;

select
customer_id,
sum(total_amount) as total_spent,
COUNT(transaction_id) as purchase_frequency,
case 
when sum(total_amount)>1500 then 'vip customer'
when sum(total_amount)>=500 then 'regular customer'
else 'occassional customer'
end as customer_segment
from retail_sales
group by customer_id;


with rankedcustomers as (
select
Customer_ID,
Gender,
AVG(Total_Amount) as total_spent,
dense_rank()over(partition by gender order by avg(Total_Amount)desc) as customer_rank
from retail_sales
group by Gender,Customer_ID
)
select* 
from rankedcustomers
where customer_rank<=3;

select 
DATENAME(dw,date) as day_of_the_week,
sum(Total_Amount) as total_spent
from retail_sales
group by 
datename(dw,Date) ,datepart( dw,date) 
order by SUM(Total_Amount) desc;

select 
YEAR(Date) as sales_year,
DATENAME(MM,date) as sales_month,
sum(Total_Amount) as total_spent
from retail_sales
group by YEAR(date),DATENAME(mm,date),DATEPART(mm,date)
order by total_spent desc;

select 
count(distinct customer_id) as unique_customers
from retail_sales
where month(date)=5;

with monthlysales as (
select
year(date) as sales_year,
month(date) as sales_month,
sum(total_amount) as current_month_sales
from retail_sales
group by year(date),month(date)
)
select
sales_year,
sales_month,
current_month_sales,
lag(current_month_sales,1)over(order by sales_year,sales_month) as previous_month_sales,
(current_month_sales-lag(current_month_sales,1)over (order by sales_year,sales_month)) 
as sales_difference
from monthlysales;

select 
transaction_id,
customer_id,
total_amount
from retail_sales
where Total_Amount>(
select AVG(total_amount)
from retail_sales
);

--Views--
create view vw_salesdifference as
with monthlysales as (
select
year(date) as sales_year,
month(date) as sales_month,
sum(total_amount) as current_month_sales
from retail_sales
group by year(date),month(date)
)
select
sales_year,
sales_month,
current_month_sales,
lag(current_month_sales,1)over(order by sales_year,sales_month) as previous_month_sales,
(current_month_sales-lag(current_month_sales,1)over (order by sales_year,sales_month)) 
as sales_difference
from monthlysales;

create view vw_yearlysales as 
select 
YEAR(Date) as sales_year,
DATENAME(MM,date) as sales_month,
sum(Total_Amount) as total_spent
from retail_sales
group by YEAR(date),DATENAME(mm,date),DATEPART(mm,date)
;
create view vw_weeklysales as
select 
DATENAME(dw,date) as day_of_the_week,
sum(Total_Amount) as total_spent
from retail_sales
group by 
datename(dw,Date) ,datepart( dw,date) 
;

create view vw_customerrank as
with rankedcustomers as ( 
select
Customer_ID,
Gender,
AVG(Total_Amount) as total_spent,
dense_rank()over(partition by gender order by avg(Total_Amount)desc) as customer_rank
from retail_sales
group by Gender,Customer_ID
)
select* 
from rankedcustomers
where customer_rank<=3;

create view vw_dailysales as 
with daily_sales as (
select
date,
sum(total_amount) as daily_total
from retail_sales
group by date
)
select
date,
daily_total,
(select avg(daily_total)from daily_sales) as overall_daily_average,
daily_total-(select AVG(daily_total) from daily_sales) as variance
from daily_sales;

