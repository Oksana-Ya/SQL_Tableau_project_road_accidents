--Show total number of accidents
SELECT COUNT(accident_index) AS total_accidents
FROM accidents.dbo.road_data


--Show total number of casualties
SELECT SUM(number_of_casualties) AS total_casualties
FROM accidents.dbo.road_data

--Count average number of casualties and average numver of cars involved in accidents
SELECT 
    ROUND(AVG(Number_of_Casualties), 3) AS Avg_Casualties, 
    ROUND(AVG(Number_of_Vehicles), 3) AS Avg_Vehicles
FROM accidents.dbo.road_data


-- Categorize accidents based on the severity and sort by the total number of accidents for each category in descending order
SELECT
    accident_severity,
    CASE
        WHEN accident_severity = 'Fatal' THEN 'Highly Severe'
        WHEN accident_severity = 'Serious' THEN 'Moderately Severe'
        WHEN accident_severity = 'Slight' THEN 'Less Severe'
        ELSE 'Unknown'
    END AS severity_category,
    COUNT(*) AS total_accidents
FROM accidents.dbo.road_data
GROUP BY accident_severity
ORDER BY total_accidents DESC




--Explore how many accidents were in each year
SELECT YEAR([Accident_Date]) AS date_year, COUNT(*) AS accidents
FROM accidents.dbo.road_data
GROUP BY YEAR(Accident_Date)

--See the difference of number of accidents in year 2021 and 2022 in percentage
SELECT
    SUM(CASE WHEN YEAR(accident_date) = 2021 THEN 1 ELSE 0 END) AS count_2021,
    SUM(CASE WHEN YEAR(accident_date) = 2022 THEN 1 ELSE 0 END) AS count_2022,
    ((SUM(CASE WHEN YEAR(accident_date) = 2022 THEN 1 ELSE 0 END) - SUM(CASE WHEN YEAR(accident_date) = 2021 THEN 1 ELSE 0 END)) * 100.0 / NULLIF(SUM(CASE WHEN YEAR(accident_date) = 2021 THEN 1 ELSE 0 END), 0)) AS percentage_difference
FROM accidents.dbo.road_data
WHERE YEAR(accident_date) IN (2021, 2022);


--Total number of accidents per each day of the week
SELECT day_of_week, COUNT(*) AS total_accidents
FROM accidents.dbo.road_data
GROUP BY day_of_week
ORDER BY total_accidents DESC



--Show the most common road surface conditions for accidents involving more than 5 vehicles
SELECT Road_Surface_Conditions, COUNT(*) AS Total_Accidents
FROM accidents.dbo.road_data
WHERE Number_of_Vehicles > 5
GROUP BY Road_Surface_Conditions
ORDER BY Total_Accidents DESC;







--CTE to find out total number of accidents per each month
WITH AccidentMonthCTE AS 
(
    SELECT
        MONTH([Accident_Date]) AS Month,
        YEAR([Accident_Date]) AS Year,
        COUNT(*) AS TotalAccidents
    FROM accidents.dbo.road_data
    GROUP BY YEAR([Accident_Date]),MONTH([Accident_Date])
)

SELECT Year, Month, TotalAccidents
FROM AccidentMonthCTE
ORDER BY Year, Month;
