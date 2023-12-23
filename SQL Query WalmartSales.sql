-- 1. Data Wrangling: No null values in the dataset.

-- 2. Featuring engineering:
	--Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and Evening. This will help answer the question on which part of the day most sales are made.

	SELECT time,
	(CASE
		WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
		WHEN time BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
		ELSE 'Evening'
	END
	) AS time_of_day FROM Sales;
	

	--Add a new column named day_name that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri).
	--This will help answer the question on which week of the day each branch is busiest.

	SELECT DATENAME(WEEKDAY, date) AS day_name FROM Sales;

	--Add a new column named month_name that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar).
	--Help determine which month of the year has the most sales and profit.

	SELECT DATENAME(MONTH, date) AS month_name FROM Sales;

-- Add new columns to Sales table:

ALTER TABLE Sales ADD time_of_day VARCHAR(20), day_name VARCHAR(20), month_name VARCHAR(20);

UPDATE Sales
SET time_of_day = (CASE
		WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
		WHEN time BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
		ELSE 'Evening'
	END),
	day_name = DATENAME(WEEKDAY, date),
	month_name = DATENAME(MONTH, date);


-- 3. Generic Questions
--How many unique cities does the data have?
--In which city is each branch?

SELECT  DISTINCT City, Branch FROM Sales;

--Product
--How many unique product lines does the data have?

SELECT DISTINCT product_line FROM Sales;

--What is the most common payment method?
SELECT Payment, COUNT(*) AS Count FROM Sales
GROUP BY Payment
ORDER BY 2 DESC;

--What is the most selling product line?
SELECT product_line, COUNT(*) AS Count FROM Sales
GROUP BY Product_line
ORDER BY 2 DESC;

--What is the total revenue by month?
SELECT month_name, ROUND(SUM(total),2) AS revenue FROM Sales
GROUP BY month_name;


--What month had the largest COGS?
SELECT month_name, ROUND(SUM(cogs),2) AS cogs_total FROM Sales
GROUP BY month_name;

--What product line had the largest revenue?
SELECT Product_line, ROUND(SUM(total),2) AS revenue FROM Sales
GROUP BY Product_line
ORDER BY 2 DESC;

--What is the city with the largest revenue?
SELECT City, ROUND(SUM(total),2) AS revenue FROM Sales
GROUP BY City
ORDER BY 2 DESC;


--What product line had the largest VAT?

SELECT Product_line, ROUND(SUM(Tax_5),2) AS VAT FROM Sales
GROUP BY Product_line
ORDER BY 2 DESC;

--Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT Product_line, 
    (CASE 
        WHEN AVG(Quantity) > (SELECT AVG(Quantity) FROM Sales) THEN 'Good'
        ELSE 'Bad'
    END) AS Performance
FROM Sales
GROUP BY Product_line;

--Which branch sold more products than average product sold?
SELECT Branch, SUM(quantity) AS Qty FROM Sales
GROUP BY Branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM Sales);

--What is the most common product line by gender?
SELECT Product_line, gender, COUNT(*) FROM Sales
GROUP BY gender, product_line
ORDER BY 3 DESC;

--What is the average rating of each product line?
SELECT Product_line, ROUND(AVG(rating),2) AS Avg_rating FROM Sales
GROUP BY Product_line;


-- Sales
--Number of sales made in each time of the day per weekday
SELECT time_of_day, day_name, COUNT(*) AS Sales  FROM Sales
GROUP BY day_name, time_of_day
ORDER BY day_name

--Which of the customer types brings the most revenue?
SELECT Customer_type, SUM(total) AS revenue FROM Sales
GROUP BY Customer_type
ORDER BY 2 DESC;

--Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city, AVG(Tax_5) AS VAT FROM Sales
GROUP BY city
ORDER BY 2 DESC;

--Which customer type pays the most in VAT?
SELECT Customer_type, AVG(Tax_5) AS VAT FROM Sales
GROUP BY Customer_type
ORDER BY 2 DESC;


-- Customers
--How many unique customer types does the data have?
SELECT DISTINCT Customer_type FROM Sales;

--How many unique payment methods does the data have?
SELECT DISTINCT Payment FROM Sales;

--What is the most common customer type?
SELECT Customer_type, COUNT(customer_type) AS Count FROM Sales
GROUP BY Customer_type
ORDER BY 2 DESC;

--Which customer type buys the most?
SELECT Customer_type, COUNT(*) AS Count FROM Sales
GROUP BY Customer_type
ORDER BY 2 DESC;

--What is the gender of most of the customers?
SELECT gender, COUNT(*) AS Count FROM Sales
GROUP BY gender
ORDER BY 2 DESC;

--What is the gender distribution per branch?
SELECT branch, gender, COUNT(*) AS Count FROM Sales
GROUP BY Branch, gender
ORDER BY 1;

--Which time of the day do customers give most ratings?
SELECT time_of_day, COUNT(rating) AS RatingQty FROM Sales
GROUP BY time_of_day
ORDER BY 2 DESC;

--Which time of the day do customers give most ratings per branch?
SELECT branch, time_of_day, COUNT(rating) AS RatingQty FROM Sales
GROUP BY time_of_day, Branch
ORDER BY 1;

--Which day of the week has the best avg ratings?
SELECT day_name, AVG(rating) AS AverageRatings FROM Sales
GROUP BY day_name
ORDER BY 2 DESC;

--Which day of the week has the best average ratings per branch?
SELECT branch, day_name, AVG(rating) AS AverageRatings FROM Sales
GROUP BY day_name, branch
ORDER BY 1;