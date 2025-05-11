SELECT * 
FROM layoffs;
-- REMOVE DUPLICATE
-- STANDARDIZE THE DATA 
-- NULL VALUES OR BLANK VALUES
-- REMOVE ANY COLUMN
-- STEP 1: CREATE A COPY
CREATE TABLE Layoff
LIKE layoffs

SELECT * FROM layoff
INSERT INTO layoff
SELECT * FROM layoffs
--REMOVE DULICATE (THERE IS NO UNIQUE HERE)
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoff;


WITH Duplicate_ctes AS
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
FROM layoff
)
SELECT * 
FROM Duplicate_ctes
WHERE row_num > 1;

CREATE TABLE `layoff2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
   `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoff2
WHERE row_num >1;

INSERT INTO layoff2
SELECT *,ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
FROM layoff ;

DELETE 
FROM layoff2
WHERE row_num >1;
SELECT * 
FROM layoff2;

-- STEP 2: STANDARDIZING DATA
SELECT company, (TRIM(company))
FROM layoff2;

UPDATE layoff2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoff2
WHERE industry LIKE 'Crypto%';
UPDATE layoff2
SET industry = 'Crypto'
WHERE industry LIKE 'crypto%';

SELECT industry
FROM layoff2
WHERE industry LIKE 'Market%';

SELECT Country, TRIM(TRAILING '.' FROM Country)
FROM layoff2;

UPDATE layoff2
SET country=TRIM(TRAILING '.' FROM Country)
WHERE Country LIKE 'United state%';

SELECT DISTINCT Country 
FROM layoff2;

 -- TO CONVERT THE DATE DATA TYPE FROM TEXT TO DATE --
 SELECT `date`, 
 STR_TO_DATE(`date`, '%m/%d/%Y')
 FROM layoff2;
 
 UPDATE layoff2
 SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
 ALTER TABLE layoff2
 MODIFY COLUMN `date` DATE;
 
 SELECT * 
 FROM layoff2
 WHERE industry IS NULL
 OR industry = ' ';
 