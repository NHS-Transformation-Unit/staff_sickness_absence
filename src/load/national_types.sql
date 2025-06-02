SELECT [Organisation_Type]
      ,[Effective_Snapshot_Date]
      ,SUM([FTE_Days_Sick]) AS [FTE_Days_Sick]
      ,SUM([FTE_Days_Available]) AS [FTE_Days_Available]
FROM [UKHF_NHS_Workforce].[Sickness_Absence1]

GROUP BY [Organisation_Type]
        ,[Effective_Snapshot_Date]

ORDER BY [Organisation_Type]
        ,[Effective_Snapshot_Date] DESC