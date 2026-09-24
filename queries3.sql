--importu duzgun edib etmediyimizi yoxlayiriq
Select *
from orders
limit 5;
Select *
from customers
limit 5;
Select *
from order_items
limit 5;
--Q1
Select order_id,customer_id,order_status,order_purchase_timestamp
from orders
where order_status="delivered" --where ile şert veririk ki ancaq catdirilmis olanlari gostersin
limit 10;
--Q2
with delivered_orders as (
select order_id,customer_id,order_purchase_timestamp
from orders
where order_status="delivered"
),
orders_with_customer as (
select o.order_id,o.customer_id,c.customer_unique_id,o.order_purchase_timestamp
from delivered_orders o
join customers c
on o.customer_id=c.customer_id  --ortaq sutun olan customer id ile iki cedveli bir birine baglayiriq belelikle her orderi sifaris edenin unique id si gorunecek
),
cohort_data as ( --her bir musterinin ilk sifaris tarixini tapiriq window func ile 
Select distinct customer_unique_id,strftime('%Y-%m',min(order_purchase_timestamp) over (partition by customer_unique_id)) as cohort_month
from orders_with_customer 
),
--Q3
activity as ( -- bununla ise her sifarisin hansi ayda bas verdiyine baxiriq
select distinct customer_unique_id,order_id,strftime('%Y-%m',order_purchase_timestamp) as order_month
from orders_with_customer
),
--Q4
customer_activity as ( -- indi ise cohort monthla order month i yan yana getiririk
select a.customer_unique_id,a.order_id,c.cohort_month,a.order_month
from activity a
join cohort_data c
on a.customer_unique_id=c.customer_unique_id
),
activity_with_period as ( 
SELECT customer_unique_id,order_id,cohort_month,order_month,
( -- strftime ile tarixden ili ve ayi cixardiriq, cast ile str leri integer e ceviririk,sifaris illerini cixib 12 ye vurub aya ceviririk daha sonra aylari cixib evvelki netice ile toplayiriq
(Cast(strftime('%Y',order_month || '-01') as INTEGER)-CAST(strftime('%Y',cohort_month || '-01') as INTEGER))*12
+ --belelikle period ferqini tapiriq
(CAST(strftime('%m',order_month || '-01') as INTEGER)-Cast(strftime('%m',cohort_month || '-01') as INTEGER))
) as period_time
from customer_activity
),
--Q5
retention_counts as ( --burda her cohort ve period ucun nece ferqli customer oldugunu hesabalyib matrix yaradiriq
select cohort_month,period_time,count(distinct customer_unique_id) as active_customers
from activity_with_period
group by cohort_month,period_time
),
--Q6
cohort_sizes as ( --cohort size period 0 daki musteri sayi demekdir buna gore de sertde period u 0 a beraberlesdiririk
select cohort_month,count(distinct customer_unique_id) as cohort_size
from activity_with_period
where period_time=0
group by cohort_month
),
--Q7
retention_rates as ( --retention i faiz olaraq gosteririk aktiv musterileri ilk perioddaki musteri sayina bolerek
select r.cohort_month,r.period_time,r.active_customers,c.cohort_size,
round(100.0*r.active_customers/c.cohort_size,1) as retention_rate
from retention_counts r
join cohort_sizes c
on r.cohort_month=c.cohort_month
),
--Q8
average_retention_curve as ( --burda her period uzre orta retention rate i tapiriq
SELECT period_time,round(avg(retention_rate),2) as avg_retention_rate
from retention_rates
group by period_time
order by period_time
),
--Q9
best_worst_cohort as ( --burda 1 ci periodda en yuksek ve en asagi rate li cohortlara baxiriq 
select cohort_month,retention_rate
from retention_rates
where period_time=1
order by retention_rate DESC
),
--Q10
order_revenue as ( --evvelce her mehsul ucun geliri tapiriq 
SELECT order_id,sum(price) as revenue
from order_items
group by order_id
)
select a.cohort_month,a.period_time,sum(r.revenue) as total_revenue
from activity_with_period a  -- daha sonra her cohort ve period uzre umumi geliri tapiriq
join order_revenue r
on a.order_id=r.order_id
group by a.cohort_month,a.period_time;