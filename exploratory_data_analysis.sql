Select*
From layoffs_staging2;

#1 Max total_laid_off and Max percentage_laid_off

Select Max(total_laid_off), max(percentage_laid_off)
From layoffs_staging2;

#2 companies that get hit the most and companies that laid off most employees

SELECT *
From layoffs_staging2
where percentage_laid_off =1
order by total_laid_off DESC;

Select company, Max(percentage_laid_off)
From layoffs_staging2
Group by company
order by 2 desc;

Select company, Max(total_laid_off)
From layoffs_staging2
Group by company
order by 2 desc;

Select company, max(funds_raised_millions)
From layoffs_staging2
Group by company;

#4 companies, industries, countries and sum of their total laid

Select company, sum(total_laid_off)
From layoffs_staging2
Group by company
order by 2 desc;

Select industry, sum(total_laid_off)
From layoffs_staging2
Group by industry
order by 2 desc;

Select country, sum(total_laid_off)
From layoffs_staging2
Group by country
order by 2 desc;


# DATE RANGE WE HAVE
Select min(`date`), max(`date`)
From layoffs_staging2
;

# the most laid off in a year and most laid off in stage

Select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 2 desc;

Select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

# Progression of the layoffs

Select substring(`date`, 1,7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`, 1,7) is not null
Group by `month`
order by 1 asc;

# rolling_total of the progression layoff

with rolling_total as
(
Select substring(`date`, 1,7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`, 1,7) is not null
Group by `month`
)

Select `month`, total_off, sum(total_off) over(order by `month`) as Rolling_total
From rolling_total;

# TOP 5 COMPANIES that made the most layoff

select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;

with company_year (Company, years, total_laid_off) as
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), company_year_rank as
(Select*, dense_rank()
over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)

select *
from company_year_rank
where ranking <=5 ;

Select distinct(industry), max(total_laid_off)
from layoffs_staging2
group by industry;



