Select * 
From [portfolio project]..CovidDeaths
Where continent is not null
Order by 3, 4


Select * 
From [portfolio project]..CovidVaccinations
Where continent is not null
Order by 3, 4


Select Location, date, total_cases, new_cases, total_deaths,population
From [portfolio project]..CovidDeaths
Where continent is not null
Order by 1, 2



Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From [portfolio project]..CovidDeaths
Where location like '%states%'
Where continent is not null
Order by 1, 2



Select Location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
From [portfolio project]..CovidDeaths
--Where location like '%states%'
Where continent is not null
Order by 1, 2	



Select Location, Population, MAX (total_cases) as HighestInfectionCount, MAX (total_cases/population)*100 as 
PercentpopulationInfected
From [portfolio project]..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
Order by PercentpopulationInfected desc




Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [portfolio project]..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeathCount  desc





Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,SUM(cast
(new_deaths as int))/SUM(New_cases)*100 as Deathpercentage--,total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From [portfolio project]..CovidDeaths
--Where location like '%states%'
Where continent is not null
--Group by date
Order by 1, 2


Select Date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,SUM(cast
(new_deaths as int))/SUM(New_cases)*100 as Deathpercentage
From [portfolio project]..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by date
Order by 1, 2



 with Populationvsvaccination (continent, Location, Date, Population, New_vaccinations, Rollingpeoplevaccinated)
 as
 (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location,
dea.Date) as Rollingpeoplevaccinated
--,( Rollingpeoplevaccinated/population)*100
From [portfolio project]..CovidDeaths dea
Join [portfolio project]..CovidVaccinations vac
 On dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
 --Order by 2, 3
 )
 Select *, (Rollingpeoplevaccinated/population)*100
 From Populationvsvaccination


 --TEMP TABLE
Drop Table if exists #PercentPopulationVaccinated

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rollingpeoplevaccinated numeric
)
 
 Insert into #PercentPopulationVaccinated
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location,
dea.Date) as Rollingpeoplevaccinated
--,( Rollingpeoplevaccinated/population)*100
From [portfolio project]..CovidDeaths dea
Join [portfolio project]..CovidVaccinations vac
 On dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
 --Order by 2, 3

 Select * , (Rollingpeoplevaccinated/population)*100
 From #PercentPopulationVaccinated



 Create View PercentPopulationVaccinated as
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location,
dea.Date) as Rollingpeoplevaccinated
--,( Rollingpeoplevaccinated/population)*100
From [portfolio project]..CovidDeaths dea
Join [portfolio project]..CovidVaccinations vac
   On dea.location = vac.location
   and dea.date = vac.date
 Where dea.continent is not null
 --Order by 2, 3


 Select *
 From PercentPopulationVaccinated