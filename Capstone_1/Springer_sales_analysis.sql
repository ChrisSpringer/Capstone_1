-- Assigned Sales Territory: Texas

-- Using the database and making sure it is the correct one.
USE sample_sales;
SELECT DATABASE();

-- Total revenue overall for sales in the assigned territory, plus start and end dates
-- that tell you what period the data covers
-- I found what tables I would need the information from
SELECT * FROM store_sales;
SELECT * FROM online_sales
WHERE ShiptoState = 'Texas';
SELECT * FROM store_locations sl
WHERE sl.State = 'Texas';

-- there is a relationship for these two tables with the primary key StoreID 
-- Seeing what information the tables give when joined
SELECT * 
FROM store_sales ss
JOIN store_locations sl
ON ss.Store_ID = sl.StoreID
WHERE sl.State = 'Texas';

-- Finding the revenue using previous statements as a guidance
SELECT SUM(ss.Sale_Amount) AS 'Total Revenue for Texas',
		MIN(ss.Transaction_Date) AS 'Start Date',
        MAX(ss.Transaction_Date) AS 'End Date'
FROM store_sales ss
JOIN store_locations sl
ON ss.Store_ID = sl.StoreID
WHERE sl.State = 'Texas';

-- Total online revenue
SELECT SUM(SalesTotal) AS 'Total Online Sales'
FROM online_sales
WHERE ShiptoState = 'Texas';


-- Revenue breakdown by year and month for Texas
SELECT CONCAT('$', FORMAT(SUM(ss.Sale_Amount), 2)) AS 'Total Revenue in Texas',
		date_format(ss.Transaction_Date, '%M, %Y') AS 'Month and Year'
FROM store_sales ss
JOIN store_locations sl
ON ss.Store_ID = sl.StoreID
WHERE sl.State = 'Texas'
GROUP BY date_format(ss.Transaction_Date, '%M, %Y');


-- Comparison of total revenue for sales territory and the region it belongs to
SELECT SUM(ss.Sale_Amount) AS 'Total Revenue for Texas',
		sl.StoreLocation AS 'Territory'
FROM store_sales ss
JOIN store_locations sl
ON ss.Store_ID = sl.StoreID
WHERE sl.State = 'Texas'
GROUP BY sl.StoreLocation
ORDER BY sl.StoreLocation;

-- What is the number of transactions per month?
SELECT COUNT(ss.id) AS 'Transactions', 
	date_format(ss.Transaction_Date, '%M, %Y') AS 'Month and Year'
FROM store_sales ss
JOIN store_locations sl
ON ss.Store_ID = sl.StoreID
WHERE sl.State = 'Texas'
GROUP BY date_format(ss.Transaction_Date, '%M, %Y');

-- What is the average transaction amount by product category for the sales territory?
SELECT p.Product AS 'Product', 
		CAST(AVG(ss.Sale_Amount) AS DECIMAL(10,2)) AS 'Average Transaction Amount'
FROM store_sales ss
JOIN products p
ON ss.Prod_Num = p.ProdNum
GROUP BY p.Product
ORDER BY p.Product;

/*
SELECT p.Product AS 'Product', 
		SUM(ss.Sale_Amount) AS 'Transaction Amount',
        COUNT(ss.Sale_Amount) AS 'Count of all sales'
FROM store_sales ss
JOIN products p
ON ss.Prod_Num = p.ProdNum
GROUP BY p.Product
ORDER BY p.Product;
*/

-- Can you provide a ranking of in-store sales performance by each store in the sales territory, or a
-- ranking of online sales performance by state within an online sales territory?

SELECT SUM(ss.Sale_Amount) AS 'Total Revenue in Texas',
		sl.StoreLocation AS 'Territory'
FROM store_sales ss
JOIN store_locations sl
ON ss.Store_ID = sl.StoreID
WHERE sl.State = 'Texas'
GROUP BY sl.StoreLocation
ORDER BY COUNT(ss.Sale_Amount) DESC;


-- What is your recommendation for where to focus sales attention in the next quarter?
/*
	A focus should be placed on Dallas so that it can match its fellow territories in terms of revenue
    We should try and see what Beaumont is doing differently since they are leading in revenue, and apply it to Dallas.
*/