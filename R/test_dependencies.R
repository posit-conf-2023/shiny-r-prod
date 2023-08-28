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
