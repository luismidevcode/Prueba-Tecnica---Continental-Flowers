![LogoContinental](https://www.continentalflowers.com/images/logo.png)

# Prueba-Técnica-Continental-Flowers

---

## PARTE 1 - TEÓRICA

### ¿Cuál de las siguientes opciones representa el uso adecuado de `using` en C# para manejar una conexión a base de datos?
**R//** C) `using (var conn = new SqlConnection()) { conn.Open(); /* uso */ }`

### ¿Cuál de las siguientes opciones representa una buena práctica para consumir APIs REST en C#?
**R//** A) Usar `HttpClient` y reusarlo globalmente.

### ¿Cuál es la forma correcta de enviar un objeto en formato JSON en una solicitud HTTP POST usando JavaScript (AJAX)?
**R//** C) `fetch(url, { method: 'POST', body: JSON.stringify(myObject), headers: { 'ContentType': 'application/json' } });`

### ¿Cuál es la función principal de un paquete SSIS?
**R//** C) Extraer, transformar y cargar datos (ETL).

### ¿Cuál es la ventaja de implementar una arquitectura basada en servicios (SOA o microservicios) sobre una monolítica?
**R//** C) Mejor escalabilidad, despliegue independiente y mantenimiento modular.

---

## PARTE 2 - PRÁCTICA

### EJERCICIO 1: Modelado + Consulta SQL

**Objetivo**: Obtener los 10 clientes con mayor monto de compra en el último año y calcular el porcentaje de crecimiento mensual por cliente.

**Consulta SQL incluida en el archivo**: `TopCustomersAndGrowth.sql`

#### Explicación:

La consulta está compuesta por dos partes principales:

1. **Top 10 Clientes del último año**: Se agrupa por `CustomerID`, se suma el `Amount` y se filtra por el último año (`GETDATE() - 1 año`).

2. **Crecimiento mensual**: Se utiliza una CTE con `ROW_NUMBER()` o `LAG()` (dependiendo del enfoque) para calcular el `GrowthPercentage` comparado con el mes anterior.

#### Bonus: Optimización

Para entornos con millones de registros:

1. Materializar una vista donde se agrupen las ventas mensuales (Agregada Mensual) se puede utilizar un Trigger o un SP que actualice los datos.
2. Crear particiones de la tabla por año, si se requiere solo el último año.
3. Crear un índice entre `CustomerID` y `SalesDate` para mejorar las agrupaciones y el filtrado.
4. Agregarle una clave primaria a la tabla de `Sales`, directamente no optimiza la consulta con un gran volumen de datos, sin embargo da estructura e identifica cada registro.

---

### EJERCICIO 2: API REST en .NET 8

**Objetivo**: Crear una API REST que reciba facturas, las valide y almacene temporalmente en memoria. Permitir su consulta por cliente ordenada por fecha.

#### Tecnologías usadas:

- .NET 8  
- AutoMapper  
- DTOs para entrada y salida  
- Almacenamiento simulado en memoria con lista estática (`List<Invoice>`)

#### Archivos clave:

- `Controllers/InvoicesController.cs`
- `Models/Invoice.cs`
- `DTOs/InvoiceCreateDto.cs`, `InvoiceReadDto.cs`
- `Services/InvoiceService.cs`
- `Mapping/MappingProfile.cs`

#### Prueba y documentación en Swagger

- Documento PDF incluido: `Swagger UI InvoiceAPI.pdf`

#### Cómo ejecutar:

```bash
dotnet restore
dotnet run
```
### EJERCICIO 3: Ejercicio Práctico de SSIS

**Objetivo**: Construir un paquete SSIS que importe diariamente órdenes de venta desde un archivo `.csv`, las valide, enriquezca con datos de clientes y cargue el resultado final en una tabla de hechos (`FactSales`).

#### Tecnologías usadas:

- SQL Server Integration Services (SSIS)
- SQL Server 2022
- Archivos planos CSV como fuente externa
- Data Flow Task
- Componentes: Merge Join, Sort, Derived Column, OLE DB Destination
- Uso de variables y parámetros de paquete

#### Flujo del proceso:

1. **Validación de carga**  
   Se verifica que el archivo no haya sido cargado previamente (por nombre), usando la tabla `LoadedFiles`.

2. **Carga a Staging**  
   El archivo `.csv` se carga en la tabla temporal `StagingOrders`, que se trunca antes de cada nueva carga para evitar duplicados.

3. **Enriquecimiento de datos**  
   Se hace un `Merge Join` entre las órdenes y la tabla `dbo.Customers` para agregar el nombre del cliente a cada orden.

4. **Carga final**  
   Se insertan los datos enriquecidos en la tabla final `FactSales`.

5. **Carga del nombre del archivo**  
   Se carga el nombre del archivo en la tabla `LoadedFiles` para evitar recargas del mismo archivo, lo cual podría generar registros duplicados.

#### Componentes clave del paquete SSIS:

- `Execute SQL Task` para truncar `StagingOrders` y validar si el archivo ya fue procesado.
- `Data Flow Task` con origen plano, transformaciones y carga a destino.

- **Parámetros:**
  - `RutaArchivoParam`: Ruta completa del archivo `.csv`

- **Variables de paquete:**
  - `RutaArchivo`: Referencia a `RutaArchivoParam`
  - `ArchivoYaCargado`: Resultado de la validación
  - `NombreArchivo`: Calcula el nombre del archivo teniendo en cuenta la ruta

- Control de flujo condicional para evitar cargas duplicadas.

#### Base de datos de pruebas

Para facilitar la ejecución del paquete, se creó una base de datos llamada `ContinentalSalesDB`. Esta base incluye:

- `Customers`: Clientes para enriquecer los datos.
- `StagingOrders`: Tabla staging donde se carga el archivo CSV.
- `LoadedFiles`: Tabla de control de archivos ya cargados.
- `FactSales`: Tabla final con datos validados y enriquecidos.

📄 Se adjunta el script de creación de la base de datos de prueba: `CreateDBDW.sql`

#### Cómo ejecutar:

```bash
# Paso 1: Crear la base de datos y tablas
Ejecutar scripts/CreateDBDW.sql en SQL Server

# Paso 2: Abrir el proyecto SSIS en Visual Studio

# Paso 3: Configurar el parámetro RutaArchivoParam con la ruta del archivo DailyOrders.csv

# Paso 4: Ejecutar el paquete SSIS






