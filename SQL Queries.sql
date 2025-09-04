

-- Q1: Show all transactions where Quantity > 5
SELECT * FROM OnlineRetail
WHERE Quantity > 5;

-- Q2: Find the total revenue (Quantity * UnitPrice)
SELECT SUM(Quantity * UnitPrice) AS TotalRevenue
FROM OnlineRetail;

-- Q3: List the top 5 products by sales quantity
SELECT Description, SUM(Quantity) AS TotalQuantity
FROM OnlineRetail
GROUP BY Description
ORDER BY TotalQuantity DESC
LIMIT 5;

-- Q4: Show the number of unique customers
SELECT COUNT(DISTINCT CustomerID) AS UniqueCustomers
FROM OnlineRetail;

-- Q5: Find the total revenue per country
SELECT Country, SUM(Quantity * UnitPrice) AS Revenue
FROM OnlineRetail
GROUP BY Country
ORDER BY Revenue DESC;

-- Q6: Find the monthly revenue trend
SELECT DATE_TRUNC('month', InvoiceDate) AS Month,
       SUM(Quantity * UnitPrice) AS MonthlyRevenue
FROM OnlineRetail
GROUP BY Month
ORDER BY Month;

-- Q7: List customers who spent more than £1000 in total
SELECT CustomerID, SUM(Quantity * UnitPrice) AS TotalSpent
FROM OnlineRetail
GROUP BY CustomerID
HAVING SUM(Quantity * UnitPrice) > 1000
ORDER BY TotalSpent DESC;

-- Q8: Find the top 5 countries by revenue
SELECT Country, SUM(Quantity * UnitPrice) AS Revenue
FROM OnlineRetail
GROUP BY Country
ORDER BY Revenue DESC
LIMIT 5;

-- Q9: Get the average order value (AOV) per customer
SELECT CustomerID, 
       SUM(Quantity * UnitPrice) / COUNT(DISTINCT InvoiceNo) AS AvgOrderValue
FROM OnlineRetail
GROUP BY CustomerID
ORDER BY AvgOrderValue DESC;

-- Q10: Find the most frequently purchased product per country
SELECT Country, Description, COUNT(*) AS PurchaseCount
FROM OnlineRetail
GROUP BY Country, Description
QUALIFY ROW_NUMBER() OVER (PARTITION BY Country ORDER BY COUNT(*) DESC) = 1;

-- Q11: RFM - Recency (last purchase date per customer)
SELECT CustomerID,
       MAX(InvoiceDate) AS LastPurchaseDate
FROM OnlineRetail
GROUP BY CustomerID;

-- Q12: Repeat purchase rate (customers who purchased more than once)
SELECT COUNT(DISTINCT CustomerID) * 100.0 / 
       (SELECT COUNT(DISTINCT CustomerID) FROM OnlineRetail) AS RepeatPurchaseRate
FROM (
    SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS Orders
    FROM OnlineRetail
    GROUP BY CustomerID
    HAVING COUNT(DISTINCT InvoiceNo) > 1
) t;

-- Q13: Identify the most returned products (negative quantities)
SELECT Description, SUM(Quantity) AS TotalReturns
FROM OnlineRetail
WHERE Quantity < 0
GROUP BY Description
ORDER BY TotalReturns ASC;

-- Q14: Cohort Analysis (month of first purchase vs returning customers)
WITH FirstPurchase AS (
    SELECT CustomerID, MIN(DATE_TRUNC('month', InvoiceDate)) AS CohortMonth
    FROM OnlineRetail
    GROUP BY CustomerID
),
CustomerOrders AS (
    SELECT o.CustomerID, DATE_TRUNC('month', o.InvoiceDate) AS OrderMonth, f.CohortMonth
    FROM OnlineRetail o
    JOIN FirstPurchase f ON o.CustomerID = f.CustomerID
)
SELECT CohortMonth, OrderMonth, COUNT(DISTINCT CustomerID) AS ActiveCustomers
FROM CustomerOrders
GROUP BY CohortMonth, OrderMonth
ORDER BY CohortMonth, OrderMonth;

-- Q15: Customer Lifetime Value (CLV)
SELECT CustomerID,
       SUM(Quantity * UnitPrice) AS LifetimeValue
FROM OnlineRetail
GROUP BY CustomerID
ORDER BY LifetimeValue DESC;
