# This script grabs the Lego data from the "Rebrickable" website and writes it
# out to .parquet files stored in a public AWS s3 bucket ("posit-conf-2023-legos")

library(arrow)
library(readr)
library(fs)

# Establish connection to the public AWS s3 bucket
bucket <- arrow::s3_bucket("posit-conf-2023-legos")

# Read in 'inventories' data from the "Rebrickable" website
readr::read_csv(
  "https://cdn.rebrickable.com/media/downloads/inventories.csv.gz",
  col_types = readr::cols(
    .default = readr::col_character()
  )
) |>
  # write out to parquet in s3
  arrow::write_parquet(
    sink = bucket$path("inventories.parquet")   # TODO // This isn't working
  )

# Read in 'inventory_sets' data from the "Rebrickable" website
readr::read_csv(
  "https://cdn.rebrickable.com/media/downloads/inventory_parts.csv.gz",
  col_types = readr::cols(
    .default = readr::col_character(),
    quantity = readr::col_integer(),
    is_spare = readr::col_logical()
  )
) |>
  # write out to parquet in s3
  arrow::write_parquet(
    sink = bucket$path("inventory_sets.parquet")   # TODO // This isn't working
  )

# Read in 'sets' data from the "Rebrickable" website
readr::read_csv(
  "https://cdn.rebrickable.com/media/downloads/sets.csv.gz",
  col_types = readr::cols(
    .default = readr::col_character(),
    year = readr::col_integer(),
    num_parts = readr::col_integer()
  )
) |>
  # write out to parquet in s3
  arrow::write_parquet(
    sink = bucket$path("sets.parquet")   # TODO // This isn't working
  )

# Test reading in the parquet data from s3 by counting the
# number of observations by distinct quantity (i.e., # of pieces),
# filtering on only lego parts that are not "spares"
arrow::read_parquet(
  file = bucket$path("inventory_sets.parquet"),
  as_data_frame = FALSE   # create connection (arrow table), instead
                          # of reading entire file into R data frame
) |>
  dplyr::filter(is_spare == FALSE) |>
  dplyr::count(quantity) |>
  dplyr::collect()   # fetch query & pull data into memory
