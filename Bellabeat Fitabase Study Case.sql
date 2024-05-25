-- Exploratory Data Analysis using Bellabeat Fitabase Datasets

Select * 
From dbo.dailyActivity_merged 

Select DISTINCT(Id)
From dbo.dailyActivity_merged
Order by Id

-- Find Average total steps, total distance, and calories by Id
Select Id, AVG(TotalSteps) avg_totalsteps, AVG(TotalDistance) avg_totaldistance, AVG(Calories) avg_calories
From dbo.dailyActivity_merged
Group by Id
Order by avg_calories desc

-- Change column format
Alter table dbo.dailyActivity_merged
Alter column SedentaryMinutes float

Alter table dbo.dailyActivity_merged
Alter column LightlyActiveMinutes float

Alter table dbo.dailyActivity_merged
Alter column VeryActiveMinutes float

Alter table dbo.dailyActivity_merged
Alter column FairlyActiveMinutes float


-- Average customers using smart device by day
Select Id, DATENAME(Weekday, ActivityDate) day_log,
AVG(VeryActiveDistance) avg_VeryActiveMinutes, 
AVG(ModeratelyActiveDistance) avg_moderatelyactivedistance,
AVG(LightActiveDistance) avg_lightactivedistance,
AVG(SedentaryActiveDistance) avg_sedentaryactivedistance,
AVG(VeryActiveMinutes) avg_veryactivedistance, 
AVG(FairlyActiveMinutes) avg_FairlyActiveMinutes,
AVG(LightlyActiveMinutes) avg_LightlyActiveMinutes,
AVG(SedentaryMinutes) avg_sedentaryminutes,
AVG(TotalSteps) avg_totalsteps,
AVG(Calories) avg_calories,
COUNT(ActivityDate) total_day_log
From dbo.dailyActivity_merged
Group by Id, DATENAME(Weekday, ActivityDate)
Order by Id

-- Total customers using smart device by day
Select Id, DATENAME(Weekday, ActivityDate) day_log,
SUM(VeryActiveDistance) total_VeryActiveMinutes, 
SUM(ModeratelyActiveDistance) total_moderatelyactivedistance,
SUM(LightActiveDistance) total_lightactivedistance,
SUM(SedentaryActiveDistance) total_sedentaryactivedistance,
SUM(VeryActiveMinutes) total_veryactivedistance, 
SUM(FairlyActiveMinutes) total_FairlyActiveMinutes,
SUM(LightlyActiveMinutes) total_LightlyActiveMinutes,
SUM(SedentaryMinutes) total_sedentaryminutes,
SUM(TotalSteps) total_totalsteps,
SUM(Calories) total_calories,
COUNT(ActivityDate) total_day_log
From dbo.dailyActivity_merged
Group by Id, DATENAME(Weekday, ActivityDate)
Order by Id

-- How many times customers using the smart device
Select Id, COUNT(ActivityDate) total_day_log
From dbo.dailyactivity_merged
Group by Id
Order by total_day_log desc

SELECT *
FROM dbo.sleepDay_merged

-- Total sleep per customers
Select Id, 
SUM(TotalSleepRecords) total_sleep, 
SUM(TotalMinutesAsleep) total_minutes, 
SUM(TotalTimeInBed) total_timeinbed
From dbo.sleepDay_merged
Group by Id
Order By total_sleep desc

-- Average sleep by customers
Select Id, 
AVG(TotalSleepRecords) avg_sleep, 
AVG(TotalMinutesAsleep) avg_minutes, 
AVG(TotalTimeInBed) avg_timeinbed
From dbo.sleepDay_merged
Group by Id
Order By avg_sleep desc

-- Total sleep customers by day
Select Id, 
DATENAME(weekday, SleepDay) as day_sleep, 
SUM(TotalSleepRecords) total_sleep, 
SUM(TotalMinutesAsleep) total_minutes, 
SUM(TotalTimeInBed) total_timeinbed
From dbo.sleepDay_merged
GROUP BY Id, DATENAME(weekday, SleepDay)
Order by Id

-- Average sleep customers by day
Select Id, 
DATENAME(Weekday, SleepDay) as day_sleep, 
AVG(TotalSleepRecords) total_sleep, 
AVG(TotalMinutesAsleep) total_minutes, 
AVG(TotalTimeInBed) total_timeinbed
From dbo.sleepDay_merged
GROUP BY Id, DATENAME(Weekday, SleepDay)
Order by Id

Select *
From dbo.weightLogInfo_merged

-- Average customers weight
SELECT Id,
AVG(CAST(WeightKg as float)) as avg_weightkg,
AVG(CAST(WeightPounds as float)) as avg_weightpounds,
AVG(CAST(BMI as float)) as avg_bmi
FROM dbo.weightLogInfo_merged
GROUP BY Id
ORDER BY Id

-- Customers weight change by date
SELECT Id,
DATENAME(day, Date) as day_weight,
AVG(CAST(WeightKg as float)) as avg_weightkg,
AVG(CAST(WeightPounds as float)) as avg_weightpounds,
AVG(CAST(BMI as float)) as avg_bmi
FROM dbo.weightLogInfo_merged
GROUP BY Id, DATENAME(day, Date)
ORDER BY Id

-- Customer weight and sleep activity
Select wei.Id, 
AVG(CAST(wei.WeightKg as float)) avg_weight, 
SUM(sle.TotalSleepRecords) total_sleep, 
SUM(sle.TotalMinutesAsleep) total_minutesleep, 
SUM(sle.TotalTimeInBed) total_timebed
FROM dbo.sleepDay_merged as sle
JOIN dbo.weightLogInfo_merged as wei
ON sle.Id = wei.Id
Group BY wei.Id

--Showing customers daily activity and sleep activity by day use
Select sle.Id, 
DATENAME(weekday, dai.ActivityDate) activity_day,
SUM(sle.TotalSleepRecords) total_sleep, 
SUM(sle.TotalMinutesAsleep) total_minutesleep, 
SUM(sle.TotalTimeInBed) total_timeinbed,
SUM(dai.Calories) as total_calories
From dbo.dailyActivity_merged dai
JOIN dbo.sleepDay_merged sle
ON dai.Id = sle.Id
Group By sle.Id, DATENAME(weekday, dai.ActivityDate)
ORDER by sle.Id

-- Showing customers weight and daily activty by dates
SELECT wei.Id, 
dai.ActivityDate day_use,
AVG(CAST(wei.WeightKg as float)) avg_weight, 
SUM(dai.TotalSteps) OVER(Partition by wei.Id order by dai.ActivityDate) totalsteps,
SUM(dai.Calories) OVER(partition by wei.Id order by dai.ActivityDate) total_calories
FROM dbo.dailyActivity_merged dai
JOIN dbo.weightLogInfo_merged wei
ON dai.Id = wei.Id
GROUP BY wei.Id, dai.ActivityDate, dai.TotalSteps, dai.Calories







