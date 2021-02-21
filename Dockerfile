#build an image on top of the base image for r version 3.5.1 from [rocker] (https://hub.docker.com/r/rocker/r-ver/~/dockerfile/)
FROM rocker/r-ver 

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
libxml2-dev \
libcairo2-dev \
libsqlite3-dev \
libmariadbd-dev \
libpq-dev \
libssh2-1-dev \
unixodbc-dev \
libcurl4-openssl-dev \
libssl-dev

#install necessary libraries
RUN R -e "install.packages(c('shiny','dplyr','DT','rhandsontable','rmarkdown'))"

#copy the current folder into the path of the app
COPY . /usr/local/src
#set working directory to the app
WORKDIR /usr/local/src

#set the unix commands to run the app
CMD ["Rscript","app.R"]