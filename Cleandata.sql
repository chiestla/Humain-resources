use project
go

SELECT * FROM [Human Resources];
EXEC sp_help 'Human Resources';
SELECT birthdate FROM [Human Resources];

SET ROWCOUNT 0;

UPDATE [Human Resources]

SET birthdate = CASE
    WHEN birthdate LIKE '%/%' THEN CONVERT(VARCHAR, CONVERT(DATE, birthdate, 101), 23)
    WHEN birthdate LIKE '%-%' THEN CONVERT(VARCHAR, CONVERT(DATE, birthdate, 101), 23)
    ELSE NULL
END;

UPDATE [Human Resources]
SET termdate = CASE
    WHEN termdate IS NOT NULL AND termdate != ' ' THEN CONVERT(DATE, CONVERT(DATETIME, termdate, 120), 23)
    ELSE NULL
END;
GO

ALTER TABLE [Human Resources]
ALTER COLUMN termdate DATE;
GO

UPDATE [Human Resources]
SET hire_date = CASE
    WHEN hire_date LIKE '%/%' THEN CONVERT(VARCHAR, CONVERT(DATE, birthdate, 101), 23)
    WHEN hire_date LIKE '%-%' THEN CONVERT(VARCHAR, CONVERT(DATE, birthdate, 101), 23)
    ELSE NULL
END;

ALTER TABLE [Human Resources]
ALTER COLUMN hire_date DATE;

ALTER TABLE [Human Resources]
ALTER COLUMN termdate DATE;

UPDATE [Human Resources]
SET age = DATEDIFF(YEAR, birthdate, GETDATE());


