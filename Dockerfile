FROM rstudio/plumber

RUN apt-get update -qq && apt-get install -y libssl-dev libcurl4-gnutls-dev pandoc

RUN R -e "install.packages(c('leaflet', 'tidymodels', 'ranger'))"

COPY . .

EXPOSE 8000

ENTRYPOINT ["R", "-e", \
"pr <- plumber::plumb('./API/api.R'); pr$run(host='0.0.0.0', port=8000)"]