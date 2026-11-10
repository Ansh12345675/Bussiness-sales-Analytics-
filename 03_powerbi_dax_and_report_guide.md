# Power BI DAX measures and report guide

This guide is for a Power BI model created from the `dbo.Sales` table or the matching CSV. It does not indicate that a Power BI report has already been created.

## Prepare the model

1. Load `dbo.Sales` from the demo SQL Server database (or load the CSV directly).
2. Set `OrderDate` to the **Date** data type. Set `Revenue`, `Cost`, `Profit`, and `UnitPrice` to fixed decimal/currency as appropriate; set `DiscountPct` to decimal/percentage.
3. Create a date table in Power BI with **Modeling > New table**:

   ```DAX
   'Date' =
   CALENDAR (
       MIN ( Sales[OrderDate] ),
       MAX ( Sales[OrderDate] )
   )
   ```

4. Add useful date columns:

   ```DAX
   Year = YEAR ( 'Date'[Date] )
   Month Number = MONTH ( 'Date'[Date] )
   Month = FORMAT ( 'Date'[Date], "MMMM" )
   Year Month = FORMAT ( 'Date'[Date], "YYYY-MM" )
   Year Month Sort = YEAR ( 'Date'[Date] ) * 100 + MONTH ( 'Date'[Date] )
   ```

5. Sort `Date[Month]` by `Date[Month Number]` and `Date[Year Month]` by `Date[Year Month Sort]`. Mark `Date` as the date table.
6. Create a one-to-many relationship from `Date[Date]` to `Sales[OrderDate]`, with single-direction filtering from Date to Sales.

## Core measures

Create these measures from **Modeling > New measure**. The DAX below assumes the fact table is named `Sales`.

```DAX
Revenue =
SUM ( Sales[Revenue] )

Profit =
SUM ( Sales[Profit] )

Orders =
DISTINCTCOUNT ( Sales[OrderID] )

Profit Margin =
DIVIDE ( [Profit], [Revenue], 0 )

Customers =
DISTINCTCOUNT ( Sales[CustomerID] )

Units Sold =
SUM ( Sales[Quantity] )

Average Order Value =
DIVIDE ( [Revenue], [Orders], 0 )

Revenue per Customer =
DIVIDE ( [Revenue], [Customers], 0 )
```

Format Revenue, Profit, Average Order Value, and Revenue per Customer as currency; format Profit Margin as a percentage.

## Customer analysis measures

These measures count customers and repeat customers within the current filter context (for example, the selected date period):

```DAX
Repeat Customers =
COUNTROWS (
    FILTER (
        VALUES ( Sales[CustomerID] ),
        CALCULATE ( DISTINCTCOUNT ( Sales[OrderID] ) ) > 1
    )
)

Repeat Customer Rate =
DIVIDE ( [Repeat Customers], [Customers], 0 )
```

The following measure counts customers whose first recorded order date is within the selected Date range. It removes Date filters while finding each customer's first-ever date in this model:

```DAX
New Customers =
VAR SelectedStart = MIN ( 'Date'[Date] )
VAR SelectedEnd = MAX ( 'Date'[Date] )
RETURN
    COUNTROWS (
        FILTER (
            VALUES ( Sales[CustomerID] ),
            VAR FirstOrderDate =
                CALCULATE (
                    MIN ( Sales[OrderDate] ),
                    REMOVEFILTERS ( 'Date' ),
                    ALLEXCEPT ( Sales, Sales[CustomerID] )
                )
            RETURN
                NOT ISBLANK ( FirstOrderDate )
                    && FirstOrderDate >= SelectedStart
                    && FirstOrderDate <= SelectedEnd
        )
    )
```

The sample is small and spans a limited time window, so treat customer lifecycle results as practice metrics rather than business forecasts.

## Suggested report pages

- **Overview:** Revenue, Profit, Profit Margin, Orders, and Customers cards; monthly revenue/profit line chart.
- **Sales breakdown:** Revenue and profit by Category, Region, State, and SalesChannel.
- **Products:** Top products by revenue/profit and units sold.
- **Customer analysis:** Customers, Repeat Customers, Repeat Customer Rate, New Customers, and revenue by Segment.
- Add slicers for Date, Region, Category, Segment, and SalesChannel. Check that selecting a value filters the visuals as intended.

## Validate before sharing

- Compare Power BI revenue, profit, order count, and customer count with query 1 in `02_analysis_queries.sql` for the same loaded rows.
- Validate a category and month against the matching SQL query.
- Check date sorting, blank values, currency/percentage formatting, and slicer behavior.
- Save the finished report as a `.pbix` and reopen it to confirm it works. The `.pbix` file is not included in this project; Power BI work remains incomplete until you create and test it.
