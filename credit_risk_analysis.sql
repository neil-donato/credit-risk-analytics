-- ---------------------------
-- Create Database
-- ---------------------------
CREATE DATABASE credit_risk_db;
USE credit_risk_db;


-- ---------------------------
-- Create Tables
-- ---------------------------
CREATE TABLE stg_customers (
    customer_id VARCHAR(20),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth VARCHAR(20),
    gender VARCHAR(20),
    civil_status VARCHAR(30),
    province VARCHAR(50),
    employment_status VARCHAR(50),
    monthly_income_php VARCHAR(30),
    registration_date DATE
);

CREATE TABLE stg_credit_history (
    credit_history_id VARCHAR(20),
    customer_id VARCHAR(20),
    snapshot_date DATE,
    credit_score INT,
    prior_loan_count INT,
    previous_missed_payments INT,
    credit_utilization DECIMAL(6,4),
    prior_default_flag VARCHAR(10),
    bureau_source VARCHAR(50)
);

CREATE TABLE stg_loan_applications (
    application_id VARCHAR(20),
    customer_id VARCHAR(20),
    application_date DATE,
    requested_amount_php DECIMAL(15,2),
    requested_term_months INT,
    application_channel VARCHAR(50),
    application_status VARCHAR(30),
    internal_risk_score DECIMAL(6,2),
    loan_purpose VARCHAR(50)
);

CREATE TABLE stg_loans (
    loan_id VARCHAR(20),
    application_id VARCHAR(20),
    customer_id VARCHAR(20),
    disbursement_date DATE,
    principal_php DECIMAL(15,2),
    annual_interest_rate DECIMAL(8,4),
    term_months INT,
    scheduled_monthly_payment_php DECIMAL(15,2),
    currency VARCHAR(10)
);

CREATE TABLE stg_repayments (
    repayment_id VARCHAR(30),
    loan_id VARCHAR(30),
    installment_number VARCHAR(20),
    due_date VARCHAR(30),
    scheduled_amount_php VARCHAR(50),
    payment_date VARCHAR(30),
    paid_amount_php VARCHAR(50),
    payment_status VARCHAR(50)
);


-- ---------------------------
-- Check the Tables
-- ---------------------------
SELECT * FROM stg_customers;
SELECT * FROM stg_credit_history;
SELECT * FROM stg_loan_applications;
SELECT * FROM stg_loans;
SELECT * FROM stg_repayments;


-- -----------------------------------
-- Inspect the Structure of Datasets
-- -----------------------------------
DESCRIBE stg_customers;
DESCRIBE stg_credit_history;
DESCRIBE stg_loan_applications;
DESCRIBE stg_loans;
DESCRIBE stg_repayments;


-- ------------------------
-- Identify Duplicate Rows
-- ------------------------
SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM stg_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT
    credit_history_id,
    COUNT(*) AS duplicate_count
FROM stg_credit_history
GROUP BY credit_history_id
HAVING COUNT(*) > 1;

SELECT
    application_id,
    COUNT(*) AS duplicate_count
FROM stg_loan_applications
GROUP BY application_id
HAVING COUNT(*) > 1;

SELECT
    loan_id,
    COUNT(*) AS duplicate_count
FROM stg_loans
GROUP BY loan_id
HAVING COUNT(*) > 1;

SELECT
    repayment_id,
    COUNT(*) AS duplicate_count
FROM stg_repayments
GROUP BY repayment_id
HAVING COUNT(*) > 1;


-- ---------------------
-- Check Missing Values
-- ---------------------
SELECT
    'Customers' AS table_name,
    COUNT(*) AS total_records,
    SUM(customer_id IS NULL OR TRIM(customer_id) = '') AS missing_customer_id,
    SUM(first_name IS NULL OR TRIM(first_name) = '') AS missing_first_name,
    SUM(last_name IS NULL OR TRIM(last_name) = '') AS missing_last_name,
    SUM(date_of_birth IS NULL OR TRIM(date_of_birth) = '') AS missing_birth_date,
    SUM(gender IS NULL OR TRIM(gender) = '') AS missing_gender,
    SUM(civil_status IS NULL OR TRIM(civil_status) = '') AS missing_civil_status,
    SUM(province IS NULL OR TRIM(province) = '') AS missing_province,
    SUM(employment_status IS NULL OR TRIM(employment_status) = '') AS missing_employment,
    SUM(monthly_income_php IS NULL OR TRIM(monthly_income_php) = '') AS missing_income,
    SUM(registration_date IS NULL) AS missing_registration_date
FROM stg_customers;

SELECT
    'Credit History' AS table_name,
    COUNT(*) AS total_records,
    SUM(credit_history_id IS NULL OR TRIM(credit_history_id) = '') AS missing_history_id,
    SUM(customer_id IS NULL OR TRIM(customer_id) = '') AS missing_customer_id,
    SUM(snapshot_date IS NULL) AS missing_snapshot_date,
    SUM(credit_score IS NULL) AS missing_credit_score,
    SUM(prior_loan_count IS NULL) AS missing_prior_loans,
    SUM(previous_missed_payments IS NULL) AS missing_missed_payments,
    SUM(credit_utilization IS NULL) AS missing_credit_utilization,
    SUM(prior_default_flag IS NULL OR TRIM(prior_default_flag) = '') AS missing_default_flag,
    SUM(bureau_source IS NULL OR TRIM(bureau_source) = '') AS missing_bureau_source
FROM stg_credit_history;

SELECT
    'Loan Applications' AS table_name,
    COUNT(*) AS total_records,
    SUM(application_id IS NULL OR TRIM(application_id) = '') AS missing_application_id,
    SUM(customer_id IS NULL OR TRIM(customer_id) = '') AS missing_customer_id,
    SUM(application_date IS NULL) AS missing_application_date,
    SUM(requested_amount_php IS NULL) AS missing_requested_amount,
    SUM(requested_term_months IS NULL) AS missing_term,
    SUM(application_channel IS NULL OR TRIM(application_channel) = '') AS missing_channel,
    SUM(application_status IS NULL OR TRIM(application_status) = '') AS missing_status,
    SUM(internal_risk_score IS NULL) AS missing_risk_score,
    SUM(loan_purpose IS NULL OR TRIM(loan_purpose) = '') AS missing_loan_purpose
FROM stg_loan_applications;

SELECT
    'Loans' AS table_name,
    COUNT(*) AS total_records,
    SUM(loan_id IS NULL OR TRIM(loan_id) = '') AS missing_loan_id,
    SUM(application_id IS NULL OR TRIM(application_id) = '') AS missing_application_id,
    SUM(customer_id IS NULL OR TRIM(customer_id) = '') AS missing_customer_id,
    SUM(disbursement_date IS NULL) AS missing_disbursement_date,
    SUM(principal_php IS NULL) AS missing_principal,
    SUM(annual_interest_rate IS NULL) AS missing_interest_rate,
    SUM(term_months IS NULL) AS missing_term,
    SUM(scheduled_monthly_payment_php IS NULL) AS missing_monthly_payment,
    SUM(currency IS NULL OR TRIM(currency) = '') AS missing_currency
FROM stg_loans;

SELECT
    'Repayments' AS table_name,
    COUNT(*) AS total_records,
    SUM(repayment_id IS NULL OR TRIM(repayment_id) = '') AS missing_repayment_id,
    SUM(loan_id IS NULL OR TRIM(loan_id) = '') AS missing_loan_id,
    SUM(installment_number IS NULL OR TRIM(installment_number) = '') AS missing_installment,
    SUM(due_date IS NULL OR TRIM(due_date) = '') AS missing_due_date,
    SUM(scheduled_amount_php IS NULL OR TRIM(scheduled_amount_php) = '') AS missing_scheduled_amount,
    SUM(payment_date IS NULL OR TRIM(payment_date) = '') AS missing_payment_date,
    SUM(paid_amount_php IS NULL OR TRIM(paid_amount_php) = '') AS missing_paid_amount,
    SUM(payment_status IS NULL OR TRIM(payment_status) = '') AS missing_payment_status
FROM stg_repayments;


-- ---------------------------------
-- Data Cleaning and Transformation
-- ---------------------------------
DROP TABLE IF EXISTS dim_customers;
DROP TABLE IF EXISTS dim_credit_history;
DROP TABLE IF EXISTS fact_loan_applications;
DROP TABLE IF EXISTS fact_loans;
DROP TABLE IF EXISTS fact_repayments;

CREATE TABLE dim_customers AS
SELECT
    NULLIF(TRIM(customer_id), '') AS customer_id,
    NULLIF(TRIM(first_name), '') AS first_name,
    NULLIF(TRIM(last_name), '') AS last_name,

    CASE
        WHEN REPLACE(TRIM(date_of_birth), '/', '-')
             REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        THEN STR_TO_DATE(
            REPLACE(TRIM(date_of_birth), '/', '-'),
            '%Y-%m-%d'
        )
        ELSE NULL
    END AS date_of_birth,

    CASE
        WHEN LOWER(TRIM(gender)) IN ('male', 'm')
            THEN 'Male'
        WHEN LOWER(TRIM(gender)) IN ('female', 'f')
            THEN 'Female'
        ELSE 'Unknown'
    END AS gender,

    NULLIF(TRIM(civil_status), '') AS civil_status,
    NULLIF(TRIM(province), '') AS province,
    NULLIF(TRIM(employment_status), '') AS employment_status,

    CASE
        WHEN REPLACE(TRIM(monthly_income_php), ',', '')
             REGEXP '^[0-9]+([.][0-9]{1,2})?$'
        THEN CAST(
            REPLACE(TRIM(monthly_income_php), ',', '')
            AS DECIMAL(15,2)
        )
        ELSE NULL
    END AS monthly_income_php,

    registration_date

FROM stg_customers;

CREATE TABLE dim_credit_history AS
SELECT
    NULLIF(TRIM(credit_history_id), '') AS credit_history_id,
    NULLIF(TRIM(customer_id), '') AS customer_id,

    snapshot_date,

    CASE
        WHEN credit_score BETWEEN 300 AND 850
        THEN credit_score
        ELSE NULL
    END AS credit_score,

    CASE
        WHEN prior_loan_count >= 0
        THEN prior_loan_count
        ELSE NULL
    END AS prior_loan_count,

    CASE
        WHEN previous_missed_payments >= 0
        THEN previous_missed_payments
        ELSE NULL
    END AS previous_missed_payments,

    CASE
        WHEN credit_utilization BETWEEN 0 AND 1
        THEN credit_utilization
        ELSE NULL
    END AS credit_utilization,

    CASE
        WHEN LOWER(TRIM(prior_default_flag))
             IN ('yes', 'y', '1', 'true')
        THEN 1
        WHEN LOWER(TRIM(prior_default_flag))
             IN ('no', 'n', '0', 'false')
        THEN 0
        ELSE NULL
    END AS prior_default_flag,

    NULLIF(TRIM(bureau_source), '') AS bureau_source

FROM stg_credit_history;

CREATE TABLE fact_loan_applications AS
SELECT
    NULLIF(TRIM(application_id), '') AS application_id,
    NULLIF(TRIM(customer_id), '') AS customer_id,

    application_date,

    CASE
        WHEN requested_amount_php > 0
        THEN requested_amount_php
        ELSE NULL
    END AS requested_amount_php,

    CASE
        WHEN requested_term_months > 0
        THEN requested_term_months
        ELSE NULL
    END AS requested_term_months,

    NULLIF(
        LOWER(TRIM(application_channel)), ''
    ) AS application_channel,

    NULLIF(
        LOWER(TRIM(application_status)), ''
    ) AS application_status,

    internal_risk_score,

    NULLIF(
        LOWER(TRIM(loan_purpose)), ''
    ) AS loan_purpose

FROM stg_loan_applications;

CREATE TABLE fact_loans AS
SELECT
    NULLIF(TRIM(loan_id), '') AS loan_id,
    NULLIF(TRIM(application_id), '') AS application_id,
    NULLIF(TRIM(customer_id), '') AS customer_id,

    disbursement_date,

    CASE
        WHEN principal_php > 0
        THEN principal_php
        ELSE NULL
    END AS principal_php,

    CASE
        WHEN annual_interest_rate BETWEEN 0 AND 1
        THEN annual_interest_rate
        ELSE NULL
    END AS annual_interest_rate,

    CASE
        WHEN term_months > 0
        THEN term_months
        ELSE NULL
    END AS term_months,

    CASE
        WHEN scheduled_monthly_payment_php > 0
        THEN scheduled_monthly_payment_php
        ELSE NULL
    END AS scheduled_monthly_payment_php,

    UPPER(NULLIF(TRIM(currency), '')) AS currency

FROM stg_loans;

CREATE TABLE fact_repayments AS
SELECT
    NULLIF(TRIM(repayment_id), '') AS repayment_id,
    NULLIF(TRIM(loan_id), '') AS loan_id,

    CASE
        WHEN TRIM(installment_number)
             REGEXP '^[0-9]+$'
        THEN CAST(
            installment_number AS UNSIGNED
        )
        ELSE NULL
    END AS installment_number,

    CASE
        WHEN TRIM(due_date)
             REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        THEN STR_TO_DATE(TRIM(due_date), '%Y-%m-%d')
        ELSE NULL
    END AS due_date,

    CASE
        WHEN REPLACE(TRIM(scheduled_amount_php), ',', '')
             REGEXP '^[0-9]+([.][0-9]{1,2})?$'
        THEN CAST(
            REPLACE(TRIM(scheduled_amount_php), ',', '')
            AS DECIMAL(15,2)
        )
        ELSE NULL
    END AS scheduled_amount_php,

    CASE
        WHEN TRIM(payment_date)
             REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        THEN STR_TO_DATE(TRIM(payment_date), '%Y-%m-%d')
        ELSE NULL
    END AS payment_date,

    CASE
        WHEN REPLACE(TRIM(paid_amount_php), ',', '')
             REGEXP '^[0-9]+([.][0-9]{1,2})?$'
        THEN CAST(
            REPLACE(TRIM(paid_amount_php), ',', '')
            AS DECIMAL(15,2)
        )
        ELSE NULL
    END AS paid_amount_php,

    NULLIF(
        LOWER(TRIM(payment_status)), ''
    ) AS payment_status

FROM stg_repayments;


-- ---------------------------
-- Summary of Cleaned Records
-- ---------------------------
SELECT
    'Customers' AS table_name,
    (SELECT COUNT(*) FROM stg_customers) AS raw_records,
    (SELECT COUNT(*) FROM dim_customers) AS cleaned_records
UNION ALL
SELECT
    'Credit History',
    (SELECT COUNT(*) FROM stg_credit_history),
    (SELECT COUNT(*) FROM dim_credit_history)
UNION ALL
SELECT
    'Loan Applications',
    (SELECT COUNT(*) FROM stg_loan_applications),
    (SELECT COUNT(*) FROM fact_loan_applications)
UNION ALL
SELECT
    'Loans',
    (SELECT COUNT(*) FROM stg_loans),
    (SELECT COUNT(*) FROM fact_loans)
UNION ALL
SELECT
    'Repayments',
    (SELECT COUNT(*) FROM stg_repayments),
    (SELECT COUNT(*) FROM fact_repayments);


-- -----------------
-- Check the Tables
-- -----------------
SELECT * FROM dim_customers;
SELECT * FROM dim_credit_history;
SELECT * FROM fact_loan_applications;
SELECT * FROM fact_loans;
SELECT * FROM fact_repayments;


-- --------------------------
-- Exploratory Data Analysis 
-- --------------------------

-- 1. TOTAL CUSTOMERS
SELECT
    COUNT(DISTINCT customer_id) AS total_customers
FROM dim_customers;

-- 2. CUSTOMER DISTRIBUTION BY GENDER
SELECT
    gender,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(
        COUNT(DISTINCT customer_id) * 100.0 /
        SUM(COUNT(DISTINCT customer_id)) OVER (),
        2
    ) AS percentage
FROM dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- 3. CUSTOMER DISTRIBUTION BY EMPLOYMENT STATUS
SELECT
    employment_status,
    COUNT(DISTINCT customer_id) AS total_customers
FROM dim_customers
GROUP BY employment_status
ORDER BY total_customers DESC;

-- 4. AVERAGE MONTHLY INCOME BY EMPLOYMENT STATUS
SELECT
    employment_status,
    COUNT(*) AS total_records,
    ROUND(AVG(monthly_income_php), 2) AS avg_monthly_income,
    ROUND(MIN(monthly_income_php), 2) AS min_income,
    ROUND(MAX(monthly_income_php), 2) AS max_income
FROM dim_customers
WHERE monthly_income_php IS NOT NULL
GROUP BY employment_status
ORDER BY avg_monthly_income DESC;

-- 5. LOAN APPLICATION STATUS DISTRIBUTION
SELECT
    application_status,
    COUNT(*) AS total_applications,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM fact_loan_applications
GROUP BY application_status
ORDER BY total_applications DESC;

-- 6. LOAN APPROVAL RATE
SELECT
    COUNT(*) AS total_applications,

    SUM(
        CASE
            WHEN application_status = 'approved'
            THEN 1 ELSE 0
        END
    ) AS approved_applications,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN application_status = 'approved'
                THEN 1 ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS approval_rate_pct

FROM fact_loan_applications;

-- 7. APPROVAL RATE BY APPLICATION CHANNEL
SELECT
    application_channel,
    COUNT(*) AS total_applications,

    SUM(
        CASE
            WHEN application_status = 'approved'
            THEN 1 ELSE 0
        END
    ) AS approved_applications,

    ROUND(
        100.0 * AVG(
            CASE
                WHEN application_status = 'approved'
                THEN 1.0 ELSE 0.0
            END
        ),
        2
    ) AS approval_rate_pct

FROM fact_loan_applications
GROUP BY application_channel
ORDER BY approval_rate_pct DESC;

-- 8. LOAN PORTFOLIO SUMMARY
SELECT
    COUNT(*) AS total_loans,
    COUNT(DISTINCT customer_id) AS total_borrowers,
    ROUND(SUM(principal_php), 2) AS total_disbursed_php,
    ROUND(AVG(principal_php), 2) AS avg_loan_amount_php,
    ROUND(AVG(annual_interest_rate) * 100, 2)
        AS avg_annual_interest_rate_pct,
    ROUND(AVG(term_months), 2) AS avg_loan_term_months
FROM fact_loans;

-- 9. MONTHLY LOAN DISBURSEMENT TREND
SELECT
    DATE_FORMAT(disbursement_date, '%Y-%m') AS disbursement_month,
    COUNT(*) AS total_loans,
    ROUND(SUM(principal_php), 2) AS total_disbursed_php
FROM fact_loans
WHERE disbursement_date IS NOT NULL
GROUP BY DATE_FORMAT(disbursement_date, '%Y-%m')
ORDER BY disbursement_month;

-- 10. CREDIT SCORE DISTRIBUTION
SELECT
    CASE
        WHEN credit_score BETWEEN 300 AND 579 THEN 'Poor'
        WHEN credit_score BETWEEN 580 AND 669 THEN 'Fair'
        WHEN credit_score BETWEEN 670 AND 739 THEN 'Good'
        WHEN credit_score BETWEEN 740 AND 799 THEN 'Very Good'
        WHEN credit_score BETWEEN 800 AND 850 THEN 'Excellent'
        ELSE 'Unknown'
    END AS credit_score_category,

    COUNT(*) AS total_credit_records,
    ROUND(AVG(credit_score), 2) AS avg_credit_score

FROM dim_credit_history
GROUP BY credit_score_category
ORDER BY MIN(credit_score);

-- 11. REPAYMENT STATUS DISTRIBUTION
SELECT
    payment_status,
    COUNT(*) AS total_installments,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage

FROM fact_repayments
GROUP BY payment_status
ORDER BY total_installments DESC;

-- 12. REPAYMENT COLLECTION SUMMARY
SELECT
    COUNT(*) AS total_repayment_records,

    ROUND(
        SUM(scheduled_amount_php), 2
    ) AS total_scheduled_php,

    ROUND(
        SUM(paid_amount_php), 2
    ) AS total_paid_php,

    ROUND(
        100.0 * SUM(paid_amount_php) /
        NULLIF(SUM(scheduled_amount_php), 0),
        2
    ) AS collection_ratio_pct

FROM fact_repayments;


--------------------------
-- Credit Risk Analytics
--------------------------

-- 1. CREATE INSTALLMENT-LEVEL DAYS PAST DUE
DROP VIEW IF EXISTS vw_repayment_dpd;
CREATE VIEW vw_repayment_dpd AS
SELECT
    repayment_id,
    loan_id,
    installment_number,
    due_date,
    payment_date,
    scheduled_amount_php,
    paid_amount_php,
    payment_status,

    CASE
        WHEN due_date IS NULL THEN NULL

        -- Fully paid on or before due date
        WHEN COALESCE(paid_amount_php, 0) >= scheduled_amount_php
             AND payment_date <= due_date
        THEN 0

        -- Fully paid after due date
        WHEN COALESCE(paid_amount_php, 0) >= scheduled_amount_php
             AND payment_date > due_date
        THEN DATEDIFF(payment_date, due_date)

        -- Unpaid or partially paid, not yet due
        WHEN due_date >= CURRENT_DATE()
        THEN 0

        -- Unpaid or partially paid, overdue
        ELSE DATEDIFF(CURRENT_DATE(), due_date)

    END AS days_past_due
FROM fact_repayments;

-- 2. CLASSIFY INSTALLMENTS INTO DELINQUENCY BUCKETS
DROP VIEW IF EXISTS vw_repayment_delinquency;
CREATE VIEW vw_repayment_delinquency AS
SELECT
    *,
    CASE
        WHEN days_past_due IS NULL THEN 'Unknown'
        WHEN days_past_due = 0 THEN 'Current'
        WHEN days_past_due BETWEEN 1 AND 30 THEN '1-30 DPD'
        WHEN days_past_due BETWEEN 31 AND 60 THEN '31-60 DPD'
        WHEN days_past_due BETWEEN 61 AND 90 THEN '61-90 DPD'
        ELSE '90+ DPD'
    END AS delinquency_bucket
FROM vw_repayment_dpd;

-- 3. DELINQUENCY DISTRIBUTION
SELECT
    delinquency_bucket,
    COUNT(*) AS total_installments,
    ROUND(SUM(scheduled_amount_php), 2)
        AS total_scheduled_php
FROM vw_repayment_delinquency
GROUP BY delinquency_bucket
ORDER BY
    CASE delinquency_bucket
        WHEN 'Current' THEN 1
        WHEN '1-30 DPD' THEN 2
        WHEN '31-60 DPD' THEN 3
        WHEN '61-90 DPD' THEN 4
        WHEN '90+ DPD' THEN 5
        ELSE 6
    END;

-- 4. LOAN-LEVEL MAXIMUM DPD
DROP VIEW IF EXISTS vw_loan_dpd;
CREATE VIEW vw_loan_dpd AS
SELECT
    loan_id,
    MAX(days_past_due) AS max_days_past_due
FROM vw_repayment_dpd
GROUP BY loan_id;

-- 5. LOAN-LEVEL DELINQUENCY CLASSIFICATION
SELECT
    loan_id,
    max_days_past_due,

    CASE
        WHEN max_days_past_due IS NULL THEN 'Unknown'
        WHEN max_days_past_due = 0 THEN 'Current'
        WHEN max_days_past_due BETWEEN 1 AND 30 THEN '1-30 DPD'
        WHEN max_days_past_due BETWEEN 31 AND 60 THEN '31-60 DPD'
        WHEN max_days_past_due BETWEEN 61 AND 90 THEN '61-90 DPD'
        ELSE '90+ DPD'
    END AS loan_delinquency_bucket
FROM vw_loan_dpd;

-- 6. DELINQUENT LOAN COUNTS
SELECT
    COUNT(*) AS total_loans,

    SUM(max_days_past_due >= 1) AS loans_1plus_dpd,
    SUM(max_days_past_due >= 30) AS loans_30plus_dpd,
    SUM(max_days_past_due >= 60) AS loans_60plus_dpd,
    SUM(max_days_past_due >= 90) AS loans_90plus_dpd
FROM vw_loan_dpd;

-- 7. PROXY PAR30 / PAR60 / PAR90 (Uses original principal, NOT outstanding balance)
SELECT
    ROUND(
        100.0 * SUM(
            CASE WHEN d.max_days_past_due >= 30
                 THEN l.principal_php ELSE 0 END
        ) / NULLIF(SUM(l.principal_php), 0),
        2
    ) AS principal_weighted_30plus_pct,

    ROUND(
        100.0 * SUM(
            CASE WHEN d.max_days_past_due >= 60
                 THEN l.principal_php ELSE 0 END
        ) / NULLIF(SUM(l.principal_php), 0),
        2
    ) AS principal_weighted_60plus_pct,

    ROUND(
        100.0 * SUM(
            CASE WHEN d.max_days_past_due >= 90
                 THEN l.principal_php ELSE 0 END
        ) / NULLIF(SUM(l.principal_php), 0),
        2
    ) AS principal_weighted_90plus_pct

FROM fact_loans l
LEFT JOIN vw_loan_dpd d
    ON l.loan_id = d.loan_id;

-- 8. DELINQUENCY RATE BY LOAN PURPOSE
SELECT
    a.loan_purpose,
    COUNT(DISTINCT l.loan_id) AS total_loans,

    COUNT(DISTINCT CASE
        WHEN d.max_days_past_due >= 30
        THEN l.loan_id
    END) AS delinquent_loans_30plus,

    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN d.max_days_past_due >= 30
            THEN l.loan_id
        END) / NULLIF(COUNT(DISTINCT l.loan_id), 0),
        2
    ) AS delinquency_rate_pct

FROM fact_loans l
JOIN fact_loan_applications a
    ON l.application_id = a.application_id
LEFT JOIN vw_loan_dpd d
    ON l.loan_id = d.loan_id

GROUP BY a.loan_purpose
ORDER BY delinquency_rate_pct DESC;

-- 9. MONTHLY LOAN ORIGINATION COHORTS
SELECT
    DATE_FORMAT(disbursement_date, '%Y-%m') AS vintage_month,
    COUNT(*) AS loans_originated,
    ROUND(SUM(principal_php), 2) AS originated_principal_php

FROM fact_loans
WHERE disbursement_date IS NOT NULL
GROUP BY DATE_FORMAT(disbursement_date, '%Y-%m')
ORDER BY vintage_month;

-- 10. VINTAGE DELINQUENCY ANALYSIS
SELECT
    DATE_FORMAT(l.disbursement_date, '%Y-%m') AS vintage_month,
COUNT(*) AS total_loans,

    SUM(
        CASE WHEN d.max_days_past_due >= 30
             THEN 1 ELSE 0 END
    ) AS loans_30plus_dpd,

    ROUND(
        100.0 * AVG(
            CASE WHEN d.max_days_past_due >= 30
                 THEN 1.0 ELSE 0.0 END
        ),
        2
    ) AS vintage_30plus_rate_pct

FROM fact_loans l
LEFT JOIN vw_loan_dpd d
    ON l.loan_id = d.loan_id

WHERE l.disbursement_date IS NOT NULL
GROUP BY DATE_FORMAT(l.disbursement_date, '%Y-%m')
ORDER BY vintage_month;

-- 11. RANK HIGHEST-RISK LOANS
WITH loan_risk AS (
    SELECT
        l.loan_id,
        l.customer_id,
        l.principal_php,
        d.max_days_past_due
    FROM fact_loans l
    LEFT JOIN vw_loan_dpd d
        ON l.loan_id = d.loan_id
)

SELECT
    *,
    DENSE_RANK() OVER (
        ORDER BY max_days_past_due DESC
    ) AS risk_rank

FROM loan_risk
ORDER BY risk_rank, principal_php DESC
LIMIT 20;

-- 12. CUSTOMER-LEVEL DELINQUENCY SUMMARY
SELECT
    l.customer_id,
    COUNT(DISTINCT l.loan_id) AS total_loans,

    ROUND(SUM(l.principal_php), 2)
        AS total_principal_php,

    MAX(d.max_days_past_due) AS worst_dpd,

    SUM(
        CASE WHEN d.max_days_past_due >= 30
             THEN 1 ELSE 0 END
    ) AS loans_30plus_dpd

FROM fact_loans l
LEFT JOIN vw_loan_dpd d
    ON l.loan_id = d.loan_id

GROUP BY l.customer_id
ORDER BY worst_dpd DESC;


-- --------------------------------
-- Stored Functions and Procedures
-- --------------------------------
DROP PROCEDURE IF EXISTS sp_delinquency_report;
DROP PROCEDURE IF EXISTS sp_customer_loan_history;
DROP PROCEDURE IF EXISTS sp_loan_portfolio_summary;

DROP FUNCTION IF EXISTS fn_dpd;
DROP FUNCTION IF EXISTS fn_delinquency_bucket;
DROP FUNCTION IF EXISTS fn_risk_category;

DELIMITER $$

-- -----------------------------------
-- Function 1: Calculate Days Past Due
-- -----------------------------------
CREATE FUNCTION fn_dpd(
    p_due_date DATE,
    p_payment_date DATE,
    p_report_date DATE
)
RETURNS INT
DETERMINISTIC
NO SQL
BEGIN
    DECLARE v_dpd INT DEFAULT 0;

    IF p_due_date IS NULL OR p_report_date IS NULL THEN
        RETURN NULL;
    END IF;

    IF p_payment_date IS NOT NULL
       AND p_payment_date <= p_report_date THEN

        SET v_dpd = GREATEST(
            DATEDIFF(p_payment_date, p_due_date), 0
        );

    ELSE
        SET v_dpd = GREATEST(
            DATEDIFF(p_report_date, p_due_date), 0
        );
    END IF;

    RETURN v_dpd;
END$$

DELIMITER ;

-- --------------------------------
-- Function 2: Deliquency Bucket
-- --------------------------------
DELIMITER $$
CREATE FUNCTION fn_delinquency_bucket(
    p_dpd INT
)
RETURNS VARCHAR(20)
DETERMINISTIC
NO SQL
BEGIN
    RETURN CASE
        WHEN p_dpd IS NULL THEN 'Unknown'
        WHEN p_dpd = 0 THEN 'Current'
        WHEN p_dpd BETWEEN 1 AND 30 THEN '1-30 DPD'
        WHEN p_dpd BETWEEN 31 AND 60 THEN '31-60 DPD'
        WHEN p_dpd BETWEEN 61 AND 90 THEN '61-90 DPD'
        ELSE '90+ DPD'
    END;
END$$

DELIMITER ;

-- -------------------------
-- Function 3: Risk Category
-- -------------------------
DROP FUNCTION IF EXISTS fn_risk_category;
DELIMITER $$
CREATE FUNCTION fn_risk_category(
    p_credit_score INT
)
RETURNS VARCHAR(20)
DETERMINISTIC
NO SQL
BEGIN
    DECLARE v_category VARCHAR(20);

    IF p_credit_score IS NULL THEN
        SET v_category = 'Unknown';

    ELSEIF p_credit_score < 300
        OR p_credit_score > 850 THEN
        SET v_category = 'Invalid';

    ELSEIF p_credit_score < 580 THEN
        SET v_category = 'Poor';

    ELSEIF p_credit_score < 670 THEN
        SET v_category = 'Fair';

    ELSEIF p_credit_score < 740 THEN
        SET v_category = 'Good';

    ELSEIF p_credit_score < 800 THEN
        SET v_category = 'Very Good';

    ELSE
        SET v_category = 'Excellent';
    END IF;

    RETURN v_category;
END$$

DELIMITER ;

-- -----------------------------------
-- Procedure 1: Loan Portfolio Summary
-- -----------------------------------
DROP PROCEDURE IF EXISTS sp_loan_portfolio_summary;
DELIMITER $$
CREATE PROCEDURE sp_loan_portfolio_summary()
BEGIN

    SELECT
        COUNT(*) AS total_loans,

        COUNT(DISTINCT customer_id)
            AS total_borrowers,

        ROUND(
            SUM(principal_php), 2
        ) AS total_disbursed_php,

        ROUND(
            AVG(principal_php), 2
        ) AS avg_loan_amount_php,

        ROUND(
            MIN(principal_php), 2
        ) AS min_loan_amount_php,

        ROUND(
            MAX(principal_php), 2
        ) AS max_loan_amount_php,

        ROUND(
            AVG(annual_interest_rate) * 100, 2
        ) AS avg_interest_rate_pct,

        ROUND(
            AVG(term_months), 2
        ) AS avg_loan_term_months

    FROM fact_loans;

END$$

DELIMITER ;

-- -------------------------------------------
-- Procedure 2: Classify Customer Loan History
-- -------------------------------------------
DROP PROCEDURE IF EXISTS sp_customer_loan_history;
DELIMITER $$
CREATE PROCEDURE sp_customer_loan_history(
    IN p_customer_id VARCHAR(20)
)
BEGIN

    SELECT
        l.customer_id,
        l.loan_id,
        l.application_id,
        l.disbursement_date,
        l.principal_php,
        l.annual_interest_rate,
        l.term_months,
        l.scheduled_monthly_payment_php,

        COUNT(r.repayment_id) AS total_installments,

        COALESCE(
            SUM(r.scheduled_amount_php), 0
        ) AS total_scheduled_php,

        COALESCE(
            SUM(r.paid_amount_php), 0
        ) AS total_paid_php,

        ROUND(
            100.0 * SUM(r.paid_amount_php) /
            NULLIF(SUM(r.scheduled_amount_php), 0),
            2
        ) AS payment_ratio_pct

    FROM fact_loans l

    LEFT JOIN fact_repayments r
        ON l.loan_id = r.loan_id

    WHERE l.customer_id = p_customer_id

    GROUP BY
        l.customer_id,
        l.loan_id,
        l.application_id,
        l.disbursement_date,
        l.principal_php,
        l.annual_interest_rate,
        l.term_months,
        l.scheduled_monthly_payment_php

    ORDER BY l.disbursement_date DESC;

END$$

DELIMITER ;

-- ------------------------------
-- Procedure 3: Deliquency Report
-- ------------------------------
DROP PROCEDURE IF EXISTS sp_delinquency_report;
DELIMITER $$
CREATE PROCEDURE sp_delinquency_report(
    IN p_report_date DATE
)
BEGIN

    IF p_report_date IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Report date cannot be NULL';
    END IF;

    WITH repayment_analysis AS (
        SELECT
            loan_id,
            repayment_id,
            due_date,
            payment_date,
            scheduled_amount_php,
            paid_amount_php,

            CASE
                WHEN due_date IS NULL
                     OR scheduled_amount_php IS NULL
                THEN NULL

                -- Installment not yet due
                WHEN due_date >= p_report_date
                THEN 0

                -- Fully paid by reporting date
                WHEN payment_date <= p_report_date
                     AND COALESCE(paid_amount_php, 0)
                         >= scheduled_amount_php
                THEN 0

                -- Unpaid or partially paid installment
                ELSE DATEDIFF(p_report_date, due_date)

            END AS days_past_due

        FROM fact_repayments
    ),

    loan_analysis AS (
        SELECT
            loan_id,
            MAX(days_past_due) AS max_dpd
        FROM repayment_analysis
        GROUP BY loan_id
    )

    SELECT
        l.loan_id,
        l.customer_id,
        l.disbursement_date,
        l.principal_php,

        COALESCE(a.max_dpd, 0) AS days_past_due,

        fn_delinquency_bucket(
            COALESCE(a.max_dpd, 0)
        ) AS delinquency_bucket

    FROM fact_loans l

    LEFT JOIN loan_analysis a
        ON l.loan_id = a.loan_id

    WHERE l.disbursement_date <= p_report_date

    ORDER BY
        days_past_due DESC,
        l.principal_php DESC;

END$$

DELIMITER ;

-- ---------------------------------------
-- Procedure 4: Classify Portfolio at Risk
-- ---------------------------------------
DROP PROCEDURE IF EXISTS sp_portfolio_at_risk;
DELIMITER $$
CREATE PROCEDURE sp_portfolio_at_risk(
    IN p_report_date DATE
)
BEGIN

    IF p_report_date IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Report date cannot be NULL';
    END IF;

    WITH repayment_analysis AS (
        SELECT
            loan_id,

            CASE
                WHEN due_date IS NULL
                  OR scheduled_amount_php IS NULL
                  OR scheduled_amount_php <= 0
                THEN NULL

                WHEN due_date >= p_report_date
                THEN 0

                WHEN payment_date IS NOT NULL
                 AND payment_date <= p_report_date
                 AND COALESCE(paid_amount_php, 0)
                     >= scheduled_amount_php
                THEN 0

                ELSE DATEDIFF(p_report_date, due_date)
            END AS days_past_due

        FROM fact_repayments
    ),

    loan_analysis AS (
        SELECT
            loan_id,
            MAX(days_past_due) AS max_dpd
        FROM repayment_analysis
        GROUP BY loan_id
    ),

    portfolio AS (
        SELECT
            l.loan_id,
            l.principal_php,
            a.max_dpd

        FROM fact_loans l

        LEFT JOIN loan_analysis a
            ON l.loan_id = a.loan_id

        WHERE l.disbursement_date <= p_report_date
          AND l.principal_php > 0
    )

    SELECT
        p_report_date AS report_date,

        COUNT(*) AS total_loans,

        ROUND(
            SUM(principal_php), 2
        ) AS total_principal_php,

        SUM(
            CASE WHEN max_dpd >= 30
                 THEN 1 ELSE 0 END
        ) AS loans_30plus_dpd,

        SUM(
            CASE WHEN max_dpd >= 60
                 THEN 1 ELSE 0 END
        ) AS loans_60plus_dpd,

        SUM(
            CASE WHEN max_dpd >= 90
                 THEN 1 ELSE 0 END
        ) AS loans_90plus_dpd,

        ROUND(
            100.0 * SUM(
                CASE WHEN max_dpd >= 30
                     THEN principal_php ELSE 0 END
            ) / NULLIF(SUM(principal_php), 0),
            2
        ) AS par30_proxy_pct,

        ROUND(
            100.0 * SUM(
                CASE WHEN max_dpd >= 60
                     THEN principal_php ELSE 0 END
            ) / NULLIF(SUM(principal_php), 0),
            2
        ) AS par60_proxy_pct,

        ROUND(
            100.0 * SUM(
                CASE WHEN max_dpd >= 90
                     THEN principal_php ELSE 0 END
            ) / NULLIF(SUM(principal_php), 0),
            2
        ) AS par90_proxy_pct

    FROM portfolio;

END$$

DELIMITER ;


-- -------------------------
-- Power BI Data Preparation
-- -------------------------
CREATE OR REPLACE VIEW vw_customer_profile AS
WITH latest_credit AS (
    SELECT
        ch.*,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY snapshot_date DESC, credit_history_id DESC
        ) AS rn
    FROM dim_credit_history ch
)

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.date_of_birth,
    c.gender,
    c.civil_status,
    c.province,
    c.employment_status,
    c.monthly_income_php,
    c.registration_date,

    ch.credit_score,
    ch.prior_loan_count,
    ch.previous_missed_payments,
    ch.credit_utilization,
    ch.prior_default_flag,

    CASE
        WHEN ch.credit_score IS NULL THEN 'Unknown'
        WHEN ch.credit_score < 580 THEN 'Poor'
        WHEN ch.credit_score < 670 THEN 'Fair'
        WHEN ch.credit_score < 740 THEN 'Good'
        WHEN ch.credit_score < 800 THEN 'Very Good'
        ELSE 'Excellent'
    END AS credit_risk_category

FROM dim_customers c

LEFT JOIN latest_credit ch
    ON c.customer_id = ch.customer_id
   AND ch.rn = 1;

CREATE OR REPLACE VIEW vw_loan_portfolio AS

SELECT
    l.loan_id,
    l.application_id,
    l.customer_id,

    l.disbursement_date,
    l.principal_php,
    l.annual_interest_rate,
    l.term_months,
    l.scheduled_monthly_payment_php,
    l.currency,

    a.application_date,
    a.application_channel,
    a.application_status,
    a.loan_purpose,
    a.internal_risk_score,

    c.gender,
    c.province,
    c.employment_status,
    c.monthly_income_php,
    c.credit_score,
    c.credit_risk_category,

    DATE_FORMAT(
        l.disbursement_date, '%Y-%m'
    ) AS disbursement_month

FROM fact_loans l

LEFT JOIN fact_loan_applications a
    ON l.application_id = a.application_id

LEFT JOIN vw_customer_profile c
    ON l.customer_id = c.customer_id;

CREATE OR REPLACE VIEW vw_repayment_performance AS

SELECT
    r.repayment_id,
    r.loan_id,
    r.installment_number,
    r.due_date,
    r.payment_date,
    r.scheduled_amount_php,
    r.paid_amount_php,
    r.payment_status,

    l.customer_id,
    l.principal_php,
    l.disbursement_date,

    CASE
        WHEN r.scheduled_amount_php IS NULL THEN NULL
        ELSE GREATEST(
            r.scheduled_amount_php
            - COALESCE(r.paid_amount_php, 0),
            0
        )
    END AS unpaid_installment_php,

    CASE
        WHEN r.due_date IS NULL
          OR r.scheduled_amount_php IS NULL
        THEN NULL

        WHEN COALESCE(r.paid_amount_php, 0)
             >= r.scheduled_amount_php
        THEN 0

        WHEN r.due_date >= CURRENT_DATE()
        THEN 0

        ELSE DATEDIFF(CURRENT_DATE(), r.due_date)
    END AS current_dpd

FROM fact_repayments r

LEFT JOIN fact_loans l
    ON r.loan_id = l.loan_id;

CREATE OR REPLACE VIEW vw_monthly_loan_performance AS

SELECT
    DATE_FORMAT(
        disbursement_date, '%Y-%m'
    ) AS reporting_month,

    COUNT(*) AS total_loans,

    COUNT(DISTINCT customer_id)
        AS unique_borrowers,

    ROUND(
        SUM(principal_php), 2
    ) AS total_disbursed_php,

    ROUND(
        AVG(principal_php), 2
    ) AS avg_loan_amount_php,

    ROUND(
        AVG(annual_interest_rate) * 100, 2
    ) AS avg_interest_rate_pct,

    ROUND(
        AVG(term_months), 2
    ) AS avg_loan_term_months

FROM fact_loans

WHERE disbursement_date IS NOT NULL

GROUP BY
    DATE_FORMAT(disbursement_date, '%Y-%m');


-- ------------
-- Check Tables
-- ------------
SELECT * FROM vw_customer_profile LIMIT 10;
SELECT * FROM vw_loan_portfolio LIMIT 10;
SELECT * FROM vw_repayment_performance LIMIT 10;
SELECT * FROM vw_monthly_loan_performance LIMIT 10;