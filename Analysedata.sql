USE project
GO

SELECT TOP 10 *
FROM [Human Resources];

--Quelle est la r�partition des sexes parmi les employ�s de l'entreprise ?
SELECT gender, COUNT(*) AS count
FROM [Human Resources]
WHERE age >= 18
GROUP BY gender;

--Quelle est la r�partition ethnique/raciale des employ�s de l'entreprise ?
SELECT race, COUNT(*) AS count
FROM [Human Resources]
WHERE age >= 18
GROUP BY race
ORDER BY count DESC;

--Quelle est la distribution d'�ge parmi les employ�s de l'entreprise ?
SELECT 
  MIN(age) AS youngest,
  MAX(age) AS oldest
FROM [Human Resources]
WHERE age >= 18;

SELECT FLOOR(age/10)*10 AS age_group, COUNT(*) AS count
FROM [Human Resources]
WHERE age >= 18
GROUP BY FLOOR(age/10)*10;

SELECT 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END AS age_group, 
  COUNT(*) AS count
FROM [Human Resources]
WHERE age >= 18
GROUP BY 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END
ORDER BY age_group;

SELECT 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END AS age_group, 
  gender,
  COUNT(*) AS count
FROM [Human Resources]
WHERE age >= 18
GROUP BY 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END,gender
ORDER BY age_group, gender;

--Combien d'employ�s travaillent au si�ge social par rapport aux sites distants ?
SELECT location, COUNT(*) as count
FROM [Human Resources]
WHERE age >= 18
GROUP BY location;

--Quelle est la dur�e moyenne de l'emploi pour les employ�s ayant �t� licenci�s ?
SELECT ROUND(AVG(DATEDIFF(DAY, hire_date, termdate) / 365.0), 0) AS avg_length_of_employment
FROM [Human Resources]
WHERE termdate IS NOT NULL AND termdate <= GETDATE() AND age >= 18;

SELECT ROUND(AVG(DATEDIFF(DAY, hire_date, termdate) / 365.25), 0) AS avg_length_of_employment
FROM [Human Resources]
WHERE termdate <= GETDATE() AND age >= 18;

--Comment varie la distribution des sexes selon les d�partements et les titres de poste ?
SELECT department, gender, COUNT(*) as count
FROM [Human Resources]
WHERE age >= 18
GROUP BY department, gender
ORDER BY department;

--Quelle est la r�partition des titres de poste au sein de l'entreprise ?
SELECT jobtitle, COUNT(*) as count
FROM [Human Resources]
WHERE age >= 18
GROUP BY jobtitle
ORDER BY jobtitle DESC;

--Quel d�partement a le taux de rotation le plus �lev� ?
SELECT department,
  COUNT(*) AS total_count, 
  SUM(CASE WHEN termdate <= GETDATE() AND termdate IS NOT NULL THEN 1 ELSE 0 END) AS terminated_count, 
  SUM(CASE WHEN termdate IS NOT NULL THEN 1 ELSE 0 END) AS active_count,
  CAST(SUM(CASE WHEN termdate <= GETDATE() THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) AS termination_rate
FROM [Human Resources]
WHERE age >= 18
GROUP BY department
ORDER BY termination_rate DESC;

--Quelle est la distribution des employ�s selon les emplacements par �tat ?
SELECT location_state, COUNT(*) as count
FROM [Human Resources]
WHERE age >= 18
GROUP BY location_state
ORDER BY count DESC;

--Comment le nombre d'employ�s de l'entreprise a-t-il �volu� au fil du temps en fonction des dates d'embauche et de fin d'emploi ?
SELECT 
    YEAR(hire_date) AS year, 
    COUNT(*) AS hires, 
    SUM(CASE WHEN termdate IS NOT NULL AND termdate <= GETDATE() THEN 1 ELSE 0 END) AS terminations, 
    COUNT(*) - SUM(CASE WHEN termdate IS NOT NULL AND termdate <= GETDATE() THEN 1 ELSE 0 END) AS net_change,
    ROUND(((COUNT(*) - SUM(CASE WHEN termdate IS NOT NULL AND termdate <= GETDATE() THEN 1 ELSE 0 END)) / CAST(COUNT(*) AS FLOAT) * 100), 2) AS net_change_percent
FROM [Human Resources]
WHERE age >= 18
GROUP BY 
    YEAR(hire_date)
ORDER BY 
    YEAR(hire_date) ASC;

SELECT 
    year, 
    hires, 
    terminations, 
    (hires - terminations) AS net_change,
    ROUND(ISNULL(((hires - terminations) / NULLIF(hires, 0) * 100), 0), 2) AS net_change_percent
FROM (
    SELECT 
        YEAR(hire_date) AS year, 
        COUNT(*) AS hires, 
        SUM(CASE WHEN termdate IS NOT NULL AND termdate <= GETDATE() THEN 1 ELSE 0 END) AS terminations
    FROM [Human Resources]
    WHERE age >= 18
    GROUP BY 
        YEAR(hire_date)
) subquery
ORDER BY year ASC;

--Quelle est la distribution de la long�vit� pour chaque d�partement ?
SELECT 
    department, 
    ROUND(AVG(DATEDIFF(DAY, termdate, GETDATE()) / 365.25), 0) AS avg_tenure
FROM [Human Resources]
WHERE termdate <= GETDATE() AND termdate IS NOT NULL AND age >= 18
GROUP BY department;


