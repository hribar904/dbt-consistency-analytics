### **Quick Start**
1. **Install Dependencies:** `pip install dbt-duckdb`
2. **Initialize Database:** `dbt seed` (loads raw betting data from CSV to DuckDB)
3. **Execute Pipeline:** `dbt build` (runs all transformations and 14 combined model & data tests)

### **Data Lineage**
* **Bronze (Staging):** Raw data ingestion and initial casting.
* **Silver (Transformation):** Validated predictions and ground-truth actuals.
* **Gold (Analytics):** Business-ready fact tables (`fct_bets`, `fct_user_performance`) used for consistency auditing.
