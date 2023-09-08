#' Run the shinycannon utility
#'
#' @param shinycannon_path Path to the Shinycannon JAR file.
#' @param recording_file Path to recording file
#' @param app_url URL of the Shiny application to interact with
#' @param output_dir Path to directory to store session logs in for this
#'   test run
#' @param workers Number of workers to simulate. Default is 1. 
#' @param loaded_duration_minutes Number of minutes to continue simulating 
#'   sessions in each worker after all workers have completed one session. 
#'   Can be fractional. Default is 5.
#' @param overwrite_output Delete the output directory before starting, 
#'   if it exists already. Default is TRUE.
#' @param debug_log Produce a debug.log in the output directory. File can get
#'   very large. Default is FALSE.
#' @param log_level Log level. Possible values include warn, info, error,
#'   debug. Default is warn.
#'
#' @return exit code from `sys::exec_wait()`
shinycannon <- function(
    shinycannon_path,
    recording_file,
    app_url,
    output_dir,
    workers = 1,
    loaded_duration_minutes = 5,
    overwrite_output = TRUE,
    debug_log = FALSE,
    log_level = "warn") {
  
  # assemble command-line arguments
  cli_args <- c(
    "-jar",
    shinycannon_path,
    recording_file,
    app_url,
    "--workers",
    workers,
    "--loaded-duration-minutes",
    loaded_duration_minutes,
    "--output-dir",
    output_dir,
    "--log-level",
    log_level
  )
  
  if (debug_log) cli_args <- c(cli_args, "--debug-log")
  if (overwrite_output) cli_args <- c(cli_args, "--overwrite-output")
  
  sys::exec_wait(
    cmd = "java",
    args = cli_args
  )
}