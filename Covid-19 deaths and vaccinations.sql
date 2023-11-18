-- Data Selection
SELECT location, date, total_cases, new_cases, total_deaths, population FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Look at total cases vs total deaths: What was the death percentage in  the U.S.?
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage  FROM CovidDeaths
WHERE location LIKE '%states%' AND continent IS NOT NULL
ORDER BY 1, 2;

-- Look at total cases vs population: How many people got infected by country?
SELECT location, date, population, total_cases, (total_cases/population) AS positive_percentage  FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Countries with highest infection rates
SELECT location, population, max(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 AS infection_rate FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 4 DESC;

-- Countries with highest death count
SELECT location, population, max(total_deaths) as HighestDeathCount FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 3 DESC;


-- continents with highest death count
SELECT continent, max(total_deaths) as HighestDeathCount FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 2 DESC;

-- Global numbers per day
SELECT date, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 AS death_percentage FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1;

-- Global numbers total
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 AS death_percentage FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1;

-- Total population vs vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS vaccination_rollout
 FROM Covid..CovidDeaths dea
JOIN
Covid..CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;

-- USE CTE to have VaccinationPercentage
WITH PopvsVac (Continent, Location, Date, Population, new_vaccinations, vaccination_rollout) AS (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS vaccination_rollout
 FROM Covid..CovidDeaths dea
JOIN
Covid..CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL)
SELECT *, ROUND((vaccination_rollout/Population)*100, 2) AS VaccinationPercentage FROM PopvsVac;

--Create view to store data for visualizations
USE Covid
GO
CREATE VIEW VacPercentage AS SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS vaccination_rollout
 FROM Covid..CovidDeaths dea
JOIN
Covid..CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;