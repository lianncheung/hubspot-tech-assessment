# hubspot_tech_assessment
- dbt project for the Hubspot tech assessment to transform analytics event data for reporting use
- dbt resources created by this project will live in Snowflake under the `HUBSPOT_TECH_ASSESSMENT` database


---
:memo: For development, all Snowflake resources created by dbt will live under the database, `HUBSPOT_TECH_ASSESSMENT`.
Each developer will have personal schemas created under `<your dev credentials schema>_SCHEMA_NAME`.
---


## **How to Develop**
1. Check out dev branch from `main`:
- dbt Cloud: in the Develop tab, check out the `main` branch; from there, create your dev branch
- dbt local: using Github Desktop or the command line, check out your branch from main

2. Make changes (and add tests, if applicable) in your dev branch, testing with dbt build commands

3. Commit + push, opening up a PR to merge your dev branch -> main

4. Ensure Github CICD checks pass and validate data as needed

5. After receiving approvals, merge PR and either run a one-off dbt job or wait for the next scheduled dbt job run
