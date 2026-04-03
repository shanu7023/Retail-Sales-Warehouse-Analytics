-- analyze sales performance over time

SELECT 
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customer,
    SUM(quantity) AS total_quantity
FROM
    fact_sales
WHERE
    order_date IS NOT NULL
GROUP BY order_year
ORDER BY order_year;

-- Sales by month and year

SELECT 
    YEAR(order_date) AS order_year,
    month(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customer,
    SUM(quantity) AS total_quantity
FROM
    fact_sales
WHERE
    order_date IS NOT NULL
GROUP BY order_year,order_month
ORDER BY order_year,order_month;



-- cumulative analysis
-- calculate the total sales per month and the running total of sales over time (adding each row's value to the sum of all the previous rows value)
-- and the moving average per month of sales over time


select order_year,order_month,total_sales, 
sum(total_sales) over (order by order_year,order_month) as running_total_sales,
round(avg(avg_price) over (order by order_year,order_month),0) as moving_avg_price from
(SELECT 
    YEAR(order_date) AS order_year,
    month(order_date) AS order_month,
        SUM(sales_amount) AS total_sales,
    avg(price) AS avg_price
FROM
    fact_sales
GROUP BY order_year,order_month
) x ;



-- performance analysis
-- Analyze the yearly performance of products by comparing each product's sales to both its average sales performance and the previous year's sales

with yearly_product_sales as (
SELECT 
    YEAR(f.order_date) as order_year, p.product_name, sum(f.sales_amount) as current_sales
FROM
    dim_products p
        JOIN
    fact_sales f ON f.product_key = p.product_key
    group by order_year , p.product_name)
    
    select order_year,product_name,current_sales ,
    avg(current_sales) over (partition by product_name ) as avg_sales,
    round(current_sales - avg(current_sales) over (partition by product_name ),0) as diff_avg,
    case when current_sales - avg(current_sales) over (partition by product_name ) > 0 then 'Above Average'
		when current_sales - avg(current_sales) over (partition by product_name ) < 0 then 'Below Average'
        else 'Average'
	end Average_Change
    from yearly_product_sales
    order by product_name,order_year;
    
-- to evaluate previous year from cureent year

with yearly_product_sales as (
SELECT 
    YEAR(f.order_date) as order_year, p.product_name, sum(f.sales_amount) as current_sales
FROM
    dim_products p
        JOIN
    fact_sales f ON f.product_key = p.product_key
    group by order_year , p.product_name)
    
    select order_year,product_name,current_sales ,
    avg(current_sales) over (partition by product_name ) as avg_sales,
    round(current_sales - avg(current_sales) over (partition by product_name ),0) as diff_avg,
    case when current_sales - avg(current_sales) over (partition by product_name ) > 0 then 'Above Average'
		when current_sales - avg(current_sales) over (partition by product_name ) < 0 then 'Below Average'
        else 'Average'
	end Average_Change,
    
    -- year-over-year-Analysis
   LAG(current_sales) over(partition by product_name order by order_year) as py_sales,
   current_sales - LAG(current_sales) over(partition by product_name order by order_year) as diff_py,
   case when current_sales -  LAG(current_sales) over(partition by product_name order by order_year) > 0 then 'Increase'
		when current_sales -  LAG(current_sales) over(partition by product_name order by order_year) < 0 then 'Decrease'
        else 'No Change'
	end py_Change
    
    from yearly_product_sales
    order by product_name,order_year;

-- part to whole analysis
-- which categories contribute the most to overall sales

with category_sales as 
(SELECT 
    p.category, sum(f.sales_amount) as total_sales
FROM
    dim_products p
        JOIN
    fact_sales f ON f.product_key = p.product_key
    group by category)
    
    select category,total_sales ,
    sum(total_sales) over() overall_sales,
	concat(round((total_sales/sum(total_sales) over() ) * 100,2),'%') as percentage_of_total
from category_sales
order by total_sales desc;

-- Data Segmentation
-- segment products into cost ranges and count how many products fall into each segment

with product_segment as 
(SELECT 
    product_key,product_name,cost,
    case when cost < 100 then 'Below 100'
     when cost between 100 and 500 then '100 - 500'
	 when cost between 500 and 1000 then '500 - 1000'
     else 'Above 1000'
     end cost_range
from dim_products)

select cost_range,count(product_key) as total_products from product_segment group by cost_range order by total_products desc;


/* group customers into three segments based on their spending behaviour:
   - VIP : customers with atleast 12 months of history and spending more than 5000
   - Regular : customers with atleast 12 months of history but spending 5000 or less
   - New : customers with a lifespan less than 12 months.
and find the total number of customers by each group */

with customer_spending as 
(select c.customer_key,sum(f.sales_amount) as total_spending,
min(order_date) as first_order,
max(order_date) as last_order,
timestampdiff(month,min(order_date),max(order_date)) as lifespan
from fact_sales f join dim_customers c on f.customer_key=c.customer_key
 group by c.customer_key )
 

select customer_segment,count(customer_key) as total_customers from (

 select customer_key,total_spending,lifespan,
 case when lifespan >= 12 and total_spending > 5000 then 'VIP'
	  when lifespan >= 12 and total_spending < 5000 then 'Regular'
      else 'New'
      end customer_segment
 from customer_spending ) t 
group by customer_segment order by total_customers desc;

