# Project completion checklist

Use this as a practical, beginner-friendly work plan. The checked items are the files already prepared in this workspace; Power BI itself still needs to be set up and tested.

## Prepared in this workspace

- [x] Add an independent `powerbi-sql/` folder without changing the existing web application.
- [x] Create a synthetic CSV with 500 sales records.
- [x] Write the SQL Server schema and small repeatable seed.
- [x] Add more than 10 useful, read-only SQL analysis queries.
- [x] Document DAX measures for revenue, profit, orders, margin, and customers.
- [x] Document SQL Server, CSV, and Power BI Desktop setup steps.
- [x] Update the root project README and add upstream/local-change attribution.

## To finish on your computer

- [ ] Install or confirm access to SQL Server and SSMS.
- [ ] Run `01_schema_and_seed.sql` and confirm `SalesAnalyticsDemo.dbo.Sales` exists.
- [ ] Run selected queries from `02_analysis_queries.sql` and inspect their results.
- [ ] Import the 500-row CSV (or load it directly in Power BI); verify row counts and data types.
- [ ] Connect Power BI Desktop to the selected source.
- [ ] Create and relate the Date table; add and format the measures in `03_powerbi_dax_and_report_guide.md`.
- [ ] Build at least one report page with KPI cards, a monthly chart, and useful slicers.
- [ ] Reconcile Power BI totals against SQL for the same records and filters.
- [ ] Save the `.pbix`, close it, reopen it, and confirm the visuals and refresh work.
- [ ] Only then describe the Power BI report as created and tested. Do not claim completion before this check.
- [ ] Keep credentials and business data private; publish only to an authorized workspace.
