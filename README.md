# Credit Risk Analytics | MySQL & Power BI

**An end-to-end SQL analytics project exploring loan portfolio performance, customer credit profiles, repayment behavior, and delinquency risk.**

**Tools:** MySQL 8.0+ · SQL · Power BI · DAX

## Project Overview

This project develops a structured analytics workflow for lending data, from staging and data-quality checks through SQL transformations, credit-risk metrics, and Power BI reporting. The analysis brings together customer profiles, credit histories, loan applications, disbursed loans, and installment repayments to support portfolio monitoring and credit-risk exploration.

The SQL implementation includes data-cleaning logic, exploratory queries, delinquency calculations, reusable functions and stored procedures, and reporting-ready views.

## Objectives

- Assess loan volume, disbursement trends, and application approval rates.
- Examine customer demographics, income, and credit-score distributions.
- Evaluate repayment collection and installment delinquency.
- Analyze days past due (DPD) at installment and loan level.
- Compare delinquency by loan purpose and origination cohort.
- Prepare relational reporting views for Power BI dashboards.

## Data Model

The SQL workflow uses five staging tables and five cleaned analytical tables:

| Staging table | Analytical table | Contents |
| --- | --- | --- |
| `stg_customers` | `dim_customers` | Customer demographics, employment, and income |
| `stg_credit_history` | `dim_credit_history` | Credit scores, utilization, and prior repayment history |
| `stg_loan_applications` | `fact_loan_applications` | Applications, requested amounts, and decisions |
| `stg_loans` | `fact_loans` | Disbursements, principal, interest rates, and terms |
| `stg_repayments` | `fact_repayments` | Installment schedules, payments, and statuses |

The script defines these tables but **does not include data-import statements or a dataset download**. Source data must be loaded into the staging tables before the transformation and analysis queries are run.

## Workflow

### 1. Data quality and cleaning

- Inspect table schemas and identify duplicate business identifiers.
- Check missing and blank values across all five source tables.
- Standardize categorical fields and normalize whitespace.
- Parse date and currency-related text into appropriate SQL types.
- Validate credit-score ranges, credit utilization, loan terms, and financial amounts.
- Build cleaned dimension and fact tables for analysis.

### 2. Exploratory data analysis

SQL queries examine:

- Customer counts, gender and employment distributions, and income by employment status.
- Application outcomes and approval rates, including by channel.
- Loan counts, borrowers, principal disbursed, average loan size, and monthly disbursement trends.
- Credit-score categories and repayment-status distributions.
- Scheduled versus paid installments and the collection ratio.

### 3. Credit risk and delinquency analysis

The project calculates **days past due (DPD)** and classifies installments or loans into these categories:

| DPD | Delinquency bucket |
| --- | --- |
| 0 | Current |
| 1–30 | 1–30 DPD |
| 31–60 | 31–60 DPD |
| 61–90 | 61–90 DPD |
| 91+ | 90+ DPD |
| Missing | Unknown |

Additional analysis includes:

- Loan-level maximum DPD and counts of loans at 1+, 30+, 60+, and 90+ DPD.
- Delinquency rates by loan purpose.
- Monthly loan origination cohorts and vintage 30+ DPD rates.
- Ranking loans by maximum DPD and summarizing customer-level delinquency.
- **Principal-weighted PAR30/PAR60/PAR90 proxies** using original loan principal.

> **Metric limitation:** The PAR-style measures in this project use **original principal**, not outstanding loan balances. They are illustrative principal-weighted delinquency proxies and should not be presented as standard portfolio-at-risk ratios.

> **Reporting-date note:** Some views use `CURRENT_DATE()` and will change as the query date changes. Separate stored procedures accept an explicit reporting date. DPD calculations are analytical approximations based on the available installment-level fields, not a complete contractual arrears ledger.

## SQL Functions and Stored Procedures

### Functions

| Function | Purpose |
| --- | --- |
| `fn_dpd` | Calculates days past due using due, payment, and report dates |
| `fn_delinquency_bucket` | Maps a DPD value to a delinquency category |
| `fn_risk_category` | Groups credit scores into Poor, Fair, Good, Very Good, Excellent, Unknown, or Invalid |

### Stored procedures

| Procedure | Purpose |
| --- | --- |
| `sp_loan_portfolio_summary` | Summarizes loan counts, disbursements, interest rates, and terms |
| `sp_customer_loan_history` | Returns loan and repayment summaries for a specified customer |
| `sp_delinquency_report` | Produces a date-specific loan delinquency report |
| `sp_portfolio_at_risk` | Calculates date-specific principal-weighted delinquency proxies |

Example calls (after tables have been populated and routines created):

```sql
CALL sp_loan_portfolio_summary();
CALL sp_delinquency_report('2026-01-31');
CALL sp_portfolio_at_risk('2026-01-31');
```

## Power BI Reporting

The project is organized around four Power BI report pages:

1. **Loan Portfolio Overview** — Portfolio size, disbursement trends, loan characteristics, and summary KPIs.
2. **Credit Risk Analysis** — Credit profiles, delinquency categories, and risk-related portfolio measures.
3. **Repayment Performance** — Scheduled versus collected amounts, payment behavior, and delinquency.
4. **Customer Demographics & Income Analysis** — Customer composition, employment, income, and geographic patterns.

The SQL script prepares four views for reporting:

- `vw_customer_profile`
- `vw_loan_portfolio`
- `vw_repayment_performance`
- `vw_monthly_loan_performance`


## Skills Demonstrated

`SQL` · `MySQL` · `Data Cleaning` · `Exploratory Data Analysis` · `Credit Risk Analytics` · `CTEs` · `Window Functions` · `SQL Views` · `Stored Procedures` · `Power BI` · `DAX` · `Dashboard Development`

---

**Author:** [Neil Christian Donato](https://github.com/neil-donato) · [LinkedIn](https://www.linkedin.com/in/neil-christian-donato/)
