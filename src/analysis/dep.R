sickness_reg_org_dep <- sickness_reg_org_dep |>
  mutate(Sickness_Rate = FTE_Days_Lost / FTE_Days_Available)

ggplot(sickness_reg_org_dep, aes(x = IMD_Rank, y = Sickness_Rate)) +
  geom_point(aes(col =Org_Region_Name)) +
  geom_smooth(method = "lm")
