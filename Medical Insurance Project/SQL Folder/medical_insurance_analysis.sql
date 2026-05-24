-- =====================================================
-- PROJECT: MEDICAL INSURANCE COST ANALYSIS USING SQL
-- =====================================================


-- =========================================
--STEP 1 — Database Setup 
-- =========================================

create table insurance(patient_id int primary key, age int, sex char(10), bmi decimal(5,2), children int,
smoker char(10), region varchar(25), charges decimal(10,2), age_group varchar(15), bmi_category varchar(25));

--then CSV file import to database setup


-- =========================================
--STEP 2 — Data Exploration Queries
-- =========================================

--Query 1 — Total Records

Select count(*) as total_records 
from insurance;


--Query 2 — Unique Regions

Select distinct region as unique_region
from insurance;


--Query 3 — Check Null Values

select * from insurance
where bmi is null 
	or charges is null;



-- =========================================
--STEP 3 — Business Analysis Queries 
-- =========================================

--Query 1 — Average Charges by Smoker

select smoker, round(avg(charges),2) as avg_charges
from insurance
group by smoker;


--Query 2 — Region-wise Total Charges

select region,sum(charges) as total_charges
from insurance
group by region
order by total_charges desc;


--Query 3 — BMI Category Analysis

select bmi_category, round(avg(charges),2) as avg_charges
from insurance
group by bmi_category
order by avg_charges desc;


--Query 4 — Age Group Analysis

select age_group, round(avg(charges),2) as avg_charges
from insurance
group by age_group
order by avg_charges desc;


--Query 5 — Gender Analysis

select sex, round(avg(charges),2) as avg_charges
from insurance
group by sex;



-- =========================================
--STEP 4 — Advanced SQL Section 
-- =========================================

--Query 6 — Risk Category using CASE WHEN

select patient_id, smoker, bmi, charges,
	case
		when smoker = 'yes' and bmi >= 30 then 'High Risk'
		when bmi >= 25 then 'Medium Risk'
		else 'Low Risk'
		end as risk_category
from insurance;


--Query 7 — Top 5 Highest Charges

select * from insurance
order by charges desc
limit 5;


--Query 8 — Region-wise Ranking

select patient_id, region, charges,
	rank() over(
		partition by region 
		order by charges desc) as region_rank
from insurance;


--Query 9 — Patients Above Average Charges

select * from insurance
where charges >
			(select round(avg(charges), 2) 
			from insurance);


--Query 10 — CTE Analysis

with region_avg as
	(select region, round(avg(charges),2) as avg_charges
	from insurance
	group by region)

select * from region_avg
order by avg_charges desc;


--Query 11 — Highest Charges by Region

select * from
	(select patient_id, region, charges,
	rank() over(
		partition by region 
		order by charges desc) as region_rank
		from insurance) ranked_data
		where region_rank = 1;



-- =========================================		
--STEP 5 — Final Business Insights 
-- =========================================

--1. Smokers have significantly higher medical charges compared to non-smokers.
--2. Obese patients show higher average insurance costs.
--3. Senior age group has the highest average medical expenses.
--4. Southeast region contributes the highest total charges.
--5. High BMI and smoking together create high-risk patients.

-- =========================================
-- =========================================