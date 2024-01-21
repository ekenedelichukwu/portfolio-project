
select *
from [Portfolio Project]..['Covids death']
order by 3,4



--select *
--from [Portfolio Project]..['Covids vaccinations']
--order by 3,4


--select the data that we are using

select location, date, total_cases, new_cases, total_deaths, population
from [Portfolio Project]..['Covids death']
order by 1,2

--Total cases vs total deaths
--shows likelihood of dying if you contract covid in your country 

select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as Deathpercentage
from [Portfolio Project]..['Covids death']
where location like '%nigeria%'
order by 1,2

--looking at total cases vs Population
--shows the population of people that got covid in nigeria (being the population)

select location, date, total_cases, population , (cast(total_cases as float)/cast(population as float))*100 as percentpopulationinfected
from [Portfolio Project]..['Covids death']
where location like '%nigeria%'
order by 1,2

--looking at the country with the highest infection rate 

select location, population, max(total_cases) as highestinfectioncount,  max(cast(total_cases as float)/cast(population as float))*100 as percentpopulationinfected
from [Portfolio Project]..['Covids death']
group by location, population
order by percentpopulationinfected desc


--showing countries with highest death counts per population



select location, cast(max(total_deaths) as int) as TotalDeathcount
from [Portfolio Project]..['Covids death']
where continent is not null
group by location
order by TotalDeathcount desc




--breaking it downby continent 

select continent, cast(max(total_deaths) as int) as TotalDeathcount
from [Portfolio Project]..['Covids death']
where continent is not null
group by continent
order by TotalDeathcount desc


--showing continents with the highest death counts per population

select continent, population , cast(max(total_deaths) as int) as TotalDeathcount
from [Portfolio Project]..['Covids death']
where continent is not null
group by continent, population
order by TotalDeathcount desc


--GLOBAL NUMBERS 


--joining the wo tables together 

--looking at total population vs vaccinations

--using CTE 
 with popvsvac (continent, date, population, location, new_vaccinations, Rollingpeoplevacinated )
as 
(
select dea.continent, dea.date, dea.population, dea.location, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as float )) over (Partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from [Portfolio Project]..['Covids death'] dea
join [Portfolio Project]..['Covids vaccinations'] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

 )
 select*, (Rollingpeoplevacinated/population)
 from popvsvac



 --temp table

 drop table if exists #PercentpopulationVaccinated
 Create table #PercentpopulationVaccinated
 (
 Continent varchar(255),
 location varchar(255),
 Date datetime,
 population numeric, 
 New_vaccinations numeric,
 Rollingpeoplevaccinated numeric,
 )



 insert into #PercentpopulationVaccinated

 select dea.continent, dea.date, dea.population, dea.location, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as float )) over (Partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from [Portfolio Project]..['Covids death'] dea
join [Portfolio Project]..['Covids vaccinations'] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null


 select*, (Rollingpeoplevaccinated/population)
 from #PercentpopulationVaccinated

 

-- creating view

Create view [PercentpopulationVaccinated ] as,
select dea.continent, dea.date, dea.population, dea.location, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as float )) over (Partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from [Portfolio Project]..['Covids death'] dea
join [Portfolio Project]..['Covids vaccinations'] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select *
from #PercentpopulationVaccinated






