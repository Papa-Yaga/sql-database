USE depression;


CREATE VIEW view_master AS
SELECT country, years, AVG(gdp_per_capita) AS avg_gdp, ROUND(AVG(suicides),2) AS avg_suic
FROM master
GROUP BY country, years;

SELECT * FROM
(
SELECT *,
DENSE_RANK() OVER (
PARTITION BY country
ORDER BY years DESC)
AS dense
FROM view_master
) as X
WHERE dense = 1;

# Divide data into values before the Global Economy Crisis and after.
CREATE VIEW view_gec AS
SELECT *,
CASE
	WHEN Year > 2008 THEN "After GEC"
    ELSE "Before GEC"
END AS crash_data
FROM housing_year;

SELECT ROUND(AVG(US_housing_price),2) AS US_housing, ROUND(AVG(IT_housing_price),2) AS IT_housing, crash_data
FROM view_gec
GROUP BY crash_data;

CREATE VIEW view_alc AS
SELECT *,
CASE
	WHEN Year > 2008 THEN "After GEC"
    ELSE "Before GEC"
END AS crash_data
FROM alc_all;

# All alcohol abuse values are in age-standardized percent.
SELECT ROUND(AVG(US_alcohol_abuse),2) AS US_alc,
		ROUND(AVG(US_housing_price),2) AS US_housing, 
        ROUND(AVG(IT_alcohol_abuse),2) AS IT_alc,
        ROUND(AVG(IT_housing_price),2) AS IT_housing, 
        crash_data
FROM view_alc
JOIN view_gec
USING(crash_data)
GROUP BY crash_data;

CREATE VIEW view_all AS
SELECT country, ROUND(AVG(suicides),2) AS suicides,
CASE
	WHEN years > 2008 THEN "After GEC"
    ELSE "Before GEC"
END AS crash_data
FROM master 	
GROUP BY country, crash_data;

SELECT * 
FROM view_all;

SELECT *
FROM view_all
WHERE country LIKE ("United States") OR country LIKE ("Italy");

