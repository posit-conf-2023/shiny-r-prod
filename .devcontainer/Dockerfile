FROM ghcr.io/rocker-org/devcontainer/tidyverse:4.3

# key dependencies for utilities
RUN apt-get update -qq \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get -y install --no-install-recommends libxt6 curl libglpk-dev libcurl4-openssl-dev libssl-dev libxml2-dev

# install rpython and pip3 just in case
RUN apt-get update \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get -y install --no-install-recommends python3-setuptools python3-pip

# install R package dependencies
RUN install2.r renv httpgd languageserver shiny rmarkdown markdown rhino 

