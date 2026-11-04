-- Assigned Sales Territory: Texas

-- Using the database and making sure it is the correct one.
USE sample_sales;
SELECT DATABASE();

-- Check tables I would need the information from
-- SELECT * FROM store_sales;
-- SELECT * FROM online_sales
-- WHERE ShiptoState = 'Texas';
-- SELECT * FROM store_locations sl
-- WHERE sl.State = 'Texas';
-- SELECT * FROM management;
-- SELECT * FROM inventory_categories;
-- SELECT * FROM inventory_subcategories;

-- What is total revenue overall for sales in the assigned territory, plus the start date and end date 
-- that tell you what period the data covers? 
SELECT SUM(ss.Sale_Amount) AS 'Total Revenue for Texas',
		MIN(ss.Transaction_Date) AS 'Start Date',
        MAX(ss.Transaction_Date) AS 'End Date'
FROM store_sales ss
JOIN store_locations sl
ON ss.Store_ID = sl.StoreID
WHERE sl.State = 'Texas';

-- test run in case the online orders are necessary to add
/*SELECT SUM(ss.Sale_Amount) AS 'Total Revenue for Texas',
		MIN(ss.Transaction_Date) AS 'Start Date',
        MAX(ss.Transaction_Date) AS 'End Date'
FROM store_sales ss
JOIN store_locations sl
ON ss.Store_ID = sl.StoreID
WHERE sl.State = 'Texas'
UNION ALL
SELECT SUM(SalesTotal) AS 'Total Online Sales',
		MIN(Date) AS 'Start Date',
        MAX(Date) AS 'End Date'
FROM online_sales
WHERE ShiptoState = 'Texas';
*/

-- Revenue breakdown by year and month for Texas
SELECT CONCAT('$', FORMAT(SUM(ss.Sale_Amount), 2)) AS 'Revenue',
		date_format(ss.Transaction_Date, '%M %Y') AS 'Month and Year'
FROM store_sales ss
JOIN store_locations sl
ON ss.Store_ID = sl.StoreID
WHERE sl.State = 'Texas'
GROUP BY date_format(ss.Transaction_Date, '%M %Y');



-- Comparison of total revenue for sales territory and the region it belongs to
-- Initially I wrote each state individually, but joining the manager table
-- erases the need for individual comparisons and serves to include any future territories in the area
SELECT SUM(ss.Sale_Amount) AS 'Total Revenue',
		sl.State AS 'State',
        m.Region AS 'Region'
FROM store_sales ss
JOIN store_locations sl
ON ss.Store_ID = sl.StoreID
JOIN management m
ON sl.State = m.State
WHERE m.Region = 'South'
GROUP BY sl.State, m.Region
ORDER BY SUM(ss.Sale_Amount) DESC;



-- What is the number of transactions per month?
/*
SELECT COUNT(*) AS 'Transactions', 
	date_format(ss.Transaction_Date, '%M, %Y') AS 'Month and Year'
FROM store_sales ss
JOIN store_locations sl
ON ss.Store_ID = sl.StoreID
WHERE sl.State = 'Texas'
GROUP BY date_format(ss.Transaction_Date, '%M, %Y')
ORDER BY date_format(ss.Transaction_Date, '%M, %Y');

SELECT COUNT(*) AS 'Transactions', 
	date_format(ss.Transaction_Date, '%M') AS 'Month'
FROM store_sales ss
JOIN store_locations sl
ON ss.Store_ID = sl.StoreID
WHERE sl.State = 'Texas'
GROUP BY date_format(ss.Transaction_Date, '%M')
ORDER BY date_format(ss.Transaction_Date, '%M');

-- What is the average transaction amount by product category for the sales territory?
SELECT ic.Category AS 'Product Category', 
		ROUND(AVG(ss.Sale_Amount), 2) AS 'Average Transaction Amount'
FROM store_sales ss
JOIN products p
ON ss.Prod_Num = p.ProdNum
JOIN inventory_categories ic
ON p.Categoryid = ic.Categoryid
GROUP BY ic.Category
ORDER BY ic.Category;
*/

-- SELECT date_format(ss.Transaction_Date, '%M, %Y') AS 'Month and Year',
-- 	COUNT(*) AS 'Transactions', 
--     ic.Category AS 'Product Category', 
-- 	ROUND(AVG(ss.Sale_Amount), 2) AS 'Average Transaction Amount'
-- FROM store_sales ss
-- JOIN store_locations sl
-- ON ss.Store_ID = sl.StoreID
-- JOIN products p
-- ON ss.Prod_Num = p.ProdNum
-- JOIN inventory_categories ic
-- ON p.Categoryid = ic.Categoryid
-- WHERE sl.State = 'Texas'
-- GROUP BY date_format(ss.Transaction_Date, '%M, %Y'), ic.Category
-- ORDER BY date_format(ss.Transaction_Date, '%M, %Y');


-- What is the number of transactions per month and average transaction amount by product 
-- category for the sales territory? 
SELECT YEAR(ss.Transaction_Date) AS 'Year', 
	MONTHNAME(ss.Transaction_Date) AS 'Month',
	COUNT(*) AS 'Transactions', 
    ic.Category AS 'Product Category', 
	ROUND(AVG(ss.Sale_Amount), 2) AS 'Average Transaction Amount'
FROM store_sales ss
JOIN store_locations sl
ON ss.Store_ID = sl.StoreID
JOIN products p
ON ss.Prod_Num = p.ProdNum
JOIN inventory_categories ic
ON p.Categoryid = ic.Categoryid
WHERE sl.State = 'Texas'
GROUP BY year(ss.Transaction_Date), month(ss.Transaction_Date), monthname(ss.Transaction_Date), ic.Category
ORDER BY year(ss.Transaction_Date), month(ss.Transaction_Date), monthname(ss.Transaction_Date);


-- SELECT date_format(ss.Transaction_Date, '%M') AS 'Month',
--     COUNT(*) AS 'Transactions',
--     ic.Category AS 'Product Category', 
-- 	ROUND(AVG(ss.Sale_Amount), 2) AS 'Average Transaction Amount'
-- FROM store_sales ss
-- JOIN store_locations sl
-- ON ss.Store_ID = sl.StoreID
-- JOIN products p
-- ON ss.Prod_Num = p.ProdNum
-- JOIN inventory_categories ic
-- ON p.Categoryid = ic.Categoryid
-- WHERE sl.State = 'Texas'
-- GROUP BY date_format(ss.Transaction_Date, '%M'), ic.Category
-- ORDER BY date_format(ss.Transaction_Date, '%M');



-- Can you provide a ranking of in-store sales performance by each store in the sales territory, or a
-- ranking of online sales performance by state within an online sales territory?
SELECT 	RANK()	OVER(ORDER BY SUM(ss.Sale_Amount) DESC) AS 'Rank',
		sl.StoreLocation AS 'Store',
        SUM(ss.Sale_Amount) AS 'Revenue'
FROM store_sales ss
JOIN store_locations sl
ON ss.Store_ID = sl.StoreID
WHERE sl.State = 'Texas'
GROUP BY sl.StoreLocation
ORDER BY SUM(ss.Sale_Amount) DESC;


-- What is your recommendation for where to focus sales attention in the next quarter?
/*
	A focus should be placed on Dallas so that it can match its fellow territories in terms of revenue
    We should try and see what Beaumont is doing differently since they are leading in revenue, and apply it to Dallas.
*/