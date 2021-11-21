-- Looking at Total Cases vs Total Deaths

Select location, date, total_cases, new_cases, total_deaths, population
from CovidPortfolio..CovidDeaths
Order By 1,2

-- SHows the ikelihood of dying if you get covd in your country
Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathsPerCase
from CovidPortfolio..CovidDeaths
Where location	like 'India'
Order By 1,2

-- Looking at Total Cases vs Population
-- Percentage of People Who have Covid
Select location, date, total_cases,Population, (total_cases/population)*100 as DeathsPerCase
from CovidPortfolio..CovidDeaths
Where location	like 'India'
Order By 1,2

--Looking at countries with highest infection rates compared to population
Select location, MAX(total_cases) as HighestInfectionCount, Population, MAX((total_cases/population))*100 as PercentPopulationInfected
from CovidPortfolio..CovidDeaths
--Where location	like 'India'
Group By Location, Population
Order By 4 desc

-- Showing Countries with highest death counts per popuation
Select location, MAX(cast(Total_deaths as Int)) as TotalDeathCount
from CovidPortfolio..CovidDeaths
--Where location	like 'India'
Where continent is null
Group By Location
Order By 2 desc

-- Global Numbers
Select date, Sum(new_cases) as Total_cases,Sum (cast(new_deaths as Int)) as Total_deaths, Sum(cast(new_deaths as int))/Sum(New_cases)*100 as DeathPercentage
from CovidPortfolio..CovidDeaths
--Where location	like 'India'
Where continent is not null
Group by date
Order By 1,2

-- Joining tables by Location and Date
-- Total Population (World) vs Vaccination
Select  a.continent, a.location, a.date,a.population, b.new_vaccinations, sum(Convert(int,b.new_vaccinations)) OVER (Partition By a.Location Order by a.location, a.date) as RollingPeopleVaccinated
from CovidPortfolio..CovidDeaths a
join CovidPortfolio..CovidVaccinations b
on a.Location = b.location
and a.date = b.date
Where a.continent is not null
and b.new_vaccinations is not null
order by 2,3

-- Using CTE
with PopvsVAc( continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(
Select  a.continent, a.location, a.date,a.population, b.new_vaccinations, sum(Convert(bigint,b.new_vaccinations)) OVER (Partition By a.Location Order by a.location, a.date) as RollingPeopleVaccinated
from CovidPortfolio..CovidDeaths a
join CovidPortfolio..CovidVaccinations b
on a.Location = b.location
and a.date = b.date
Where a.continent is not null
--and b.new_vaccinations is not null
--order by 2,3
)
Select *, (rollingpeoplevaccinated/population)*100 from PopvsVAc

-- VIEW
Create View PopvsVac as
Select  a.continent, a.location, a.date,a.population, b.new_vaccinations, sum(Convert(bigint,b.new_vaccinations)) OVER (Partition By a.Location Order by a.location, a.date) as RollingPeopleVaccinated
from CovidPortfolio..CovidDeaths a
join CovidPortfolio..CovidVaccinations b
on a.Location = b.location
and a.date = b.date
Where a.continent is not null
--and b.new_vaccinations is not null
--order by 2,3
