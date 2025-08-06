-- SQL Reatail Sales Analysis - P1 
create database sql_project_p2;

-- Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,	
		customer_id	INT,
		gender VARCHAR(15),
		age	INT,
		category VARCHAR(15),	
		quantiy	INT,
		price_per_unit FLOAT,	
		cogs FLOAT,
		total_sale FLOAT
	);

SELECT * FROM retail_sales
LIMIT 10;

SELECT 
	COUNT(*) 
FROM retail_sales

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE customer_id IS NULL

SELECT * FROM retail_sales
WHERE gender IS NULL

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- 
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Data Exploration

-- How Many Sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How Many Unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

SELECT DISTINCT category FROM retail_sales

-- Data Analysis and Business Key Problems & Answers

-- Q-1 write sql query to retrieve all columns for sale made on '2022-11-05'

SELECT * 
FROM retail_sales
where sale_date = '2022-11-05';

-- Q-2 write sql query to retrieve all transactions where the category is 'clothing' 
-- and quantity sold is more than 4 in the november - 2022

SELECT 
 *
FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
	AND 
	quantiy >=4;

-- Q-3 write a query to calculate the total sales (total_sale) for each category.

SELECT
	category,
	SUM(total_sale) as net_sale,
	COUNT(total_sale) as total_orders
FROM retail_sales
GROUP BY category;
	
-- Q-4 write a sql query to to find the average age of customer who purchased items from 'Beauty' category.

SELECT 
	ROUND(AVG(age),2) as Avg_AGE
FROM retail_sales
WHERE category = 'Beauty'


-- Q-5 write a query to find all transaction where the total_sale is greater then 1000.

select transactions_id,sale_date,customer_id,category,total_sale from retail_sales
where total_sale>1000;

-- Q-6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender 
-- in each category

select 
	category,gender,
	count(*) as total_transaction
From retail_sales
Group by category, gender
order by category

--Q-7 Write a SQL query to calculate the average sale for each month. 
--Find out best selling month in each year:

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

--Q-8  Write a SQL query to find the top 5 customers based on the highest total sales 

select
	customer_id,
	SUM(total_sale) as total_sales
from retail_sales
group by customer_id
order by SUM(total_sale) DESC
LIMIT 5

-- Q-9 Write a SQL query to find the number of unique customers who purchased items from each category


select
	category,
	COUNT(DISTINCT customer_id) as Count_Unique_Customer
from retail_sales
group by category

-- Q-10 Write a SQL query to create each shift and number of orders 
-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH Hourly_sale
as
(
	select *,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END as shift
	From retail_sales
)
Select 
	shift,
	COUNT(transactions_id) as total_orders
from hourly_sale
group by shift

---SELECT EXTRACT(MINUTE FROM CURRENT_TIME)

-- END OF PROJECTS
