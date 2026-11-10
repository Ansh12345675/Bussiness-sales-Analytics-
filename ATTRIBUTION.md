# Attribution

## Existing dashboard

The existing React/Express/MongoDB dashboard is attributed to the upstream project referenced by the repository URL in the original README:

- Repository: [RetajGenius/business-analytics-dashboard](https://github.com/RetajGenius/business-analytics-dashboard)
- The existing `LICENSE` file is retained as found in this workspace. Consult it and the upstream repository for applicable terms before redistributing.
- The client and server package manifests also retain their existing author metadata.

This attribution records the upstream URL referenced in the supplied project documentation; it does not assert that the current workspace has been verified against a particular upstream commit.

## Local modifications

This workspace adds the `powerbi-sql/` folder, containing a synthetic 500-row sales CSV, SQL Server schema/sample seed and analysis queries, DAX/report guidance, Power BI setup instructions, and a completion checklist. The root README was rewritten to describe the actual project and this optional analytics workflow.

These are local additions for learning and demonstration. They do not add a SQL Server connection to the existing app, change its React/Node.js/Express/MongoDB code, or include an actual Power BI report. The synthetic rows are generated and are not real customer data.
