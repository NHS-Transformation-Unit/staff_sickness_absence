
# UDAL Data Lake ----------------------------------------------------------

con <- DBI::dbConnect(drv = odbc::odbc(),
                      driver = "ODBC Driver 17 for SQL Server",
                      server = "udalsyndataprod.sql.azuresynapse.net",
                      database = "UDAL_Warehouse",
                      authentication = "ActiveDirectoryInteractive")
