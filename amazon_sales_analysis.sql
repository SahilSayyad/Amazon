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

select	* from amazon_sale_report limit 5;

select sum(Amount) as Total_sales
from amazon_sale_report
where order_status not like '%Cancelled%';

select order_status,count(*) as order_count
from amazon_sale_report
group by order_status
order by order_count desc;

select SKU,sum(Qty) as total_quantity
from amazon_sale_report
where order_status not like '%Cancelled%'
group by SKU
order by total_quantity desc
limit 10;

select ship_state,sum(Amount) as status_revenue
from amazon_sale_report
where order_status not like '%Cancelled%'
group by ship_state
order by status_revenue desc
limit 10;

select str_to_date(order_date,'%m-%d-%y') as order_year,sum(Amount) as daily_sale
from amazon_sale_report
where order_status not like '%Cancelled%'
group by order_year
order by order_year;

select Fulfilment,count(*) as toatl_orders,sum(Amount) as revenue
from amazon_sale_report
where order_status not like '%Cancelled%'
group by fulfilment;

select B2B,sum(Amount) as total_amount
from amazon_sale_report
where order_status not like '%Cancelled%'
group by B2B;

select str_to_date(order_date,'%m-%d-%y')as order_date,
Amount,
sum(Amount)over (order by str_to_date(order_date,'%m-%d-%y'))as cumulative_revenue
from amazon_sale_report
where order_status not like '%Cancelled%';

select
str_to_date(order_date,'%m-%d-%y')as order_date,
SKU,
sum(Qty)as total_quantity,
rank()over (partition by str_to_date(order_date,'%m-%d-%y')order by sum(Qty)desc) as daily_rank
from amazon_sale_report
where order_status not like '%Cancelled%'
group by order_date,SKU
order by daily_rank;