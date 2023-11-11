#-------------------------------------------------------------------
# Project: Non-Cognitive Skills of NEET
# Organization: SFedU Future Skills Research Lab
# Objective: Install packages needed for the analysis
# Author: Garen Avanesian, Valeria Egorova
# Date: 10 Nov 2023
#-------------------------------------------------------------------


# List of required packages

required_packages <- c("MatchIt",
                        "cobalt",
                        "tidyverse",
                        "sjPlot",
                        "haven",
                        "naniar",
                        "DescTools",
                        "psych",
                        "corrplot",
                        "corrr",
                        "Hmisc",
                        "srvyr",
                        "ggridges",
                        "data.table",
                        "optmatch")


# Function to check and install packages
check_and_install_packages <- function(packages) {
  for (package in packages) {
    if (!requireNamespace(package, quietly = TRUE)) {
      install.packages(package)
    }
    library(package, character.only = TRUE)
  }
}


# Call the function with the list of required packages
check_and_install_packages(required_packages)