select *
from Coviddeaths
where continent is not null and total_cases is not null
order by 2,3


select location, date, population, new_cases, total_cases, total_deaths
from Coviddeaths
where continent is not null and total_cases is not null
order by 1,2


select *
from Covidvaccination
order by 3, 4



select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as Percentagedeaths
from Coviddeaths
where location like '%nigeria%' and date like '%2023%'
order by 1,2



select location, date, population, total_cases, total_deaths, (cast(total_cases as float)/population)*100 as Percentageaffected
from Coviddeaths
where location like '%afghanistan%'
order by 2 desc


select location, population, max(total_cases) as highestdeath,
 max((cast(total_cases as float))/population)*100 as Percentagepopinfected
from Coviddeaths
group by location, population
order by Percentagepopinfected desc


select location, max(cast(total_deaths as int)) as totaldeathcount
from Coviddeaths
--where location like 'nigeria'
where continent is not null and total_cases is not null
group by location
order by totaldeathcount desc

select continent, max(cast(total_deaths as int)) as totaldeathcount
from Coviddeaths
where continent is not null and total_cases is not null
group by continent
order by totaldeathcount desc


select sum(cast(new_cases as int)) as totalcases, sum(cast(new_deaths as int)) as totalnewdeathchcount,
CASE
        WHEN SUM(CAST(new_cases AS FLOAT)) <> 0 THEN SUM(CAST(new_deaths AS FLOAT)) / SUM(CAST(new_cases AS FLOAT))* 100
        ELSE null
    END AS percentagedeath
from Coviddeaths
where continent is not null
group by date 
order by 1

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast (vac.new_vaccinations as float)) over (partition by dea.location order by dea. location, dea.date) as rollingtotalvaccination
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3


with popvsvac (continent, location, date, population, new_vaccinations, rollingtotalvaccination)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast (vac.new_vaccinations as float)) over (partition by dea.location order by dea. location, dea.date) as
rollingtotalvaccination
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)
select *, (rollingtotalvaccination/population)*100 as rollingvaccinationpercent
from popvsvac


drop table if exists #percentagepopvaccinated
create table #percentagepopvaccinated
(continent varchar(255), location varchar(255), date datetime, population numeric, new_vaccinations numeric, 
rollingtotalvaccination numeric)
insert into #percentagepopvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast (vac.new_vaccinations as float)) over (partition by dea.location order by dea. location, dea.date) as
rollingtotalvaccination
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2, 3

select *, (rollingtotalvaccination/population)*100 as rollingvaccinationpercent
from #percentagepopvaccinated

create view percentagepopvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast (vac.new_vaccinations as float)) over (partition by dea.location order by dea. location, dea.date) as
rollingtotalvaccination
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3

select *, (rollingtotalvaccination/population)*100 as rollingvaccinationpercent
from percentagepopvaccinated
