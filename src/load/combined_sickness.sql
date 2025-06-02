SELECT [Effective_Snapshot_Date] 
	  ,[NHSE_Region_Code]
      ,[Staff_Group]
      ,SUM([FTE_Days_Lost]) AS [FTE_Days_Lost]
      ,SUM([FTE_Days_Available]) AS [FTE_Days_Available]
     
  FROM [UKHF_NHS_Workforce].[Sickness_Absence_Benchmarking_Tool1]

  GROUP BY [Effective_Snapshot_Date] 
	  ,[NHSE_Region_Code]
      ,[Staff_Group]

 ORDER BY [Effective_Snapshot_Date] DESC
	  ,[NHSE_Region_Code]
      ,[Staff_Group]
