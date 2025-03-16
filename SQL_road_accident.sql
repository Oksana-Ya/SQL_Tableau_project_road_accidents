-- Show total number of accidents
SELECT COUNT(accident_index) AS total_accidents
FROM accidents.dbo.road_data;


-- Show total number of casualties
SELECT SUM(number_of_casualties) AS total_casualties
FROM accidents.dbo.road_data;


-- Count average number of casualties and average number of cars involved in accidents
SELECT 
    ROUND(AVG(number_of_casualties)::numeric, 3) AS avg_casualties, 
    ROUND(AVG(number_of_vehicles)::numeric, 3) AS avg_vehicles
FROM accidents.dbo.road_data;


-- Categorize accidents based on severity and sort by the total number of accidents for each category in descending order
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
ORDER BY total_accidents DESC;


-- Explore how many accidents occurred in each year
SELECT EXTRACT(YEAR FROM accident_date)::INT AS accident_year, COUNT(*) AS total_accidents
FROM accidents.dbo.road_data
GROUP BY accident_year
ORDER BY accident_year;


-- See the difference in the number of accidents between 2021 and 2022 in percentage
SELECT
    COUNT(*) FILTER (WHERE EXTRACT(YEAR FROM accident_date) = 2021) AS count_2021,
    COUNT(*) FILTER (WHERE EXTRACT(YEAR FROM accident_date) = 2022) AS count_2022,
    ((COUNT(*) FILTER (WHERE EXTRACT(YEAR FROM accident_date) = 2022) - 
      COUNT(*) FILTER (WHERE EXTRACT(YEAR FROM accident_date) = 2021)) * 100.0 /
     NULLIF(COUNT(*) FILTER (WHERE EXTRACT(YEAR FROM accident_date) = 2021), 0)) AS percentage_difference
FROM accidents.dbo.road_data
WHERE EXTRACT(YEAR FROM accident_date) IN (2021, 2022);


-- Total number of accidents per each day of the week
SELECT day_of_week, COUNT(*) AS total_accidents
FROM accidents.dbo.road_data
GROUP BY day_of_week
ORDER BY total_accidents DESC;


-- Show the most common road surface conditions for accidents involving more than 5 vehicles
SELECT road_surface_conditions, COUNT(*) AS total_accidents
FROM accidents.dbo.road_data
WHERE number_of_vehicles > 5 AND road_surface_conditions IS NOT NULL
GROUP BY road_surface_conditions
ORDER BY total_accidents DESC;


-- CTE to find out the total number of accidents per each month
WITH AccidentMonthCTE AS 
(
    SELECT
        EXTRACT(YEAR FROM accident_date)::INT AS accident_year,
        EXTRACT(MONTH FROM accident_date)::INT AS accident_month,
        COUNT(*) AS total_accidents
    FROM accidents.dbo.road_data
    GROUP BY accident_year, accident_month
)

SELECT accident_year, accident_month, total_accidents
FROM AccidentMonthCTE
ORDER BY accident_year, accident_month;
