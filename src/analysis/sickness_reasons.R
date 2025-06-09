
# Reasons chart -----------------------------------------------------------

sickness_reason_df <- sickness_reason |>
  group_by(REASON) |>
  summarise(FTE_DAYS_LOST = sum(FTE_DAYS_LOST, na.rm = TRUE)) |>
  mutate(perc = FTE_DAYS_LOST / sum(FTE_DAYS_LOST),
         reason_trimmed = substring(REASON, 5, nchar(REASON))) |>
  arrange(desc(perc)) |>
  slice(1:5)

chart_sickness_reason <- ggplot(sickness_reason_df, aes(y = reorder(reason_trimmed, perc), x = perc)) +
  geom_bar(stat = "identity", fill = "#407EC9", col = "black") +
  geom_text(aes(label = scales::percent(perc, accuracy = 0.1)), hjust = -0.2, size = 2.5) +
  scale_x_continuous(labels = scales::percent, limits = c(0, 0.3), breaks = seq(0, 0.3, by = 0.05)) +
  scale_y_discrete(labels = function(x) str_wrap(x, width = 20)) +
  labs(x = "Percentage of FTE days lost",
       y = "Sickness Absence Reason",
       title = str_wrap("Days lost due to mental health represent the largest reason for sickness absence", width = 40),
       subtitle = "Top 5 Reasons | NHS England 12 months ending January 2025",
       caption = "Source: Source: NHS England Workforce Statistics") +
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
