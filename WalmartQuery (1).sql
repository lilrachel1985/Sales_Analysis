--Exploratory Data Analysis
-- Altering the table to make the date in the correct format
ALTER TABLE [dbo].[WalmartSalesData]
ALTER COLUMN [Date] date

--Altering the tablle to make the time in the correct format 
ALTER TABLE [dbo].[WalmartSalesData]
ALTER COLUMN [Time] time(0)

-- Selecting and Viewing the entire sales table
SELECT * FROM dbo.WalmartSalesData; 

--Adding a new column as time_of_day which shows whether it is Morning, Afternoon or Evening.
SELECT 
     Time,
	 (CASE 
        WHEN Time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
		WHEN TIME BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening' END)
	 AS time_of_day
		 FROM dbo.WalmartSalesData;
 

ALTER TABLE WalmartSalesData ADD time_of_day VARCHAR(20);

UPDATE WalmartSalesData
SET time_of_day=(CASE 
		WHEN Time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
		WHEN Time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
	 END
	 );

-- Adding a new column named day_name that contains the extracted days of the week.
SELECT date,
       DATENAME(WEEKDAY,date)
FROM WalmartSalesData;

ALTER TABLE WalmartSalesData ADD day_name VARCHAR(10);

UPDATE WalmartSalesData
SET day_name=DATENAME(WEEKDAY,date);

-- Add a new column named month_name that contains the extracted months of the year
SELECT date,
       DATENAME(month,date)
FROM WalmartSalesData;

ALTER TABLE WalmartSalesData ADD month_name VARCHAR(10);

UPDATE WalmartSalesData
SET month_name=DATENAME(month,date);
--Business Analysis
--Unique Cities does the data have?
SELECT DISTINCT City
FROM WalmartSalesData;

--In which city is each branch?
SELECT DISTINCT City,
                Branch
FROM WalmartSalesData;

--Renaming a column name
EXEC sp_RENAME  'WalmartSalesData.Product line','product_line'


--unique product lines does the data have?
SELECT 
  COUNT(DISTINCT product_line)
FROM WalmartSalesData;
   
--What is the most common payment method?
SELECT 
  Payment,
  COUNT(Payment) AS count_payment
  FROM WalmartSalesData
  GROUP BY Payment
  ORDER BY count_payment DESC;

--What is the most selling product line?
SELECT 
  product_line,
  COUNT(product_line) AS count_product
  FROM WalmartSalesData
  GROUP BY product_line
  ORDER BY count_product DESC;

-- What is the total revenue by month?
SELECT 
    month_name AS month,
	SUM(total) AS total_revenue
FROM WalmartSalesData
GROUP BY month_name
ORDER BY total_revenue DESC;

--What month has the largest COGS
SELECT 
	month_name AS month,
	SUM(cogs) AS cogs
FROM WalmartSalesData
GROUP BY month_name
ORDER BY cogs DESC;

--Cogs correlated with revenue
--What product line has the largest revenue?

SELECT 
  product_line,
  SUM(Total) AS Total_revenue
  FROM WalmartSalesData
  GROUP BY product_line
  ORDER BY Total_revenue DESC;

--What is the city with the largest revenue?
SELECT 
  Branch,
  City,
  SUM(Total) AS Total_revenue
  FROM WalmartSalesData
  GROUP BY City,Branch
  ORDER BY Total_revenue DESC;

--Renaming Tax 5% as VAT
EXEC sp_RENAME  'WalmartSalesData.Tax 5%','VAT'

-- What product line has the largest VAT(Value Added Tax)
SELECT 
	product_line,
	AVG(VAT) as avg_tax
	FROM WalmartSalesData
	GROUP BY product_line
    ORDER BY avg_tax DESC;

--Which branch sold more products than average products sold?
SELECT 
      Branch,
	  SUM(Quantity) as qty
	  FROM WalmartSalesData
	  GROUP BY Branch
	  HAVING SUM(Quantity)>(SELECT AVG(Quantity) FROM WalmartSalesData);

--What is the most common product line by gender
SELECT 
      Gender,
	  product_line,
	  COUNT(Gender)as total_gender_cnt
	  FROM WalmartSalesData
	  GROUP BY Gender,product_line
      ORDER BY total_gender_cnt DESC;

--What is the average rating of each product line
SELECT ROUND(AVG(Rating),2) AS avg_rating,
product_line
FROM WalmartSalesData
GROUP BY product_line
ORDER BY avg_rating DESC;

------------------Sales Analysis-------------------------
--number of sales made in each time of the day per weekday
SELECT time_of_day,
COUNT(*) AS total_sales
FROM WalmartSalesData
WHERE day_name='Sunday'
GROUP BY time_of_day
ORDER BY total_sales DESC;

SELECT time_of_day,
COUNT(*) AS total_sales
FROM WalmartSalesData
WHERE day_name='Monday'
GROUP BY time_of_day
ORDER BY total_sales DESC;

SELECT time_of_day,
COUNT(*) AS total_sales
FROM WalmartSalesData
WHERE day_name='Tuesday'
GROUP BY time_of_day
ORDER BY total_sales DESC;

SELECT time_of_day,
COUNT(*) AS total_sales
FROM WalmartSalesData
WHERE day_name='Wednesday'
GROUP BY time_of_day
ORDER BY total_sales DESC;

SELECT time_of_day,
COUNT(*) AS total_sales
FROM WalmartSalesData
WHERE day_name='Thursday'
GROUP BY time_of_day
ORDER BY total_sales DESC;

SELECT time_of_day,
COUNT(*) AS total_sales
FROM WalmartSalesData
WHERE day_name='Friday'
GROUP BY time_of_day
ORDER BY total_sales DESC;

SELECT time_of_day,
COUNT(*) AS total_sales
FROM WalmartSalesData
WHERE day_name='Saturday'
GROUP BY time_of_day
ORDER BY total_sales DESC;

--Renaming Customer type to customer_type
EXEC sp_RENAME  'WalmartSalesData.Customer type','customer_type'

--Which of the customer types bring the most revenue?
SELECT
    customer_type,
	SUM(total) AS total_revenue
		FROM WalmartSalesData
		GROUP BY customer_type
		ORDER BY total_revenue DESC;

--Which city has the largest tax percent/VAT(Value Added Tax)?
SELECT 
    City,
	AVG(VAT) AS avg_vat
FROM WalmartSalesData
GROUP BY City
ORDER BY avg_vat DESC;

--Which customer type pays the most in VAT?
SELECT 
    customer_type,
	AVG(VAT) AS avg_vat
FROM WalmartSalesData
GROUP BY customer_type
ORDER BY avg_vat DESC;

------------Customer Analysis---------------------
---How many unique customer types does the data have?
SELECT DISTINCT(customer_type)
FROM WalmartSalesData;

---How many unique payment method does the data have?
SELECT DISTINCT(Payment)
FROM WalmartSalesData;

---What is the most common customer type?/Which customer type buys the most?
SELECT DISTINCT(customer_type),
        COUNT(*)AS customer_count
FROM WalmartSalesData
GROUP BY customer_type
ORDER BY customer_count DESC;

---What is gender of most of the customers?
SELECT Gender,
COUNT(*)As Gender_count
FROM WalmartSalesData
GROUP BY Gender
ORDER BY Gender_count DESC;

--What is the gender distribution per branch
SELECT Gender,
COUNT(*)As Gender_count
FROM WalmartSalesData
WHERE Branch='C'
GROUP BY Gender
ORDER BY Gender_count DESC;

SELECT Gender,
COUNT(*)As Gender_count
FROM WalmartSalesData
WHERE Branch='A'
GROUP BY Gender
ORDER BY Gender_count DESC;

SELECT Gender,
COUNT(*)As Gender_count
FROM WalmartSalesData
WHERE Branch='B'
GROUP BY Gender
ORDER BY Gender_count DESC;

---What time of the day do customers give most rating?
SELECT time_of_day,
AVG(Rating) AS avg_rating
FROM WalmartSalesData
GROUP BY time_of_day
ORDER BY avg_rating DESC;

--What time of day do customers give most ratings per branch?
SELECT time_of_day,
AVG(Rating) AS avg_rating
FROM WalmartSalesData
WHERE Branch='A'
GROUP BY time_of_day
ORDER BY avg_rating DESC;

SELECT time_of_day,
AVG(Rating) AS avg_rating
FROM WalmartSalesData
WHERE Branch='B'
GROUP BY time_of_day
ORDER BY avg_rating DESC;

SELECT time_of_day,
AVG(Rating) AS avg_rating
FROM WalmartSalesData
WHERE Branch='C'
GROUP BY time_of_day
ORDER BY avg_rating DESC;

--Which day of the week has the best avg rating?
SELECT 
day_name,
AVG(rating) AS avg_rating
FROM WalmartSalesData
GROUP BY day_name
ORDER BY avg_rating DESC;

--Which day of the week has the best average rating per branch ?
SELECT 
day_name,
AVG(rating) AS avg_rating
FROM WalmartSalesData
WHERE Branch='A'
GROUP BY day_name
ORDER BY avg_rating DESC;


SELECT 
day_name,
AVG(rating) AS avg_rating
FROM WalmartSalesData
WHERE Branch='B'
GROUP BY day_name
ORDER BY avg_rating DESC;

SELECT 
day_name,
AVG(rating) AS avg_rating
FROM WalmartSalesData
WHERE Branch='C'
GROUP BY day_name
ORDER BY avg_rating DESC;


--Revenue and Profit Calculations
COGS=unitprice * quantity
VAT= 5% *COGS
Total= VAT+COGS
Gross Profit= Total -COGS
Gross Margin=Gross Income/Total Revenue

