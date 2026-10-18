## Laubfrosch_measdata

Laubfrosch_measdata is an interactive web application built with **R Shiny** to 
visualize surface measurement data (e.g., precipitation, sunshine duration).

It allows users to explore open source data published by DWD (Deutscher Wetterdienst; opendata.dwd.de)
and MeteoSwiss (Swiss Federal Institute of Meteorology and Climatology; data.geo.admin.ch)

## Table of Contents

- [Live Application](#live-application)
- [Features](#features)
- [Repository Structure](#repository-structure)
- [Requirements](#requirements)
- [Installation](#installation)
- [Run the Application Locally](#run-the-application-locally)
- [Usage](#usage)
- [Data Sources](#data-sources)
- [Dependencies](#dependencies)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [Contact](#contact)

## Live Application

The application is deployed on Posit Cloud and can be accessed through a web browser.

**Live app:** [Open the application](https://laubfrosch-measdata.share.connect.posit.cloud/)

**Source code:** [GitHub repository](https://github.com/m-kehl/measdata)

No local R installation is required to use the deployed version. However, the
deployed version is slow as the free deployment plan of Posit Cloud is used and
a local installation might be favorable.

## Features

The application provides the following functionality:

- **Plots:** Laubfrosch_measdata visualizes surface measurement data
(e.g., temperature, sunshine duration) with 10-min, daily, and monthly granularity
for surface measurement stations in Germany and Switzerland.
- **Interactive interface:** The user can choose the measurements stations, 
parameters, and granularity for which the data is accessed and visualized.

## Repository Structure

The repository contains the application source code and any supporting files required to run it.

```text
icond2/
├── app.R                 # main Shiny application
├── input.R               # input data, e.g., lon/lat for Bundeshauptstädte
├── functions/            # functions required to run the app, including Shiny server and UI function
├── www/                  # static assets (style.css)
├── .gitignore            # files excluded from version control
└── README.md             # project documentation
```

## Requirements

To run the application locally, you need:

- **R:** A recent version of R.
- **Git:** Required if you want to clone the repository.
- **Internet access:** Required to clone the repository and install R packages.

## Installation

### 1. Install R and Git

Download and install R from [CRAN](https://cran.r-project.org/).
Download and install Git from [git-scm](https://git-scm.com/)

### 2. Clone the repository

Set up your git connection via html or SSH.

Then open a terminal and run (first line for html, second line for SSH):

```bash
git clone git@github.com:m-kehl/measdata.git¨
git clone https://github.com/m-kehl/measdata.git
```

Alternatively, download the repository as a ZIP file from GitHub and extract it locally.

### 3. Open the project

Open the project directory in RStudio, or set the working directory to the repository root in your R session.

```r
setwd("path/to/your/project")
```

Replace the path with the location of your local project directory.

## Run the Application Locally

### 1. Install dependencies

Install the packages required by the application.

For example:

```r
install.packages(c(
  "shiny",          # To create ShinyApp
  "shinybrowser",   # To detect screen size
  "shinydashboard", # To create boxes for UI
  "shinyjs",        # To use CSS styles
  "waiter",         # To show waiters while data is downloaded/processed
  "rdwd",           # To access data provided by DWD (opendata.dwd.de)
  "terra",          # To visualize raster data
  "lubridate",      # To handle date and time
  "RCurl",          # To download data provided by DWD
  "curl",           # To read metadata
  "dplyr",          # To handle data frames
  "leaflet",        # To create interactive maps
  "miceadds"       
))

```

### 2. Launch the application

From the R console, run:

```r
shiny::runApp()
```

Alternatively, specify the application directory:

```r
shiny::runApp("path/to/your/project")
```

If using RStudio, open `app.R` and click **Run App**.

The application should open in your default web browser or in the RStudio Viewer.

## Usage

Once the application is running:

1. Open the application in your browser.
2. Select the desired variables.
3. Explore the generated visualizations.

## Data Sources

Laubfrosch_measdata uses open government data provided by Deutscher Wetterdienst 
(DWD; ftp://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/) and
the Swiss Federal Institute of Meteorology and Climatology
(MeteoSwiss; https://data.geo.admin.ch/ch.meteoschweiz.ogd-smn/) and its
according metadata (https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/10_minutes/air_temperature/now/zehn_now_tu_Beschreibung_Stationen.txt; 
https://data.geo.admin.ch/ch.meteoschweiz.ogd-smn/ogd-smn_meta_stations.csv).
¨
## Dependencies

The application relies on R packages for its functionality.

| Package | Purpose |
|---|---|
| `shiny` | Create interactive web applications |
| `shinybrowser` | Detect the user's browser and screen size |
| `shinydashboard` | Create dashboard layouts and UI boxes |
| `shinyjs` | Add JavaScript functionality and manipulate CSS styles |
| `waiter` | Display loading screens and indicators while data is downloaded or processed |
| `rdwd` | Access and download meteorological data from the German Weather Service (DWD) Open Data server |
| `terra` | Read, process, and visualize raster and spatial data |
| `lubridate` | Handle and manipulate dates and times |
| `RCurl` | Download data from URLs, including DWD data |
| `curl` | Transfer data from URLs and retrieve metadata |
| `dplyr` | Manipulate, filter, and transform data frames |
| `leaflet` | Create interactive maps and visualize spatial data |
| `R.utils` | Neede by readDWD() when used online via shinyapp.io/Posit Cloud |
| `miceadds` ||

## Deployment

The application is deployed on Posit Cloud, while the source code is maintained in GitHub.

### Access the deployed application

Use the live application link provided above. Users can interact with the deployed
version without installing R or downloading the source code.

## Contributing

Contributions, suggestions, and bug reports are welcome.

To contribute:

1. Fork the repository.
2. Create a new branch for your changes.
3. Implement and test your changes locally.
4. Submit a pull request describing the changes.

Please include enough information to reproduce any reported issues.

## Contact

For questions, suggestions, or bug reports, please contact:

- **Author:** M. Kehl
- **Email:** mkehl.laubfrosch@gmail.com
- **GitHub:** https://github.com/m-kehl
