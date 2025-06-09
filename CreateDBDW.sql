-- Crear la base de datos
CREATE DATABASE ContinentalSalesDB;
GO

-- Usar la base de datos
USE ContinentalSalesDB;
GO

-- Tabla de clientes (para hacer el enriquecimiento)
CREATE TABLE dbo.Customers (
    CustomerCode NVARCHAR(50) PRIMARY KEY,
    CustomerName NVARCHAR(100)
);

-- Insertar algunos clientes de prueba
INSERT INTO dbo.Customers (CustomerCode, CustomerName) VALUES
('CUST001', 'Florería Rosa Linda'),
('CUST002', 'Flores del Valle'),
('CUST003', 'Jardín Eterno');

-- Tabla de staging donde se cargan las órdenes desde el CSV
CREATE TABLE dbo.StagingOrders (
    OrderID NVARCHAR(50) PRIMARY KEY,
    CustomerCode NVARCHAR(50),
    ProductCode NVARCHAR(50),
    OrderDate DATE,
    Quantity INT,
    UnitPrice DECIMAL(18, 2),
    TotalAmount AS (Quantity * UnitPrice) PERSISTED,
    LoadDate DATETIME DEFAULT GETDATE()
);

-- Tabla de control para archivos ya cargados
CREATE TABLE dbo.LoadedFiles (
    FileID INT IDENTITY(1,1) PRIMARY KEY,
    FileName NVARCHAR(255) NOT NULL,
    FileLoadDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_FileName UNIQUE (FileName)
);

-- Tabla final donde se cargan las órdenes válidas, enriquecidas
CREATE TABLE dbo.FactSales (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID NVARCHAR(50),
    CustomerCode NVARCHAR(50),
    CustomerName NVARCHAR(100),
    ProductCode NVARCHAR(50),
    OrderDate DATE,
    Quantity INT,
    UnitPrice DECIMAL(18,2),
    TotalAmount DECIMAL(18,2),
    LoadDate DATETIME DEFAULT GETDATE()
);
