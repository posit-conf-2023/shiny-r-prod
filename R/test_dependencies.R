# test basic functionality of crew ----
library(crew)

# create controller object
controller <- crew_controller_local(
  name = "example",
  workers = 2,
  seconds_idle = 10
)

# start controller
controller$start()

# send task
controller$push(name = "get_pid", command = ps::ps_pid())

# obtain task result
controller$pop()
task <- controller$pop()
task$result[[1]]

# test basic shinyloadtest ----
library(shinyloadtest)
library(sys)


# define paths and constants
app_link <- "https://rsc.training.rstudio.com/bricktest/"
recording_file <- "R/recording.log"

shinyloadtest::record_session(
  app_link, 
  output_file = "R/recording.log",
  connect_api_key = Sys.getenv("RSCONNECT_KEY")
)

# use the exec_wait function from sys
shinycannon_path <- "utils/shinycannon-1.1.3-dd43f6b.jar"

# baseline run
exec_wait(
  cmd = "java",
  args = c(
    "-jar",
    shinycannon_path,
    recording_file,
    app_link,
    "--workers",
    1,
    "--loaded-duration-minutes",
    3,
    "--output-dir",
    "R/run1",
    "--overwrite-output"
  )
)

# comparison run (3 workers)
exec_wait(
  cmd = "java",
  args = c(
    "-jar",
    shinycannon_path,
    recording_file,
    app_link,
    "--workers",
    3,
    "--loaded-duration-minutes",
    3,
    "--output-dir",
    "R/run3",
    "--overwrite-output"
  )
)

# comparison run (5 workers)
exec_wait(
  cmd = "java",
  args = c(
    "-jar",
    shinycannon_path,
    recording_file,
    app_link,
    "--workers",
    5,
    "--loaded-duration-minutes",
    3,
    "--output-dir",
    "R/run5",
    "--overwrite-output"
  )
)

# analyze runs
df <- load_runs("Run 1" = "R/run1", "Run 3" = "R/run3", "Run 5" = "R/run5")

shinyloadtest_report(df, "R/report1.html")

# run following command in terminal 
# java -jar utils/shinycannon-1.1.3-dd43f6b.jar -h
# java -jar utils/shinycannon-1.1.3-dd43f6b.jar R/recording.log https://rsc.training.rstudio.com/bricktest/ --workers 1 --loaded-duration-minutes 5 --output-dir R/run1 --overwrite-output

# test connectapi with posit connect training server
library(connectapi)

client <- connect(
  server = paste0("https://", Sys.getenv("RSCONNECT_SERVER")),
  api_key = Sys.getenv("RSCONNECT_KEY")
)

content_df <- get_content(client)
usage_df <- get_usage_shiny(client, limit = 10)

# app guid
lego_guid <- Sys.getenv("LEGO_APP_GUID")

get_usage_shiny(client, content_guid = lego_guid)