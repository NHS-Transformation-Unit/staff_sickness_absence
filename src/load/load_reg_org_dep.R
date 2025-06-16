
# Load combined dataset ---------------------------------------------------

sickness_reg_org_dep <- dbGetQuery(conn = con,
                       statement = read_file(here("src",
                                                  "load",
                                                  "reg_org_dep.sql")
                       )
)
