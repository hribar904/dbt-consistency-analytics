import streamlit as st
import duckdb
import pandas as pd

st.set_page_config(page_title="Metric Consistency Dashboard", layout="wide")

st.title("🏆 Analytics: Metric Consistency Dashboard")
st.markdown("---")

# Connect to our dbt-generated DuckDB file
con = duckdb.connect(database='dev_consistency.duckdb', read_only=True)

# 1. Metric: Overall Win Rate
win_rate_df = con.execute("""
    SELECT 
        sport, 
        ROUND(AVG(CASE WHEN home_won THEN 1.0 ELSE 0.0 END) * 100, 2) as win_rate_pct
    FROM main.fct_bets
    GROUP BY 1
""").df()

# 2. Metric: ROI by User (Top 5 Sharps)
roi_df = con.execute("""
    SELECT user_id, total_bets, avg_roi_per_bet
    FROM main.fct_user_performance
    ORDER BY avg_roi_per_bet DESC
    LIMIT 5
""").df()

# --- Dashboard Layout ---
col1, col2 = st.columns(2)

with col1:
    st.subheader("Win Rate by Sport")
    st.bar_chart(data=win_rate_df, x="sport", y="win_rate_pct")

with col2:
    st.subheader("Top 5 'Sharp' Users (Highest ROI)")
    st.table(roi_df)

st.write("Metric definitions are standardized via dbt Semantic Layer.")