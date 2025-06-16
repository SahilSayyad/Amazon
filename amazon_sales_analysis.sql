use amazon;
select count(*) from amazon_sale_report;

select distinct ship_state from amazon_sale_report;
SET SQL_SAFE_UPDATES=0;

alter table amazon_sale_report
rename column `Date` to order_date;

update amazon_sale_report
set ship_state=case
when ship_state="AR" then ship_state="Arunachal Pradesh"
else ship_state
end;

/*1. Total Revenue */
select sum(Amount) as Total_sales
from amazon_sale_report
where order_status not like '%Cancelled%';

/*2 Order By Status*/
select order_status,count(*) as order_count
from amazon_sale_report
group by order_status
order by order_count desc;

/*3 Top Selling Products by Quantity*/

select SKU,sum(Qty) as total_quantity
from amazon_sale_report
where order_status not like '%Cancelled%'
group by SKU
order by total_quantity desc
limit 10;

/*4 Revenue by State*/

select ship_state,sum(Amount) as status_revenue
from amazon_sale_report
where order_status not like '%Cancelled%'
group by ship_state
order by status_revenue desc
limit 10;

/*5 Daily Sales Trend*/

select str_to_date(order_date,'%m-%d-%y') as order_year,sum(Amount) as daily_sale
from amazon_sale_report
where order_status not like '%Cancelled%'
group by order_year
order by order_year;

/*6 Fulfilment Channel Analysis */


select Fulfilment,count(*) as toatl_orders,sum(Amount) as revenue
from amazon_sale_report
where order_status not like '%Cancelled%'
group by fulfilment;

/*7 B2B vs B2C Revenue*/

select B2B,sum(Amount) as total_amount
from amazon_sale_report
where order_status not like '%Cancelled%'
group by B2B;

/*8 Cumulative Revenue Over Time*/
select str_to_date(order_date,'%m-%d-%y')as order_date,
Amount,
sum(Amount)over (order by str_to_date(order_date,'%m-%d-%y'))as cumulative_revenue
from amazon_sale_report
where order_status not like '%Cancelled%';

/* 9 Ranking Top Products by Sales Per Day*/

select
str_to_date(order_date,'%m-%d-%y')as order_date,
SKU,
sum(Qty)as total_quantity,
rank()over (partition by str_to_date(order_date,'%m-%d-%y')order by sum(Qty)desc) as daily_rank
from amazon_sale_report
where order_status not like '%Cancelled%'
group by order_date,SKU
order by daily_rank;
