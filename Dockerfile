FROM python:3.10

USER root

# Install r-lang and kernel
RUN apt update && \
    apt install -y r-base r-cran-irkernel && \
    apt clean -y && \
    apt autoclean -y \
    apt autoremove -y

ENV MAKE="make -j4"

# Install forecast hub requirements (Rlang)
RUN R -e "install.packages(c('evalcast', 'covidcast', 'magrittr', 'lubridate'), repos='http://cran.rstudio.com/')"
RUN R -e "remotes::install_github('cmu-delphi/covidcast', ref = 'main', subdir = 'R-packages/evalcast')"
