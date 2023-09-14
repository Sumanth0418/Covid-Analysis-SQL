

select * from CovidDeaths$
select * from CovidVaccinations$

-- Select the data that we are going to use
select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths$
where continent is not null
order by 1,2

-- Total Cases vs Total Deaths and deathpercentage
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
from CovidDeaths$
where continent is not null and location like '%states%'
order by  5 desc,1,2

--Total Cases vs population
select location,date,population,total_cases,(total_cases/population)*100 as Deathpercentage
from CovidDeaths$
where continent is not null
order by 1,2

--Looking at countries with Highest Infection Rate compared to population
select location,population,max(total_cases) as HighestInnfectionRate,max(total_cases/population)*100 as populationinfected
from CovidDeaths$
where continent is not null
group by location,population
order by 3 desc,4 desc

-- Showing countries with the highest death count per population
select location, max(total_deaths) as totaldeaths
from covidDeaths$
where continent is not null and total_deaths is not null
group by location
order by 2 desc

--continents with highest death count per population
select continent,max(total_deaths) as totaldeaths 
from CovidDeaths$ 
where continent is not null and total_deaths is not null
group by continent
order by 2 desc

--Total new cases vs total new deaths percentage
select sum(new_cases) as totalcases, sum(cast(new_deaths as int)) as totaldeaths,(sum(cast(new_deaths as int))/sum(new_cases)*100) as deathpercentage
from CovidDeaths$
order by 1,2

--Total population vs new  vaccinations
select top(5) * from  CovidDeaths$
select top(5) * from CovidVaccinations$

select D.continent, D.location,D.date, D.population,V.new_vaccinations,
sum(cast(V.new_vaccinations as int)) over (partition by D.location order by D.location,D.date) as Vaccinatedpeople
from CovidDeaths$ D
join CovidVaccinations$ V
on D.location = V.location
and D.date = V.date
where D.continent is not null
--and V.new_vaccinations is not null
order by 2,3

--using CTE 
with popvsvac (continent,location,date,population,new_vaccinations,Vaccinatedpeople)
as
(
select D.continent, D.location,D.date, D.population,V.new_vaccinations,
sum(cast(V.new_vaccinations as int)) over (partition by D.location order by D.location,D.date) as Vaccinatedpeople
from CovidDeaths$ D
join CovidVaccinations$ V
on D.location = V.location
and D.date = V.date
where D.continent is not null
--and V.new_vaccinations is not null
--order by 2,3
)
select *,(Vaccinatedpeople/population)*100 as vacpeople
from popvsvac

--create view to store data for later visual

create view populationvaccinatedpercentage as
select D.continent, D.location,D.date, D.population,V.new_vaccinations,
sum(cast(V.new_vaccinations as int)) over (partition by D.location order by D.location,D.date) as Vaccinatedpeople
from CovidDeaths$ D
join CovidVaccinations$ V
on D.location = V.location
and D.date = V.date
where D.continent is not null
--and V.new_vaccinations is not null
--order by 2,3

select * from populationvaccinatedpercentage


