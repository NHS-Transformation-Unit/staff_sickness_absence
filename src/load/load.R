
# Load combined dataset ---------------------------------------------------

sickness <- dbGetQuery(conn = con,
                       statement = read_file(here("src",
                                                  "load",
                                                  "combined_sickness.sql")
                       )
)
