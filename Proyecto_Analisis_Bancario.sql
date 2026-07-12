USE Banca_DB

/* 
   Realiza un SELECT que agrupe a los clientes por un rango de CreditScore 
   (usa CASE WHEN para crear los rangos: Bajo, Medio, Alto) 
   y cuenta cuántos clientes han salido (Exited = 1) por cada rango.
*/

SELECT 
    CASE 
        WHEN CreditScore < 600 THEN 'Bajo'
        WHEN CreditScore BETWEEN 600 AND 750 THEN 'Medio'
        ELSE 'Alto'
    END AS Rango_Credito,
    COUNT(CustomerId) AS Total_Clientes,
    SUM(cast(Exited as INT)) AS Clientes_Que_Salieron
FROM Bank_DBA
GROUP BY 
    CASE 
        WHEN CreditScore < 600 THEN 'Bajo'
        WHEN CreditScore BETWEEN 600 AND 750 THEN 'Medio'
        ELSE 'Alto'
    END
ORDER BY Total_Clientes DESC;

/* Instrucción: 
   Realiza un SELECT que agrupe por la cantidad de productos (NumOfProducts).
   Calcula:
   1. El total de clientes por cantidad de productos.
   2. La tasa de abandono (Churn Rate) en porcentaje.
   
   Pista: La tasa de abandono sería (Total que salieron / Total de clientes) * 100.
*/


SELECT 
    NumOfProducts,
    COUNT(CustomerId) AS Total_Clientes,
    (SUM(CAST(Exited AS FLOAT)) / COUNT(CustomerId)) * 100 AS Tasa_Abandono_Porcentaje
FROM Bank_DBA
GROUP BY NumOfProducts
ORDER BY NumOfProducts;



----- Identifica individualmente a los clientes "VIP" 
-----(Saldo > 100,000, Activos, y CreditScore < 650) ordenados por impacto financiero.

SELECT 
    CustomerId,
    Balance,
    CreditScore,
   IsActiveMember as Miembro_activo
from Bank_DBA
where Balance > 100000 and IsActiveMember = 1 AND CreditScore < 650
    order by CustomerId Desc;

---Determina dónde está concentrado el dinero en riesgo dentro del segmento anterior.

SELECT
    Geography,
sum(Balance) as Total_Liquidez
    from Bank_DBA
group by Geography;

-----Desafío #5: El impacto de la permanencia (Tenure)
-----Queremos saber si la cantidad de años que un cliente lleva en el banco (Tenure) afecta su tasa de abandono (Exited).


SELECT 
    Tenure,
    AVG(CAST(Exited AS FLOAT)) AS Tasa_Abandono_Promedio
FROM Bank_DBA
GROUP BY Tenure
ORDER BY Tenure;

---Desafío #6: Análisis del salario frente al riesgo
---Queremos identificar si los clientes con un salario estimado (EstimatedSalary)
---alto tienen, en promedio, un mejor CreditScore que aquellos con salarios bajos.

select * from Bank_DBA

select 
CASE 
    WHEN EstimatedSalary > 100000 then 'sueldo Alto'
    WHEN EstimatedSalary <= 100000 then 'Sueldo Bajo'
else 'sueldo muy bajo'
end as Sueldo_Estimado,
AVG(creditScore) as promedio_Crediticio
    from Bank_DBA
group by 
CASE 
    WHEN EstimatedSalary > 100000 then 'sueldo Alto'
    WHEN EstimatedSalary <= 100000 then 'Sueldo Bajo'
else 'sueldo muy bajo'
end
order by promedio_Crediticio;