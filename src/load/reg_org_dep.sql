SELECT SAB.[NHSE_Region_Code]
      ,SAB.[Org_Code]
	  ,ORG.[Org_Code_For_Use]
	  ,ORG.[Org_Name_For_Use]
	  ,ORG.[Org_Region_Code]
      ,ORG.[Org_Region_Name]
	  ,ORG.[Org_Type]
	  ,ORG.[Org_Post_Code]
	  ,PCLSOA.[yr2011_LSOA]
      ,IMD.[IMD_Rank]
      ,IMD.[IMD_Decile]
      ,SUM(SAB.[FTE_Days_Lost]) AS [FTE_Days_Lost]
      ,SUM(SAB.[FTE_Days_Available]) AS [FTE_Days_Available]
     
  FROM [UKHF_NHS_Workforce].[Sickness_Absence_Benchmarking_Tool1] AS SAB

  LEFT JOIN [Internal_ESRReference].[REF_ORGANISATION] AS ORG
  ON SAB.[Org_Code] = ORG.[Org_Code_For_Join]

  LEFT JOIN [UKHD_ODS].[Postcode_Grid_Refs_Eng_Wal_Sco_And_NI_SCD] AS PCLSOA
  ON ORG.[Org_Post_Code] = PCLSOA.[Postcode_single_space_e_Gif]
  AND PCLSOA.[Is_Latest] = 1

  LEFT JOIN [UKHF_Demography].[Index_Of_Multiple_Deprivation_By_LSOA1] AS IMD
  ON PCLSOA.[yr2011_LSOA] = IMD.[LSOA_Code]
  AND IMD.[Effective_Snapshot_Date] = '2019-12-31'

  WHERE SAB.[Effective_Snapshot_Date] BETWEEN '2024-02-01' AND '2025-01-31'
  AND ORG.[Org_Region_Code] != 'NAT'

  GROUP BY SAB.[NHSE_Region_Code]
      ,SAB.[Org_Code]
	  ,ORG.[Org_Code_For_Use]
	  ,ORG.[Org_Name_For_Use]
	  ,ORG.[Org_Region_Code]
      ,ORG.[Org_Region_Name]
	  ,ORG.[Org_Type]
	  ,ORG.[Org_Post_Code]
	  ,PCLSOA.[yr2011_LSOA]
	  ,IMD.[IMD_Score]
      ,IMD.[IMD_Rank]
      ,IMD.[IMD_Decile]

 ORDER BY SAB.[NHSE_Region_Code]
      ,SAB.[Org_Code]
	  ,ORG.[Org_Code_For_Use]
	  ,ORG.[Org_Name_For_Use]
	  ,ORG.[Org_Region_Code]
      ,ORG.[Org_Region_Name]
	  ,ORG.[Org_Type]
	  ,ORG.[Org_Post_Code]
	  ,PCLSOA.[yr2011_LSOA]
      ,IMD.[IMD_Rank]
      ,IMD.[IMD_Decile]
