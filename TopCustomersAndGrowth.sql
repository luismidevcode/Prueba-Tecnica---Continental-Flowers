﻿
-- 1️ Obtener el total de ventas anuales por cliente
WITH AnnualTotals AS (
    SELECT CustomerID, SUM(Amount) AS TotalAmount
    FROM Sales
    WHERE SaleDate >= DATEADD(YEAR, -1, GETDATE()) -- Filtrar las ventas del último año
    GROUP BY CustomerID
),

-- 2️ Seleccionar los 10 clientes con mayores ventas en el último año
Top10 AS (
    SELECT TOP 10 CustomerID
    FROM AnnualTotals
    ORDER BY TotalAmount DESC -- Ordenar por ventas descendentes para tomar los de mayor volumen
),

-- 3️ Filtrar las ventas del último año solo para los clientes seleccionados en Top10
FilteredSales AS (
    SELECT * FROM Sales
    WHERE SaleDate >= DATEADD(YEAR, -1, GETDATE()) -- Filtrar ventas del último año
      AND CustomerID IN (SELECT CustomerID FROM Top10) -- Mantener solo los clientes seleccionados
),

-- 4️ Calcular las ventas mensuales por cliente
MonthlySales AS (
    SELECT
        CustomerID,
        FORMAT(SaleDate, 'yyyy-MM') AS Month, -- Convertir la fecha en formato año-mes
        SUM(Amount) AS TotalAmount
    FROM FilteredSales
    GROUP BY CustomerID, FORMAT(SaleDate, 'yyyy-MM')
),

-- 5️ Obtener el monto de ventas del mes anterior usando LAG()
MonthlyGrowth AS (
    SELECT
        CustomerID,
        Month,
        TotalAmount,
        LAG(TotalAmount) OVER (PARTITION BY CustomerID ORDER BY Month) AS PreviousAmount -- Obtener ventas del mes anterior
    FROM MonthlySales
)

-- 6️ Calcular el porcentaje de crecimiento de ventas mensual
SELECT
    CustomerID,
    Month,
    TotalAmount,
    CASE
        WHEN PreviousAmount IS NULL OR PreviousAmount = 0 THEN NULL -- Evitar errores en la división
        ELSE ROUND(((TotalAmount - PreviousAmount) * 100.0) / PreviousAmount, 2) -- Calcular porcentaje de crecimiento
    END AS GrowthPercentage
FROM MonthlyGrowth
ORDER BY CustomerID, Month;
