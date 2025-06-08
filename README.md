# Prueba-Tecnica-Continental-Flowers
---
## PARTE 1 - TEÓRICA 
### ¿Cuál de las siguientes opciones representa el uso adecuado de using en C# para manejar una conexión a base de datos?
#### R// C) using (var conn = new SqlConnection()) { conn.Open(); /* uso */ }
### ¿Cuál de las siguientes opciones representa una buena práctica para consumir APIs REST en C#?
#### R// A) Usar HttpClient y reusarlo globalmente.
### ¿Cuál es la forma correcta de enviar un objeto en formato JSON en una solicitud HTTP POST usando JavaScript (AJAX)?
#### R// C) fetch(url, { method: 'POST', body: JSON.stringify(myObject), headers: { 'ContentType': 'application/json' } });
### ¿Cuál es la función principal de un paquete SSIS?
#### R// C) Extraer, transformar y cargar datos (ETL).
### ¿Cuál es la ventaja de implementar una arquitectura basada en servicios (SOA o microservicios) sobre una monolítica?
##### R// C) Mejor escalabilidad, despliegue independiente y mantenimiento modular.

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
- 1. Materializar una vista donde se agrupen las ventas mensuales (Agregada Mensual) se puede utilizar un Trigger o un SP que actualice los datos.`
- 2. Crear particiones de la tabla por año, si se requiere solo el ultimo año.
- 3. Crear un indice entre CustomerID y SalesDate para mejorar las agrupaciones y el filtrado
- 4. Agregarle una clave primaria a la tabla de Sales, directamente no optimiza la consulta con un gran volumen de datos, sin embargo da estructura e identifica cada registro

---

### EJERCICIO 2: API REST en .NET 8

**Objetivo**: Crear una API REST que reciba facturas, las valide y almacene temporalmente en memoria. Permitir su consulta por cliente ordenada por fecha.

#### Tecnologías usadas:
- .NET 6
- AutoMapper
- DTOs para entrada y salida
- Almacenamiento simulado en memoria con lista estática (`List<Invoice>`)

#### Archivos clave:
- `Controllers/InvoicesController.cs`
- `Models/Invoice.cs`
- `DTOs/InvoiceCreateDto.cs`, `InvoiceReadDto.cs`
- `Services/InvoiceService.cs`
- `Mapping/MappingProfile.cs`

#### Cómo ejecutar:
```bash
dotnet restore
dotnet run

#### Para mayor claridad consultar el archivo 'README.md' en 'InvoiceApi.zip'
