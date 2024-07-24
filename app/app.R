# app.r
#options(repos = c(CRAN = "https://cloud.r-project.org"))
# Run the application
shinyApp(ui = ui, server = server)

# To Update the app and redeploy: rsconnect::deployApp('~/VTDSPG24ProjectingFoodInsecurity/app', appName = 'VTDSPGPFI')