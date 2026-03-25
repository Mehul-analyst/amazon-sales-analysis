show tables ;
select * from amazon  ;


-- making the date format correct
select   str_to_date(order_date , "%Y-%m-%d")  from amazon  ;

update amazon
set order_date = str_to_date(order_date , "%Y-%m-%d") ;

-- done


select quarter(amazon.order_date) from amazon ;


alter table amazon
add column quarter varchar(5) ;

update amazon set
quarter = concat("Q",quarter(order_date)) ;


alter table amazon
add column monthname varchar(5) ;

select left(monthname(amazon.order_date),3) from amazon ;

update amazon set
monthname = left(monthname(order_date),3)


alter table amazon
add column year int  ;

update amazon
set year = year(order_date)  ;



alter table amazon
add column monthnumber int ;


CREATE TABLE DimMonth (
    MonthNumber INT PRIMARY KEY,
    MonthName VARCHAR(10)
);

INSERT INTO DimMonth VALUES
(1, 'Jan'), (2, 'Feb'), (3, 'Mar'), (4, 'Apr'),
(5, 'May'), (6, 'Jun'), (7, 'Jul'), (8, 'Aug'),
(9, 'Sep'), (10, 'Oct'), (11, 'Nov'), (12, 'Dec');

select * from dimmonth



show tables ;


-- total number of rows are same in database as in our csv file that states that are all data get imported without any problem

-- first checking whether any of the columns have null value for that we will first check are columns ;

desc amazon ;

SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END)          AS order_id,
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END)         AS order_date,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END)         AS product_id,
    SUM(CASE WHEN product_category IS NULL THEN 1 ELSE 0 END)   AS product_category,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END)              AS price,
    SUM(CASE WHEN discount_percent IS NULL THEN 1 ELSE 0 END)   AS discount_percent,
    SUM(CASE WHEN quantity_sold IS NULL THEN 1 ELSE 0 END)      AS quantity_sold,
    SUM(CASE WHEN customer_region IS NULL THEN 1 ELSE 0 END)    AS customer_region,
    SUM(CASE WHEN payment_method IS NULL THEN 1 ELSE 0 END)     AS payment_method,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END)             AS rating,
    SUM(CASE WHEN review_count IS NULL THEN 1 ELSE 0 END)       AS review_count,
    SUM(CASE WHEN discounted_price IS NULL THEN 1 ELSE 0 END)   AS discounted_price,
    SUM(CASE WHEN total_revenue IS NULL THEN 1 ELSE 0 END)      AS total_revenue
FROM amazon;

-- after seeing the result we are assured that there are no null values in the dataset

-- now we will check the duplicate order_id because that is the only thing which will pose an problem  ,
-- other coulumns can take the duplicate values .
select count(distinct (order_id)) , count(order_id ) from amazon ;
-- this gaurantees that there are now duplicate values


-- checking customer_region for the trim
select distinct customer_region,  case when length(customer_region) !=  length(trim(customer_region)) then 1 else 0 end as needoftrim from amazon ;
-- checking product_category for the trim
select distinct product_category ,  case when length(product_category) !=  length(trim(product_category)) then 1 else 0 end as needoftrim from amazon ;
-- checking payment_method for the trim
select distinct payment_method,  case when length(payment_method) !=  length(trim(payment_method)) then 1 else 0 end as needoftrim from amazon ;
-- this means there are no trailing spaces in the column values


-- verifying that the pregiven calculation is correct or not (it is correct )
select price , discount_percent , quantity_sold , discounted_price ,round( price - (discount_percent*price)/100 , 2 ) as true_discounted_price  , total_revenue  , round(round( price - (discount_percent*price)/100 , 2 )*quantity_sold,2) as t from amazon  ;

-- total revenue for  each financial year 2022 , 2023
select year(order_date) as financial_year , round(sum(total_revenue) , 0) as total from amazon group by financial_year  ;

-- month wise difference for both year 2022 and 2023
select year(order_date) as year  , month(order_date) as month , monthname(order_date) as month_name  , round(sum(total_revenue),0) as sum   from amazon group by year ,month_name,  month order by year, month  ;




-- part  1

-- 1) Total Sales
select round(sum(total_revenue),0) as total_revenue from amazon ;
select concat(round(round(sum(total_revenue),0)/1000000,2),"M") as total_revenue from amazon

-- 2) total number of orders
select count(order_id) as total_order_count from amazon ;

-- 3) Avg Order Value
select round(sum(total_revenue)/count(order_id),2) as average_order_value  from amazon ;

-- 4) Total Quantity Sold
select sum(quantity_sold) as total_quantity_sold from amazon ;

-- 5) most ordered product category

select product_category  , sum(quantity_sold) as total_count  from amazon  group by product_category order by total_count desc  limit 1  ;

-- 6) product category with highest revenue
select product_category , round(sum(total_revenue),0) as total  from amazon group by product_category order by total desc  limit 1 ;


-- 7) most ordered product id
select product_id , sum(amazon.quantity_sold) as sum , sum(total_revenue) as total  from amazon group by product_id order by sum desc limit 1;

-- 8) product with most revenue
select product_id , sum(amazon.quantity_sold) as sum , sum(total_revenue) as total  from amazon group by product_id order by total desc limit 1 ;

-- 9) least ordered product category

select product_category  , sum(quantity_sold) as total_count  from amazon  group by product_category order by total_count  asc limit 1  ;

-- 10) product category with least revenue
select product_category , round(sum(total_revenue),0) as total  from amazon group by product_category order by total asc limit 1 ;


-- 12) least ordered product
select product_id , sum(amazon.quantity_sold) as sum , sum(total_revenue) as total  from amazon group by product_id order by sum asc limit 1 ;

-- 13 )product with least  revenue
select product_id , sum(amazon.quantity_sold) as sum , sum(total_revenue) as total  from amazon group by product_id order by total asc  limit 1;



-- 14) Region with most order count

select customer_region , sum(quantity_sold)  as sum from amazon group by customer_region order by sum desc limit 1  ;

-- 15 ) region with most revenue

select customer_region , sum(total_revenue)  as sum from amazon group by customer_region order by sum desc limit 1 ;

-- 16) Region with least  order count

select customer_region , sum(quantity_sold)  as sum from amazon group by customer_region order by sum asc limit 1  ;

-- 17 ) region with most revenue

select customer_region , sum(total_revenue)  as sum from amazon group by customer_region order by sum asc limit 1 ;

select * from amazon

# select count(order_id) as total_row_count  from amazon ;
#
#
#
# select customer_region , round(sum(total_revenue),0) as total_per_region  from amazon group by customer_region order by total_per_region desc  ;
#
# -- Total revenue per region
#
# select payment_method , customer_region , round(sum(total_revenue),0) as total_sum from amazon group by payment_method, customer_region order by payment_method;
#
#
# -- revenue per payment method
#
# select  payment_method , concat(round(first *100 / sum(first) over() ,2) , ' %') as Percentage_distribution  from (select payment_method , round(sum(total_revenue),0) as first     from amazon group by payment_method ) as t ;
#
# -- revenue share % by method
#
# select customer_region , concat(" $ "  , round(sum(amazon.total_revenue)/count(customer_region),2) )as aov from amazon group by customer_region ;
#
# -- average order value
#
# select customer_region , count(customer_region ) as count_of_orders from amazon group by customer_region ;
#
#
# -- Total orders per region
# select payment_method , count(payment_method ) as count_of_orders from amazon group by  payment_method ;
#
#
# -- Orders per payment method
# select payment_method , count(payment_method ) as count_of_orders from amazon group by  payment_method order by count_of_orders desc  ;
#
# -- Payment method popularity (which method has most transactions)
# select customer_region , round(sum(amazon.total_revenue)  , 0) as total from amazon group by customer_region order by total desc   ;
#
#
# -- Which region generates the most revenue
# select customer_region , payment_method , count(order_id) as popularity from amazon group by customer_region, payment_method  order by customer_region , popularity desc  ;
#
#
# -- Which payment method is preferred in each region
# select customer_region , concat( round(total*100/ sum(total) over() , 2) , " %") as Percentage from (select customer_region , sum(amazon.total_revenue)  as total from amazon group by customer_region ) as t ;
#
#
#
#
#
#
# -- Revenue concentration — is one region/payment method dominating?
# select customer_region , payment_method , popularity from (select * , rank() over(partition by customer_region order by popularity desc ) as ranking  from (select customer_region , payment_method , count(order_id) as popularity from amazon group by customer_region, payment_method  order by customer_region , popularity desc ) as t ) as k where ranking = 1   ;
#
#
#
# Best performing region + payment method combo
# Underperforming combos (low revenue despite decent orders = low avg order value)
#
#
# -- Payment method consistency — does the top method change region to region or stay the same?
# select product_category , round(sum(amazon.total_revenue),0) as total  from amazon group by product_category order by total desc  ;
#
#
#
# -- Product & Category Analysis — you have product_category + product_id
#
# -- Which category generates the most revenue?
# select distinct (customer_region)from amazon  ;
# # Which category has the most quantity sold vs highest revenue (they may differ)
# # How many unique products per category?
# # Think: GROUP BY product_category
#
#
# select * from amazon ;
#
# select amazon.customer_region , round(sum(amazon.total_revenue )/1000000 , 2)
#       as sum_in_million  , count(order_id) from amazon group by customer_region  order by  sum_in_million desc ;
#
#
#
#
# select * , sum(sum) over(partition by customer_region) as total_region_sum  ,
#
#        sum(count) over(partition by customer_region) as total_region_order_count
# from (select customer_region , payment_method , round(sum(total_revenue),0) as sum  ,
#              count(payment_method) as count from amazon group by customer_region ,
#                                                                  payment_method order by customer_region , sum desc ) as t   ;





select * from amazon ;


select * from amazon ;





-- revenue  2022 / 2023


select * from amazon ;

select concat(round((sums - prev)*100/prev,2)  ," %") as percentage_change from (select  years, sums  , lead(sums) over(order by years desc ) as prev from (select year(order_date) as years  , round(sum(amazon.total_revenue)/1000000,2) as sums from amazon group by years order by years desc  ) as t  ) as k limit 1  ;




-- quarter analysis

with cte as (select *, lead(twenty_three) over (order by m ) as twenty_two
             from (select year(order_date)                       as y,
                          month(amazon.order_date)               as m,
                          round(sum(total_revenue) / 1000000, 2) as twenty_three
                   from amazon
                   group by y, m
                   order by m, y desc) as t
)
select *  , round((twenty_three - twenty_two)*100/twenty_two ,1) as change_of_percent_in_ from cte where y = 2023 ;





select year(order_date)  as y,
                          month(amazon.order_date)               as m,
                          round(sum(total_revenue) / 1000000, 2) as twenty_three
                   from amazon
                   where y = 2023 group by y, m order by y , m  ;






select customer_region  , avg(amazon.total_revenue) as avg  , count(order_id) as count_of_orderid , avg(amazon.total_revenue) * count(order_id) approx_revenue  from amazon  group by customer_region ;




select  product_category  , sum(amazon.total_revenue) as total , sum(quantity_sold) as k ,sum(amazon.total_revenue)/sum(quantity_sold) as ratio  from amazon group by product_category  order by ratio desc ;




select replace(product_category  , "oo" , 'cc') from amazon ;