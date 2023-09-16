-- Queries for power bi visualization

--Table 1 data
--Total new cases and new deaths and deathpercentage
select sum(new_cases) as totalcases, sum(cast(new_deaths as int)) as totaldeaths,(sum(cast(new_deaths as int))/sum(new_cases)*100) as deathpercentage
from CovidDeaths$
order by 1,2

--Table 2 data
--Total death count by location
select location, max(total_deaths) as totaldeaths
from covidDeaths$
where continent is not null and total_deaths is not null
group by location
order by 2 desc

----Table 3 data
--population infected by location
select location,population,max(total_cases) as HighestInnfectionRate,max(total_cases/population)*100 as populationinfected
from CovidDeaths$
where continent is not null
group by location,population
order by 4 desc

--Table 4 data
--population infected by month and location
select location,date,population,max(total_cases) as HighestInnfectionRate,max(total_cases/population)*100 as populationinfected
from CovidDeaths$
where continent is not null
group by location,population,date
order by 5 desc
