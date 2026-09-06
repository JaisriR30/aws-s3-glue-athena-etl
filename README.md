# AWS Serverless Data Architecture — Retail Analytics

A fully serverless batch analytics pipeline built on AWS, using S3, Glue, and Athena to
transform raw retail sales data into a query-ready analytics layer — no servers or
clusters to manage.

Built as part of self-directed AWS Cloud Architect coursework, focused on serverless
design patterns, storage tiering, and schema-on-read architecture.

## Architecture

See `/docs` for the full architecture diagram and console screenshots of each stage.

## What it does

- Ingests a raw retail sales CSV (Kaggle "Superstore"-style dataset) into an S3 data lake
- Automatically discovers schema using **AWS Glue Crawlers** — no manual schema definition
- Cleans and transforms the data with a **no-code Glue Visual ETL job**:
  - Standardizes the schema (Change Schema transform)
  - Removes duplicate rows (Drop Duplicates transform)
- Writes the cleaned output as **Parquet** (Snappy-compressed) to a curated S3 zone
- Crawls the curated data so it's queryable via the **Glue Data Catalog**
- Runs ad-hoc business SQL queries directly against S3 using **Amazon Athena** —
  no database server involved

## Why this architecture

- **Zero infrastructure to manage** — every service used is fully managed/serverless
  (no EC2 instances, no Spark clusters to provision or patch)
- **Raw vs. curated separation** — the source data stays immutable; all transforms are
  reproducible from a clean starting point
- **Schema-on-read via the Glue Data Catalog** — decouples storage from compute, so
  multiple tools (Glue, Athena) can share a single source of truth
- **Columnar storage (Parquet)** — reduces the amount of data scanned per query, which
  lowers both cost and latency compared to querying raw CSV
- **Pay-per-use cost model** — Glue jobs are billed per run, Athena is billed per query,
  so there's no idle compute cost between runs

## Tools & services

| Service | Purpose |
|---|---|
| Amazon S3 | Data lake storage (raw + curated zones) |
| AWS Glue Crawlers | Automated schema discovery |
| AWS Glue Studio (Visual ETL) | No-code data transformation |
| AWS Glue Data Catalog | Central metadata/schema store |
| Amazon Athena | Serverless SQL querying |

## Repository structure

## Example business questions answered

- Which product category generates the most revenue?
- How does average order value differ by customer segment?
- Which shipping mode is used most, and how much revenue does it drive?
- Which states generate the most sales?

See `/queries/business_queries.sql` for the full SQL and `/docs` for screenshots of the
query results.

## Notes

- Dataset: retail "Superstore"-style sales data sourced from Kaggle
- Region: ap-south-1 (Mumbai)
- Job runtime: ~1m 19s per run (10 DPUs, G.1X workers, Glue 5.1)
