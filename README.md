# PSY6422_final_project
Population per Country per Year

Project:
This document describes an analysis of world population data. The analysis includes an interactive Shiny application that allows users to explore population data for different years.

Questions:
How the population changes over the years for every country? How fast the global population rises? What is the function discribing the population?

Files:
population-and-demography.csv 			: Data set downloaded from the link bellow. Different data sets from the same web page can be drawn changing either the Countries or the age groups or other critiria.
final_project_220257813_Population.R 	: The R code.
final_project_220257813_Population.Rmd 	: R markdown with full explanation of the code.
final_project_220257813_Population.html	: The web page. It is the best format, because there is an interactive part.
TM_WORLD_BORDERS_SIMPL-0.3.dbf			: These 4 files contain information about the maps. The file with SHP extantion is a shape file.
TM_WORLD_BORDERS_SIMPL-0.3.prj
TM_WORLD_BORDERS_SIMPL-0.3.shp
TM_WORLD_BORDERS_SIMPL-0.3.shx

The data for this analysis were received from ourworldindata.org, and more spesificaly from https://ourworldindata.org/world-population-growth. The dataset includes Population data for the years 1950 to 2100 (predictions).

Max Roser, Hannah Ritchie, Esteban Ortiz-Ospina and Lucas Rodés-Guirao (2013) - "World Population Growth". Published online at OurWorldInData.org. Retrieved from: 'https://ourworldindata.org/world-population-growth' [Online Resource]

Before launching the app, ensure the setwd() function points to the directory where your files reside. While this function should be found on line 24, it may be positioned a little differently.

Also, it's important to have all required packages installed. These are listed at the top of the code and include several advanced libraries.

For ease of understanding, the script follows specific conventions. For instance, empty lines, the number of '#' symbols, and variable naming conventions all serve specific purposes. You can find explanations for these at the beginning of the code.
