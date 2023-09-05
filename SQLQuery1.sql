select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage from SQLProject..CovidDeaths$
where Location like '%America%'
order by 1,2;
-- Checking for North America; likelihood of dying if in North America.

--Total population vs Covid contractions; percentage of population that got Covid.
Select Location, date, total_cases, population, (total_cases/population)*100 As InfectionRate from SQLProject..CovidDeaths$
where location like '%America%'
order by 1,2;

--Looking at the countries with the highest infection rates.
--Total population vs Covid contractions; percentage of population that got Covid.

Select Location, Population, MAX(total_cases) As MaximumCases, MAX((total_cases/population))*100 As HighestInfectionRate from SQLProject..CovidDeaths$
group by Location, Population
order by HighestInfectionRate desc;

--Countries with the highest fatalities
Select Location, MAX(total_deaths) as TotalDeathCount from SQLProject..CovidDeaths$
where continent is not null
group by Location
order by TotalDeathCount desc;


--Let's break things down by the continents
Select Continent, MAX(total_deaths) as TotalDeathCount from SQLProject..CovidDeaths$
where continent is not null
group by continent
order by TotalDeathCount;

--Global numbers

Select Date, SUM(New_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (Sum(cast (new_deaths as int))/sum(new_cases))*100 as Global_Death_Per from SQLProject..CovidDeaths$
where continent is not null
group by date
order by 1,2;

--Joining two different tables together
Select Dea.continent, Dea.location, Dea.date, Dea.population, Vax.new_vaccinations from SQLProject..CovidDeaths$ as Dea Join SQLProject..CovidVaccinations$ Vax
on Dea.location = Vax.location and Dea.date = Vax.date
where Dea.continent is not null 
order by 1,2,3;


--Total population vs vaccinations/using CTE

With PopVsVac (Continent, Location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select Dea.continent, Dea.location, Dea.date, Dea.population, Vax.new_vaccinations, SUM(cast(Vax.new_vaccinations as int)) OVER (Partition by Dea.Location order by Dea.Location, Dea.date) 
as RollingPeopleVaccinated
from SQLProject..CovidDeaths$ as Dea Join SQLProject..CovidVaccinations$ Vax
on Dea.location = Vax.location and Dea.date = Vax.date
where Dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100 as Rolling_Percentage
From PopVsVac;