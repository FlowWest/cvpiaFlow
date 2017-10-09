library(tidyverse)
library(lubridate)


# Notes from Mike Wright about WilkinsSlough.csv (cell A1)

# date is the CalLite-CV date column, the next column with the name of a
# CalLite-CV element is the LocalInflow data from the CT_noCC run for the
# CalLite-CV element from which we're going to be deriving these DSM stream flow
# time series in cfs (I couldn't find an output file in the Basin Study
# documentation for this like I did for the Outflow data in the master csv but
# spot checks indicated that the GoldSim model file I'm pulling these from have
# identical data to those outputs), cs_date is for my reference to avoid
# screwing up the 10/2014=10/1925 matching and it sounds like you can use it for
# something too, and the CalSim II records corresponding to the local inflows to
# the CalLite-CV element are listed afterward (I've got them in cfs now, to
# match the CalLite-CV data). 'matches for other csvs.csv' contains the mappings
# between the DSM streams and CalSim II elements, as a one-stop summary for
# which DSM streams are showing up in which specific .csvs like this one. I
# renamed the CalSim II elements that map to DSM streams in this csv; everything
# that still has a CalSim II name is one of the elements that contributes to the
# total (the denominator) but is NOT a DSM stream. The CalSim II run I'm using
# at the moment is the most recent representation of current operations I've
# received; probably we'll be choosing a different baseline in the future but
# the matches csv mentioned above contains the CalSim II match for DSM streams,
# so I can go back and re-pull those time series if/when necessary. C17603 is
# Sites Reservoir outflows into the Sacramento in this region; it's zeroed out
# in the run I'm using but that should be re-checked if a different run is used.
# NOTE that matching 2014 to 1925 results in the last ~7 years of the CalLite-CV
# run not having an equivalent CS2 number...
# EXAMPLE CALCULATION: For 10/2014,
# Elder Creek has 13.8 cfs, the total of all WiSl inflows sum(D3:M3)=550.4, and
# 13.8/550.4=0.025155, the fraction of total CalSim II inflow in Elder Creek.
# Applying that fraction to the CalLite-CV WilkinsSlough LocalInflow number we
# get Elder Creek DSM flow = 0.25155*189.9=4.78 cfs.

wilkins <- read_csv("data-raw/WilkinsSlough.csv", skip=1)

wilkins_disaggregated <- wilkins %>%
  mutate(denom = `Elder Creek` + `Thomes Creek` + `Antelope Creek` +
           `Mill Creek` + `Deer Creek` + `Big Chico Creek` + `Stony Creek` +
           C184A + I118 + I123,
         `Elder Creek` = `Elder Creek` / denom * WilkinsSlough,
         `Thomes Creek` = `Thomes Creek` / denom * WilkinsSlough,
         `Antelope Creek` = `Antelope Creek` / denom * WilkinsSlough,
         `Mill Creek` = `Mill Creek` / denom * WilkinsSlough,
         `Deer Creek` = `Deer Creek` / denom * WilkinsSlough,
         `Big Chico Creek` = `Big Chico Creek` / denom * WilkinsSlough,
         `Stony Creek` = `Stony Creek` / denom * WilkinsSlough,
         cs_date = dmy(cs_date)) %>%
  select(date, cs_date, `Elder Creek`: `Stony Creek`)

View(wilkins_disaggregated)
