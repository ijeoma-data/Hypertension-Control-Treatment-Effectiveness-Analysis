
/*===============================================================
Project: Hypertension Control & Treatment Effectiveness Analysis

Author: Ijeoma Okeke

Tools Used:
- SQL Server Management Studio
- Microsoft Excel

Project Objective:
To analyze hypertension treatment outcomes by evaluating
blood pressure control, medication adherence, treatment
effectiveness and blood pressure reduction after three months
of treatment.

===============================================================*/


--===================
--- Data Exploration:
--==================
--- 1. Preview Dataset

SELECT *
FROM dbo.Hypertension;

---2. Total Number of Records

SELECT COUNT(*) AS Total_Patients
FROM dbo.Hypertension;



SELECT TOP 5 *
FROM dbo.Hypertension;

--- 3. Preview the First Five Records

SELECT TOP 5 *
FROM dbo.Hypertension;

--=======================
--Data Quality Assessment
--=======================

-- 4. Check ForDuplicates Patient ID

SELECT
Patient_ID,
COUNT(*) AS Duplicate_Count
FROM dbo.Hypertension
GROUP BY Patient_ID
HAVING COUNT(*)>1;

--5. Check for Missing Values
SELECT
    COUNT(CASE WHEN Patient_ID IS NULL THEN 1 END) AS Missing_Patient_ID,
    COUNT(CASE WHEN Age IS NULL THEN 1 END) AS Missing_Age,
    COUNT(CASE WHEN Gender IS NULL THEN 1 END) AS Missing_Gender,
    COUNT(CASE WHEN Medication_Adherence IS NULL THEN 1 END) AS Missing_Adherence,
    COUNT(CASE WHEN BP_Controlled_After_3_Months IS NULL THEN 1 END) AS Missing_BP_Status
FROM dbo.Hypertension;

/*---------------------------------------------------------------
Data Quality Summary

• No duplicate Patient IDs were found.
• No missing values were detected in the key variables.
• The dataset was considered complete and suitable for analysis.

---------------------------------------------------------------*/


--- Business Questions:
--=====================================================================
-- How many patients achieved blood pressure control after three months?
--======================================================================
--- 6. Blood Pressure Control Distribution

SELECT
    CASE
        WHEN BP_Controlled_After_3_Months = 1 THEN 'Controlled'
        ELSE 'Not Controlled'
    END AS BP_Status,

    COUNT(*) AS Patient_Count,

    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER()
        AS DECIMAL(5,2)
    ) AS Percentage

FROM dbo.Hypertension

GROUP BY BP_Controlled_After_3_Months;

--==============================================================
-- Does medication adherence influence blood pressure control?
--==============================================================
--- 7. Medication Adherence vs BP Control

SELECT

Medication_Adherence,

COUNT(*) AS Total_Patients,

SUM(CASE
WHEN BP_Controlled_After_3_Months = 1
THEN 1
ELSE 0
END) AS Controlled,

SUM(CASE
WHEN BP_Controlled_After_3_Months = 0
THEN 1
ELSE 0
END) AS Not_Controlled,

CAST(

SUM(CASE
WHEN BP_Controlled_After_3_Months = 1
THEN 1
ELSE 0
END)

*100.0/COUNT(*)

AS DECIMAL(5,2)

) AS Control_Rate_Percentage

FROM dbo.Hypertension

GROUP BY Medication_Adherence

ORDER BY

CASE Medication_Adherence

WHEN 'Good' THEN 1
WHEN 'Moderate' THEN 2
WHEN 'Poor' THEN 3

END;

-- ==================================================================================
-- Which antihypertensive drug class achieved the highest blood pressure control rate?
-- ===================================================================================
--- 8. Drug Class Effectiveness

SELECT

    Antihypertensive_Class,

    COUNT(*) AS Total_Patients,

    SUM(CASE
            WHEN BP_Controlled_After_3_Months = 1 THEN 1
            ELSE 0
        END) AS Controlled,

    CAST(

        SUM(CASE
                WHEN BP_Controlled_After_3_Months = 1 THEN 1
                ELSE 0
            END) *100.0

        / COUNT(*)

        AS DECIMAL(5,2)

    ) AS Control_Rate_Percentage

FROM dbo.Hypertension

GROUP BY Antihypertensive_Class

ORDER BY Control_Rate_Percentage DESC;

---Preparing Data for Excel Dashboard

/*===============================================================

The SQL analysis generated the summary statistics used for
dashboard development.

The following transformations were completed in Microsoft Excel:

• Created the Age_Group calculated column.
• Created the Diastolic_Reduction calculated column.
• Built PivotTables.
• Created PivotCharts.
• Designed KPI cards.
• Added interactive slicers.
• Developed the final interactive dashboard.

===============================================================*/

/*===============================================================

KEY FINDINGS

• A total of 350 patient records were analyzed.

• Only 9.43% of patients achieved blood pressure control
  after three months.

• Combination Therapy recorded the highest treatment
  success rate.

• Patients with good medication adherence achieved
  better blood pressure control than those with
  moderate or poor adherence.

• SQL Server was used for data exploration and analysis,
  while Microsoft Excel was used for calculated fields,
  dashboard development, and data visualization.

===============================================================*/
