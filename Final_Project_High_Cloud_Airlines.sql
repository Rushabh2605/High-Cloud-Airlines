use airlines;
select* from maindata;
ALTER TABLE Maindata 
RENAME COLUMN `Month (#)` to Month;
ALTER TABLE Maindata 
RENAME COLUMN `# Transported Passengers` to Transported_Passengers;
ALTER TABLE Maindata 
RENAME COLUMN `# Available Seats` to Available_seats;
ALTER TABLE Maindata 
RENAME COLUMN `From - To City` to From_To_City;
ALTER TABLE Maindata 
RENAME COLUMN `# Departures Scheduled` to Departures_Scheduled;
ALTER TABLE Maindata 
RENAME COLUMN `# Departures Performed` to Departures_Performed;




select year,Month,Day from maindata;

alter table maindata
 add column date_column date;


set sql_safe_updates=0;


update maindata 
set date_column = date(CONCAT(year, '-', month, '-', day));

select date_column from maindata; 


alter table maindata 
add column Month_name varchar(10);


update maindata 
set month_name = monthname(date_column);


alter table maindata
add column Quarter_column varchar(4);

update maindata 
set Quarter_column = quarter(date_column);


alter table maindata 
add column YearMonth varchar(15);


update maindata 
set YearMonth = date_format(date_column,'%Y %b');


alter table maindata 
add column Weekday_No Int;

update maindata 
set Weekday_No = IF(DAYOFWEEK(date_column) = 1, 7, DAYOFWEEK(date_column) - 1);

alter table maindata 
add column Week_day_Name VARCHAR(10);


UPDATE maindata
SET Week_day_Name = CASE
    WHEN DAYOFWEEK(date_column) = 1 THEN 'Sunday'
    WHEN DAYOFWEEK(date_column) = 2 THEN 'Monday'
    WHEN DAYOFWEEK(date_column) = 3 THEN 'Tuesday'
    WHEN DAYOFWEEK(date_column) = 4 THEN 'Wednesday'
    WHEN DAYOFWEEK(date_column) = 5 THEN 'Thursday'
    WHEN DAYOFWEEK(date_column) = 6 THEN 'Friday'
    ELSE 'Saturday'
END;


alter table maindata 
add column Financial_Month int;

UPDATE maindata
SET Financial_Month = 
    CASE 
        WHEN MONTH(date_column) >= 4 THEN MONTH(date_column) - 3
        ELSE MONTH(date_column) + 9
    END;

select year,month,day,date_column,Month_name,quarter_column,YearMonth,Weekday_No,Week_day_Name,Financial_Month 
from maindata;


ALTER TABLE maindata 
ADD COLUMN Financial_Quarter INT;

UPDATE maindata
SET Financial_Quarter = 
    CASE 
        WHEN month BETWEEN 1 AND 3 THEN 4
        WHEN month BETWEEN 4 AND 6 THEN 1
        WHEN month BETWEEN 7 AND 9 THEN 2
        ELSE 3
    END;


ALTER TABLE maindata 
ADD COLUMN Financial_Quarter_Text varchar(2);

UPDATE maindata
SET Financial_Quarter_Text = 
    CASE 
        WHEN month BETWEEN 1 AND 3 THEN 'Q4'
        WHEN month BETWEEN 4 AND 6 THEN 'Q1'
        WHEN month BETWEEN 7 AND 9 THEN 'Q2'
        ELSE 'Q3'
    END;

SELECT 
    year,
    month,
    day,
    date_column,
    Month_name,
    quarter_column,
    YearMonth,
    Weekday_No,
    Week_day_Name,
    Financial_Month,
    Financial_Quarter_Text
FROM
    maindata;
    
    
    /* Q.2 Load Factor Percentage on ayearly,Quarterly,Monthly Basis*/
    SELECT 
    YEAR(date_column) AS Year,
    QUARTER(date_column) AS Quarter,
    month AS Month,
SUM(transported_passengers) AS Total_Transported_Passengers,
    SUM(available_seats) AS Total_Available_Seats,
(SUM(Transported_Passengers) / SUM(Available_Seats)) * 100 AS Load_Factor_Percentage
from Maindata 
group by
YEAR(date_column), Quarter(date_column),month
order by
Year(date_column), Quarter(date_column),month;

alter table Maindata 
Rename column `Carrier Name` to Carrier_Name;
/*Q.3 Load Factor Percentage on a carrier Name Basis*/

Select Carrier_Name,
  SUM(Transported_Passengers) AS Total_Transported_passengers,
  SUM(Available_Seats) AS Total_Available_seats,
  (SUM(Transported_Passengers) / SUM(Available_Seats)) * 100 AS Load_Factor_Percentage
FROM Maindata 
GROUP BY Carrier_Name;

/*Q.4 Top 10 Carrier name Based passenger prefernce*/
Select Carrier_Name,
  SUM(Transported_Passengers) as Total_Transported_Passengers,
  SUM(Available_Seats) as  Total_Available_seats,
  (SUM(Transported_Passengers) / SUM(Available_Seats)) * 100 AS Load_Factor_Percentage 
  From Maindata
Group by 
Carrier_Name 
Order by Load_Factor_Percentage Desc limit 10;

/*Q.5 Display top routes (from-tocity) based on number of flights*/
SELECT From_To_City AS Route,
	SUM(Departures_Scheduled + Departures_Performed) AS No_Of_Flights
    FROM Maindata 
    GROUP BY Route 
    ORDER BY No_Of_Flights DESC LIMIT 10;
    
    /*Q.6 How much load factor is occupied on weekend vs weekday*/
    SELECT
    CASE WHEN DAYOFWEEK(date_column) IN (2, 3, 4, 5, 6) THEN 'Weekday' ELSE 'Weekend' 
    END AS Day_Type,
    Sum(Transported_Passengers) AS Total_Transported_pass,
  SUM(Available_Seats) AS Total_Available_seats,
  (sum(Transported_Passengers) / sum(Available_Seats)) * 100 AS Load_Factor_percentage
FROM Maindata 
GROUP BY Day_type;

/* Q.7 Number of flights based on distance group*/

SELECT 
    CASE 
        WHEN Distance BETWEEN 0 AND 500 THEN '0-500 miles'
        WHEN Distance BETWEEN 501 AND 1000 THEN '501-1000 miles'
        WHEN Distance BETWEEN 1001 AND 1500 THEN '1001-1500 miles'
        ELSE 'Over 1500 miles'
    END AS Distance_Group,
    COUNT(Departures_performed) AS Number_of_Flights
FROM 
    maindata 
GROUP BY 
    Distance_Group 
ORDER BY 
    Distance_Group;

    
