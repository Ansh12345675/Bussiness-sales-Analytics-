/*
    Run after 01_schema_and_seed.sql in SQL Server Management Studio.
    Each section is a read-only analysis query against dbo.Sales.
*/
USE SalesAnalyticsDemo;
GO

-- 1. Overall KPIs
SELECT
    SUM(Revenue) AS TotalRevenue,
    SUM(Profit) AS TotalProfit,
    COUNT(DISTINCT OrderID) AS Orders,
    COUNT(DISTINCT CustomerID) AS Customers,
    CAST(100.0 * SUM(Profit) / NULLIF(SUM(Revenue), 0) AS decimal(9, 2)) AS ProfitMarginPct
FROM dbo.Sales;

-- 2. Monthly revenue and profit
SELECT
    DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS MonthStart,
    SUM(Revenue) AS Revenue,
    SUM(Profit) AS Profit,
    COUNT(DISTINCT OrderID) AS Orders
FROM dbo.Sales
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY MonthStart;

-- 3. Regional performance
SELECT
    Region,
    SUM(Revenue) AS Revenue,
    SUM(Profit) AS Profit,
    COUNT(DISTINCT OrderID) AS Orders
FROM dbo.Sales
GROUP BY Region
ORDER BY Revenue DESC;

-- 4. Category performance and margin
SELECT
    Category,
    SUM(Quantity) AS UnitsSold,
    SUM(Revenue) AS Revenue,
    SUM(Profit) AS Profit,
    CAST(100.0 * SUM(Profit) / NULLIF(SUM(Revenue), 0) AS decimal(9, 2)) AS ProfitMarginPct
FROM dbo.Sales
GROUP BY Category
ORDER BY Revenue DESC;

-- 5. Top 10 products by revenue
SELECT TOP (10)
    ProductID,
    ProductName,
    SUM(Quantity) AS UnitsSold,
    SUM(Revenue) AS Revenue,
    SUM(Profit) AS Profit
FROM dbo.Sales
GROUP BY ProductID, ProductName
ORDER BY Revenue DESC, ProductName;

-- 6. Top 10 customers by lifetime revenue
SELECT TOP (10)
    CustomerID,
    CustomerName,
    COUNT(DISTINCT OrderID) AS Orders,
    SUM(Revenue) AS Revenue,
    SUM(Profit) AS Profit
FROM dbo.Sales
GROUP BY CustomerID, CustomerName
ORDER BY Revenue DESC, CustomerName;

-- 7. Repeat-customer summary
WITH CustomerOrders AS
(
    SELECT CustomerID, CustomerName, COUNT(DISTINCT OrderID) AS OrderCount,
           SUM(Revenue) AS Revenue
    FROM dbo.Sales
    GROUP BY CustomerID, CustomerName
)
SELECT
    COUNT(*) AS Customers,
    SUM(CASE WHEN OrderCount > 1 THEN 1 ELSE 0 END) AS RepeatCustomers,
    CAST(100.0 * SUM(CASE WHEN OrderCount > 1 THEN 1 ELSE 0 END)
         / NULLIF(COUNT(*), 0) AS decimal(9, 2)) AS RepeatCustomerPct,
    SUM(CASE WHEN OrderCount > 1 THEN Revenue ELSE 0 END) AS RepeatCustomerRevenue
FROM CustomerOrders;

-- 8. First-time customer counts by first purchase year
WITH FirstPurchase AS
(
    SELECT CustomerID, MIN(OrderDate) AS FirstOrderDate
    FROM dbo.Sales
    GROUP BY CustomerID
)
SELECT
    YEAR(FirstOrderDate) AS FirstPurchaseYear,
    COUNT(*) AS NewCustomers
FROM FirstPurchase
GROUP BY YEAR(FirstOrderDate)
ORDER BY FirstPurchaseYear;

-- 9. Discount bands and their sales/profit outcomes
SELECT
    CASE
        WHEN DiscountPct = 0 THEN N'0%'
        WHEN DiscountPct <= 0.05 THEN N'1-5%'
        WHEN DiscountPct <= 0.10 THEN N'6-10%'
        ELSE N'Over 10%'
    END AS DiscountBand,
    COUNT(*) AS SalesLines,
    SUM(Revenue) AS Revenue,
    SUM(Profit) AS Profit,
    CAST(100.0 * SUM(Profit) / NULLIF(SUM(Revenue), 0) AS decimal(9, 2)) AS ProfitMarginPct
FROM dbo.Sales
GROUP BY
    CASE
        WHEN DiscountPct = 0 THEN N'0%'
        WHEN DiscountPct <= 0.05 THEN N'1-5%'
        WHEN DiscountPct <= 0.10 THEN N'6-10%'
        ELSE N'Over 10%'
    END
ORDER BY MIN(DiscountPct);

-- 10. Payment method mix
SELECT
    PaymentMethod,
    COUNT(DISTINCT OrderID) AS Orders,
    SUM(Revenue) AS Revenue,
    CAST(100.0 * SUM(Revenue) / NULLIF(SUM(SUM(Revenue)) OVER (), 0) AS decimal(9, 2)) AS RevenueSharePct
FROM dbo.Sales
GROUP BY PaymentMethod
ORDER BY Revenue DESC;

-- 11. Sales channel comparison
SELECT
    SalesChannel,
    COUNT(DISTINCT OrderID) AS Orders,
    SUM(Revenue) AS Revenue,
    SUM(Profit) AS Profit,
    CAST(AVG(CAST(Revenue AS decimal(12, 2))) AS decimal(12, 2)) AS AverageLineRevenue
FROM dbo.Sales
GROUP BY SalesChannel
ORDER BY Revenue DESC;

-- 12. Best-performing states
SELECT TOP (10)
    State,
    Region,
    COUNT(DISTINCT OrderID) AS Orders,
    SUM(Revenue) AS Revenue,
    SUM(Profit) AS Profit
FROM dbo.Sales
GROUP BY State, Region
ORDER BY Revenue DESC;

-- 13. Average order value by customer segment
SELECT
    Segment,
    COUNT(DISTINCT OrderID) AS Orders,
    SUM(Revenue) AS Revenue,
    CAST(SUM(Revenue) / NULLIF(COUNT(DISTINCT OrderID), 0) AS decimal(12, 2)) AS AverageOrderValue
FROM dbo.Sales
GROUP BY Segment
ORDER BY AverageOrderValue DESC;
