-- Global Electronics Retailers Dataset

-- Q. What types of products does the company sell, and where are customers located?
-- Q. Are there any seasonal patterns or trends for order volume or revenue?
-- Q. How long is the average delivery time in days? Has that changed over time?
-- Q. Is there a difference in average order value (AOV) for online vs. in-store sales?



-- Q. What types of products does the company sell, and where are customers located?

-- Type of Products the company sell

Select *
From dbo.Products$

Select DISTINCT(Brand) as brand, Count(Brand) as total_brand
From dbo.Products$
Group by brand
Order by total_brand DESC

Select Distinct(Category) as category, COUNT(Category) as total_category
From dbo.Products$
GROUP BY category
ORDER BY total_category desc

SELECT DISTINCT(Subcategory)as subcategory, COUNT(Subcategory) as total_subcategory
FROM dbo.Products$
GROUP BY subcategory
ORDER BY total_subcategory DESC

SELECT Brand, Category, Subcategory, COUNT(ProductKey) as total_product
FROM dbo.Products$
GROUP BY Brand, Category, Subcategory

-- Customers located

Select *
From dbo.Customers

Select Country, Continent, Count(CustomerKey) as Count
From dbo.Customers
Group BY Country, Continent;

Select City, Country, Count(CustomerKey) as total_customers
From dbo.Customers
GROUP BY City, Country

Select City,State, Country, Count(CustomerKey) as total_customers
From dbo.Customers
GROUP BY City, State, Country, Continent
Order By Country

-- Q. Are there any seasonal patterns or trends for order volume or revenue?

Select *
from dbo.Sales

-- Rename Column name
EXEC sp_rename 'dbo.Sales.Order Date','Order_date', 'COLUMN';
EXEC sp_rename 'dbo.Sales.Delivery Date','Delivery_date', 'COLUMN';
EXEC sp_rename 'dbo.Products$.Unit Price USD','Unit_Price_USD', 'COLUMN';
EXEC sp_rename 'dbo.Products$.Unit Cost USD','Unit_Cost_USD', 'COLUMN';

-- Total Order by Date
Select Order_date, SUM(Quantity) total_order
FROM dbo.Sales
GROUP BY Order_date
ORDER BY total_order DESC

-- Average Total Order by Date
WITH total_order_sales AS
(
Select Order_date, SUM(Quantity) total_order
FROM dbo.Sales
GROUP BY Order_date
)
SELECT AVG(total_order)
FROM total_order_sales

-- Total Order by Month
Select DATEPART(month, Order_date) as month_order, SUM(Quantity) total_order
FROM dbo.Sales
GROUP BY DATEPART(month, Order_date)
ORDER BY DATEPART(month, Order_date)

Select DATENAME(month, Order_date) as month_order, SUM(Quantity) total_order
FROM dbo.Sales
GROUP BY DATENAME(month, Order_date)
ORDER BY total_order DESC

-- Total Order by Year
Select DATEPART(year, Order_date) as month_order, SUM(Quantity) total_order
FROM dbo.Sales
GROUP BY DATEPART(year, Order_date)
ORDER BY DATEPART(year, Order_date)

ALTER TABLE dbo.Products$
ALTER COLUMN Unit_Price_USD float

--Total Revenue by Date
SELECT sal.Order_date, 
SUM(sal.Quantity) total_order, 
SUM(pro.Unit_Price_USD) total_income, 
SUM(pro.Unit_Cost_USD) total_cost, 
(SUM(pro.Unit_Price_USD)-SUM(pro.Unit_Cost_USD)) as total_revenue
FROM dbo.Sales as sal
INNER JOIN dbo.Products$ as pro
ON sal.ProductKey = pro.ProductKey
GROUP by sal.Order_date
ORDER BY total_income desc

-- Total Revenue by Month
SELECT DATEPART(month, sal.Order_date) as month, 
SUM(sal.Quantity) total_order, 
SUM(pro.Unit_Price_USD) total_income, 
SUM(pro.Unit_Cost_USD) total_cost, 
(SUM(pro.Unit_Price_USD)-SUM(pro.Unit_Cost_USD)) as total_revenue
FROM dbo.Sales as sal
INNER JOIN dbo.Products$ as pro
ON sal.ProductKey = pro.ProductKey
GROUP by DATEPART(month,sal.Order_date)
ORDER BY total_income desc

-- Total Revenue by Year
SELECT DATEPART(year, sal.Order_date) as month, 
SUM(sal.Quantity) total_order, 
SUM(pro.Unit_Price_USD) total_income, 
SUM(pro.Unit_Cost_USD) total_cost, 
(SUM(pro.Unit_Price_USD)-SUM(pro.Unit_Cost_USD)) as total_revenue
FROM dbo.Sales as sal
INNER JOIN dbo.Products$ as pro
ON sal.ProductKey = pro.ProductKey
GROUP by DATEPART(year,sal.Order_date)
ORDER BY total_income desc

-- Q. How long is the average delivery time in days? Has that changed over time?

--Delivery time by Date
Select Order_date, Delivery_Date, DATEDIFF(day, Order_date, Delivery_Date) as delivery_time
From dbo.Sales
Where Delivery_Date Like '%_%'

--Delivery time by month
WITH delivery_times AS
(
Select Order_date, Delivery_Date, DATEDIFF(day, Order_date, Delivery_Date) as delivery_time
From dbo.Sales
Where Delivery_Date Like '%_%'
)
SELECT DATEPART(month, Order_date) month_delivery,DATEPART(year, Order_date) year_delivery, AVG(delivery_time) avg_delivery
FROM delivery_times
Group BY DATEPART(month, Order_date), DATEPART(year, Order_date)
ORDER BY DATEPART(year, Order_date) 

--Delivery time by year
WITH delivery_times AS
(
Select Order_date, Delivery_Date, DATEDIFF(day, Order_date, Delivery_Date) as delivery_time
From dbo.Sales
Where Delivery_Date Like '%_%'
)
SELECT DATEPART(year, Order_date) year_delivery, AVG(delivery_time) avg_delivery
FROM delivery_times
Group BY DATEPART(year, Order_date)

-- Q. Is there a difference in average order value (AOV) for online vs. in-store sales?

SELECT StoreKey, 
SUM(sal.Quantity) total_order, 
SUM(pro.Unit_Price_USD) total_income, 
SUM(pro.Unit_Cost_USD) total_cost, 
(SUM(pro.Unit_Price_USD)-SUM(pro.Unit_Cost_USD)) as total_revenue
INTO aov
FROM dbo.Sales as sal
INNER JOIN dbo.Products$ as pro
ON sal.ProductKey = pro.ProductKey
GROUP by StoreKey

SELECT AVG(total_revenue/total_order) aov_online
FROM aov
WHERE StoreKey = 0

SELECT AVG(total_revenue/total_order) aov_in_store
FROM aov
WHERE StoreKey != 0

