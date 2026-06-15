Select *
From layoffs;

DROP TABLE IF EXISTS `layoffs_staging`;
Create Table layoffs_staging
like layoffs;
Insert layoffs_staging
Select *
From layoffs;

# Removing duplicates

SELECT *
From layoffs_staging;

SELECT *, row_number() 
Over (partition by company,location,industry,total_laid_off,percentage_laid_off, `date`,stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;


With duplicate_cte as 
(
SELECT *,
Row_number() 
Over (partition by company,location,industry,total_laid_off,percentage_laid_off, `date`,stage, country, funds_raised_millions) as row_num
FROM layoffs_staging)

Select *
From duplicate_cte
where row_num>1;

Drop table if exists `layoffs_staging2`;
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Select *
From layoffs_staging2;

insert layoffs_staging2
select *, 
row_number()
OVER (Partition by company,location,industry,total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions)as row_num
from layoffs_staging;

Select *
From layoffs_staging2
where row_num>1;

DELETE
From layoffs_staging2
where row_num>1;

# Standardize 
Select *
From layoffs_staging2;

# company names
update layoffs_staging2
set company= trim(company);

#Country names
Select distinct country
From layoffs_staging2
order by 1;

Select distinct trim(trailing '.' from country)
From layoffs_staging2
order by 1;

Update layoffs_staging2
set country = trim(trailing '.' from country);

# Null and blank values

SELECT *
FROM layoffs_staging2
where  industry= '' or industry is null;

UPDATE layoffs_staging2
set industry = null
where industry = ('');

SELECT *
FROM layoffs_staging2
where industry is null;

SELECT *
FROM layoffs_staging2
where company = "Juul";

SELECT distinct industry
FROM layoffs_staging2
order by 1;

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypt%';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
join layoffs_staging2 t2
 on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
AND t2.industry is not null;

UPDATE layoffs_staging2 t1
join layoffs_staging2 t2
 on t1.company = t2.company
SET t1.industry= t2.industry
where (t1.industry is null or t1.industry = '')
AND t2.industry is not null;

#remove unnecessary data

Select *
FROM layoffs_staging2
where total_laid_off is null 
and percentage_laid_off is null;

DELETE
FROM layoffs_staging2
where total_laid_off is null 
and percentage_laid_off is null;

# Converting date to proper date format

Select date
from layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%Y-%m-%d');
Alter table layoffs_staging2
modify column `date` date;

ALTER TABLE layoffs_staging2
drop column row_num;

select *
from layoffs_staging2;




