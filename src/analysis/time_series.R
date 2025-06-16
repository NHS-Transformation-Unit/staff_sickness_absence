
# National Time Series ----------------------------------------------------

sickness_eng_ts <- sickness |>
  filter(Staff_Group == "All staff groups",
         Effective_Snapshot_Date > as.Date(c("2018-03-31"))) |>
  group_by(Effective_Snapshot_Date) |>
  summarise(FTE_Days_Lost = sum(FTE_Days_Lost, na.rm = TRUE),
            FTE_Days_Available = sum(FTE_Days_Available, na.rm = TRUE)) |>
  mutate(Sickness_Rate = FTE_Days_Lost / FTE_Days_Available)

chart_eng_ts <- ggplot(sickness_eng_ts, aes(x = Effective_Snapshot_Date, y = Sickness_Rate)) +
  geom_line(col = "#407EC9", linewidth = 0.8) +
  scale_x_date(date_breaks = "4 months", date_labels = "%b-%y") +
  scale_y_continuous(labels = scales::percent) +
  annotate("text", x = as.Date(c("2020-04-30")), y = 0.068, label = "Start of pandemic", hjust = 0, color = "#912714") +
  geom_vline(xintercept = as.Date(c("2020-03-20")), linetype = "dashed", col = "#912714") +
  annotate("text", x = as.Date(c("2021-12-31")), y = 0.068, label = "Omicron variant", hjust = 0, color = "#990c7d") +
  geom_vline(xintercept = as.Date(c("2021-12-01")), linetype = "dashed", col = "#990c7d") + 
  labs(x = "Month",
       y = "Sickness Rate (% of FTE Days Available)",
       caption = "Source: NHS England Workforce Statistics",
       title = str_wrap("Sickness absence rates remain significantly higher after the pandemic", width = 50),
       subtitle = "NHS England - All organisations and staff groups") +
  theme(text = element_text(family = "Franklin Gothic Book"),
        strip.background = element_rect(fill = "#407EC9"),
        strip.text = element_text(colour = "#ffffff", size = 10),
        axis.text = element_text(size = 10),
        axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title = element_text(size = 11),
        plot.title = element_text(size = 16, color = "#407EC9"),
        plot.subtitle = element_text(size = 12),
        panel.background = element_rect(fill = "#ffffff"),
        panel.grid.major.y = element_line(color = "#cecece", linewidth = 0.1),
        panel.grid.minor.y = element_blank(),
        axis.line = element_line(color = "#000000"),
        legend.position = "bottom",
        legend.text = element_text(size = 7.5)
  )


# Regional Time Series ----------------------------------------------------

sickness_reg_ts <- sickness |>
  filter(Staff_Group == "All staff groups",
         Effective_Snapshot_Date > as.Date(c("2018-03-31"))) |>
  group_by(Effective_Snapshot_Date, NHSE_Region_Code) |>
  summarise(FTE_Days_Lost = sum(FTE_Days_Lost, na.rm = TRUE),
            FTE_Days_Available = sum(FTE_Days_Available, na.rm = TRUE)) |>
  mutate(Sickness_Rate = FTE_Days_Lost / FTE_Days_Available,
         Region = case_when(NHSE_Region_Code == "Y56" ~ "London",
                            NHSE_Region_Code == "Y59" ~ "South East",
                            NHSE_Region_Code == "Y58" ~ "South West",
                            NHSE_Region_Code == "Y60" ~ "Midlands",
                            NHSE_Region_Code == "Y63" ~ "North East and Yorkshire",
                            NHSE_Region_Code == "Y61" ~ "East of England",
                            NHSE_Region_Code == "Y62" ~ "North West",
                            TRUE ~ "Other non-regional")) |>
  mutate(Region = factor(Region, levels = c("London",
                                            "South East",
                                            "South West",
                                            "Midlands",
                                            "East of England",
                                            "North West",
                                            "North East and Yorkshire",
                                            "Other non-regional")))

end_labels_reg <- sickness_reg_ts |>
  group_by(Region) |>
  filter(Effective_Snapshot_Date == max(Effective_Snapshot_Date))

chart_eng_reg_ts <- ggplot(sickness_reg_ts, aes(x = Effective_Snapshot_Date, y = Sickness_Rate, color = Region)) +
  geom_line() +
  scale_colour_manual(values = palette_region) +
  geom_text(data = end_labels_reg, aes(label = str_wrap(Region, width = 15)), hjust = -0.1, size = 2.5) +
  scale_x_date(date_breaks = "4 months", date_labels = "%b-%y", expand = expansion(mult = c(0, 0.1))) +
  scale_y_continuous(labels = scales::percent) +
  annotate("text", x = as.Date(c("2020-04-30")), y = 0.085, label = "Start of pandemic", hjust = 0, color = "#912714") +
  geom_vline(xintercept = as.Date(c("2020-03-20")), linetype = "dashed", col = "#912714") +
  annotate("text", x = as.Date(c("2021-12-31")), y = 0.085, label = "Omicron variant", hjust = 0, color = "#990c7d") +
  geom_vline(xintercept = as.Date(c("2021-12-01")), linetype = "dashed", col = "#990c7d") + 
  labs(x = "Month",
       y = "Sickness Rate (% of FTE Days Available)",
       caption = "Source: NHS England Workforce Statistics",
       title = str_wrap("Sickness absence rates remain significantly higher after the pandemic across all regions", width = 50),
       subtitle = "NHS England Regions - All organisations and staff groups") +
  guides(color = "none") +
  theme(text = element_text(family = "Franklin Gothic Book"),
        strip.background = element_rect(fill = "#407EC9"),
        strip.text = element_text(colour = "#ffffff", size = 10),
        axis.text = element_text(size = 10),
        axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title = element_text(size = 11),
        plot.title = element_text(size = 16, color = "#407EC9"),
        plot.subtitle = element_text(size = 12),
        panel.background = element_rect(fill = "#ffffff"),
        panel.grid.major.y = element_line(color = "#cecece", linewidth = 0.1),
        panel.grid.minor.y = element_blank(),
        axis.line = element_line(color = "#000000"),
        legend.position = "bottom",
        legend.text = element_text(size = 7.5)
  )


# Job Role Time Series ----------------------------------------------------

sickness_role_ts <- sickness |>
  filter(Staff_Group != "All staff groups",
         Effective_Snapshot_Date > as.Date(c("2018-03-31")),
         !Staff_Group %in% c("Unknown classification", "Other staff or those with unknown classification")) |>
  mutate(Staff_Group = case_when(Staff_Group == "HCHS Doctors" ~ "HCHS doctors",
                                 TRUE ~ Staff_Group)) |>
  group_by(Effective_Snapshot_Date, Staff_Group) |>
  summarise(FTE_Days_Lost = sum(FTE_Days_Lost, na.rm = TRUE),
            FTE_Days_Available = sum(FTE_Days_Available, na.rm = TRUE)) |>
  mutate(Sickness_Rate = FTE_Days_Lost / FTE_Days_Available) |>
  mutate(Staff_Group = factor(Staff_Group, levels = c("Support to ambulance staff",
                                                      "Hotel, property & estates",
                                                      "Support to doctors, nurses & midwives",
                                                      "Ambulance staff",
                                                      "Support to ST&T staff",
                                                      "Nurses & health visitors",
                                                      "Midwives",
                                                      "Scientific, therapeutic & technical staff",
                                                      "Central functions",
                                                      "Managers",
                                                      "HCHS doctors",
                                                      "Senior managers"))) |>
  mutate(Staff_Group_wrap = str_wrap(Staff_Group, width = 15),
         Staff_Group_wrap = factor(Staff_Group_wrap,
                                   levels = str_wrap(levels(Staff_Group), width = 15)))

sickness_role_latest <- sickness |>
  mutate(Staff_Group = case_when(Staff_Group == "HCHS Doctors" ~ "HCHS doctors",
                                 TRUE ~ Staff_Group)) |>
  group_by(Staff_Group) |>
  filter(Staff_Group != "All staff groups",
         Effective_Snapshot_Date == max(Effective_Snapshot_Date)) |>
  
  summarise(FTE_Days_Lost = sum(FTE_Days_Lost, na.rm = TRUE),
            FTE_Days_Available = sum(FTE_Days_Available, na.rm = TRUE)) |>
  mutate(Sickness_Rate = FTE_Days_Lost / FTE_Days_Available)


ggplot(sickness_role_ts, aes(x = Effective_Snapshot_Date, y = Sickness_Rate)) +
  geom_line(color = "#407EC9") +
  facet_wrap(~Staff_Group_wrap) +
  scale_x_date(date_breaks = "12 months", date_labels = "%b-%y", expand = expansion(mult = c(0, 0.1))) +
  scale_y_continuous(labels = scales::percent) +
  geom_vline(xintercept = as.Date(c("2020-03-20")), linetype = "dashed", col = "#912714") +
  geom_vline(xintercept = as.Date(c("2021-12-01")), linetype = "dashed", col = "#990c7d") + 
  labs(x = "Month",
       y = "Sickness Rate (% of FTE Days Available)",
       caption = "Source: NHS England Workforce Statistics",
       title = "These higher rates are reflected across all staffing groups",
       subtitle = "NHS England by staffing group") +
  theme(text = element_text(family = "Franklin Gothic Book"),
        strip.background = element_rect(fill = "#407EC9"),
        strip.text = element_text(colour = "#ffffff", size = 10),
        axis.text = element_text(size = 10),
        axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title = element_text(size = 11),
        plot.title = element_text(size = 16, color = "#407EC9"),
        plot.subtitle = element_text(size = 12),
        panel.background = element_rect(fill = "#ffffff"),
        panel.grid.major.y = element_line(color = "#cecece", linewidth = 0.1),
        panel.grid.minor.y = element_blank(),
        axis.line = element_line(color = "#000000"),
        legend.position = "bottom",
        legend.text = element_text(size = 7.5)
  )

sickness_roles_comp <- sickness |>
  filter(Staff_Group != "All staff groups",
         Effective_Snapshot_Date > as.Date(c("2018-03-31")),
         !Staff_Group %in% c("Unknown classification", "Other staff or those with unknown classification")) |>
  mutate(Staff_Group = case_when(Staff_Group == "HCHS Doctors" ~ "HCHS doctors",
                                 TRUE ~ Staff_Group)) |>
  mutate(Year = year(Effective_Snapshot_Date)) |>
  filter(Year %in% c(2019, 2024)) |>
  group_by(Staff_Group, Year) |>
  summarise(FTE_Days_Lost = sum(FTE_Days_Lost, na.rm = TRUE),
            FTE_Days_Available = sum(FTE_Days_Available, na.rm = TRUE)) |>
  mutate(Sickness_Rate = FTE_Days_Lost / FTE_Days_Available,
         Year = factor(Year, levels = c(2019, 2024))) |>
  mutate(Staff_Group = factor(Staff_Group, levels = c("Support to ambulance staff",
                                                      "Hotel, property & estates",
                                                      "Support to doctors, nurses & midwives",
                                                      "Ambulance staff",
                                                      "Support to ST&T staff",
                                                      "Midwives",
                                                      "Nurses & health visitors",
                                                      "Central functions",
                                                      "Scientific, therapeutic & technical staff",
                                                      "Managers",
                                                      "Senior managers",
                                                      "HCHS doctors"))) |>
  mutate(Staff_Group_wrap = str_wrap(Staff_Group, width = 25),
         Staff_Group_wrap = factor(Staff_Group_wrap,
                                   levels = str_wrap(levels(Staff_Group), width = 25)))

chart_eng_roles_comp <- ggplot(sickness_roles_comp, aes(y = Staff_Group_wrap, x = Sickness_Rate, group = Staff_Group)) +
  geom_line(arrow = arrow(type = "closed", length = unit(0.2, "cm")), linewidth = 0.3) +
  geom_point(aes(colour = Year), size = 2.2) +
  scale_colour_manual(values = c(palette_tu[1], palette_tu[7])) +
  scale_x_continuous(labels = scales::percent, breaks = seq(0, 0.8, by = 0.01)) +
  labs(y = "Staffing Group",
       x = "Sickness Rate (% of FTE Days Available)",
       caption = "Source: NHS England Workforce Statistics",
       title = str_wrap("All Staffing Groups have seen an increase from 2019 to 2024", width = 50),
       subtitle = "NHS England by staffing group - 2019 and 2024 aggregated") +
  theme(text = element_text(family = "Franklin Gothic Book"),
        strip.background = element_rect(fill = "#407EC9"),
        strip.text = element_text(colour = "#ffffff", size = 10),
        axis.text = element_text(size = 10),
        axis.title = element_text(size = 11),
        plot.title = element_text(size = 16, color = "#407EC9"),
        plot.subtitle = element_text(size = 12),
        panel.background = element_rect(fill = "#ffffff"),
        panel.grid.major.x = element_line(color = "#cecece", linewidth = 0.1),
        panel.grid.minor.x = element_blank(),
        axis.line = element_line(color = "#000000"),
        legend.position = "bottom",
        legend.text = element_text(size = 10)
  )

hscs_2024 <- sickness_roles_comp |>
  filter(Staff_Group == "HCHS doctors",
         Year == 2024)

sas_2024 <- sickness_roles_comp |>
  filter(Staff_Group == "Support to ambulance staff",
         Year == 2024)

top_bottom_comp <- round(sas_2024[[1, 5]] / hscs_2024[[1, 5]], 1)
