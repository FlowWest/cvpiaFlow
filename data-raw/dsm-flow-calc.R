library(tidyverse)
library(lubridate)
library(dataRetrieval)
library(devtools)


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

# Mike Wrights notes on RedBluff.csv

# date is the CalLite-CV date column, the next column with the name of a
# CalLite-CV element is the LocalInflow node, cs_date is for my reference to
# avoid screwing up the 10/2014=10/1925 matching and it sounds like you can use
# it for something too, and the CalSim II records corresponding to the local
# inflows to the CalLite-CV element are listed afterward (I've got them in cfs
# now, to match the CalLite-CV data). 'matches for other csvs.csv' contains the
# mappings between the DSM streams and CalSim II elements, as a one-stop summary
# for which DSM streams are showing up in which specific .csvs like this one. I
# renamed the CalSim II elements that map to DSM streams in this csv; everything
# that still has a CalSim II name is one of the elements that contributes to the
# total (the denominator) but is NOT a DSM stream.
# EXAMPLE CALCULATION: For 10/2014, Cow Creek has 27.1 cfs,
# the total of all inflows sum(D3:I3)=405.8,
# and 27.1/405.8=0.066668, the fraction of total CalSim II inflow in Cow Creek.
# Applying that fraction to the CalLite-CV RedBluff LocalInflow number we get
# Cow Creek DSM flow = 0.066668*259.7=17.31 cfs.

redbluff <- read_csv('data-raw/RedBluff.csv', skip = 1)

redbluff_disaggregated <- redbluff %>%
  mutate(denom = `Cow Creek` + `Cottonwood Creek` + `Battle Creek` +
           `Paynes Creek` + I109 + I112,
         `Cow Creek` = `Cow Creek` / denom * RedBluff,
         `Cottonwood Creek` = `Cottonwood Creek` / denom * RedBluff,
         `Battle Creek` = `Battle Creek` / denom * RedBluff,
         `Paynes Creek` = `Paynes Creek` / denom * RedBluff,
         cs_date = dmy(cs_date)) %>%
  select(date, cs_date, `Cow Creek`:`Paynes Creek`)

# Mike Wrights notes on YubaFeather.csv

#date is the CalLite-CV date column, the next column with the name of a
#CalLite-CV element is the LocalInflow node (note occasional negative
#values...), cs_date is for my reference to avoid screwing up the
#10/2014=10/1925 matching and it sounds like you can use it for something too,
#and the CalSim II records corresponding to the local inflows to the CalLite-CV
#element are listed afterward (I've got them in cfs now, to match the CalLite-CV
#data). 'matches for other csvs.csv' contains the mappings between the DSM
#streams and CalSim II elements, as a one-stop summary for which DSM streams are
#showing up in which specific .csvs like this one. I renamed the CalSim II
#elements that map to DSM streams in this csv; everything that still has a
#CalSim II name is one of the elements that contributes to the total (the
#denominator) but is NOT a DSM stream. Here we have only the Bear River (C282)
#and a small 'projected gain in DSA69' element I207 in the area the
#documentation considers the YubaFeather node's Local Inflow area.
# EXAMPLE CALCULATION: For 1/2015, Bear River has 12.24 cfs, the total of all inflows
#sum(D6:E6)=3138.24, and 12.24/3138.24=0.003901, the fraction of total CalSim II
#inflow in the Bear River. Applying that fraction to the CalLite-CV YubaFeather
#LocalInflow number we get Bear River DSM flow = 0.003901*258.1=1.01 cfs. Given
#the bizarre spikiness of I207, maybe the CSII Bear River numbers unadjusted for
#anything or the YubaFeather LocalInflows alone would be better representations
#of the Bear River...

yubafeather <- read_csv('data-raw/YubaFeather.csv', skip = 1)

bb <- yubafeather %>%
  mutate(denom = `Bear River` + I207,
         BearRiver = `Bear River` / denom * YubaFeather,
         cs_date = dmy(cs_date)) %>%
  select(date, cs_date, `Bear River`, BearRiver, YubaFeather)
View(bb)

# compare monthly mean gage flow during the period to see if YubaFeather node is better
bear <- dataRetrieval::readNWISdv(siteNumbers = '11424000', parameterCd = '00060',
                          '1980-01-01', '1999-12-31')
glimpse(bear)

gage_data <- bear %>%
  mutate(year = year(Date), month = month(Date), flow =  X_00060_00003) %>%
  group_by(year, month) %>%
  summarise(monthly_mean_flow = mean(flow, na.rm = TRUE)) %>%
  mutate(type = 'gage data')

bb %>%
  gather(Node, flow, -date, -cs_date) %>%
  mutate(type = ifelse(Node == 'Bear River', 'disaggregated', 'YubaFeather'),
         year = year(cs_date), month = month(cs_date)) %>%
  select(year, month, monthly_mean_flow = flow, type) %>%
  filter(year >= 1980, year <= 1999) %>%
  bind_rows(gage_data) %>%
  mutate(date = ymd(paste(year, month, '01', sep = '-'))) %>%
  ggplot(aes(x = date, y = monthly_mean_flow, color = type)) +
  geom_line() +
  theme_minimal() +
  labs(y = 'monthly mean flow') +
  theme(text = element_text(size = 18))

# TODO waiting to hear from mike before selecting node for bear

# Mike Wrights notes on Eastside.csv

# date is the CalLite-CV date column, the next column with the name of a
# CalLite-CV element is in this case the OUTFLOW node because the LocalInflow
# one isn't saving results and when I run the model it has negative values
# pretty regularly (this is different from other nodes but this node is unique
# with only two inflows so maybe that's defensible... but note negative value in
# (only) first time step...), cs_date is for my reference to avoid screwing up
# the 10/2014=10/1925 matching and it sounds like you can use it for something
# too, and the CalSim II records corresponding to the local inflows to the
# CalLite-CV element are listed afterward (I've got them in cfs now, to match
# the CalLite-CV data). 'matches for other csvs.csv' contains the mappings
# between the DSM streams and CalSim II elements, as a one-stop summary for
# which DSM streams are showing up in which specific .csvs like this one. I
# renamed the CalSim II elements that map to DSM streams in this csv; everything
# that still has a CalSim II name is one of the elements that contributes to the
# total (the denominator) but is NOT a DSM stream. The CalSim II run I'm using
# at the moment is the most recent representation of current operations I've
# received; probably we'll be choosing a different baseline in the future but
# the matches csv mentioned above contains the CalSim II match for DSM streams,
# so I can go back and re-pull those time series if/when necessary. NOTE that
# matching 2014 to 1925 results in the last ~7 years of the CalLite-CV run not
# having an equivalent CS2 number... EXAMPLE CALCULATION: For 11/2014, Mokelumne
# River has 240.7 cfs, the total of all inflows sum(D4:E4)=269.4, and
# 240.7/269.4=0.893467, the fraction of total CalSim II inflow in the Mokelumne
# River. Applying that fraction to the CalLite-CV Eastside Outflow number we get
# Mokelumne River DSM flow = 0.893467*79.16=70.73 cfs.

eastside <- read_csv('data-raw/Eastside.csv', skip = 1)

eastside_disaggregated <- eastside %>%
  mutate(denom = `Mokelumne River` + `Cosumnes River`,
         `Mokelumne River` = `Mokelumne River` / denom * Eastside,
         `Cosumnes River` = `Cosumnes River` / denom * Eastside,
         cs_date = dmy(cs_date)) %>%
  select(date, cs_date, `Mokelumne River`, `Cosumnes River`) %>%
  gather(river, flow, -date, -cs_date) %>%
  mutate(flow = case_when(
    flow < 0 ~ 0,
    is.nan(flow) ~ 0,
    TRUE ~ flow
  )) %>%
  spread(river, flow) %>%
  arrange(cs_date)

View(eastside_disaggregated)

ord <- read_csv('data-raw/watershed_order.csv') %>%
  pull(Watershed)

all_flow <- read_csv('data-raw/flowmaster.csv', skip = 1) %>%
  mutate(`Bear River` = NA, `Sutter Bypass` = NA,
         `Bear Creek` = NA, `Butte Creek` = NA) %>% #place holders
  bind_cols(select(eastside_disaggregated, -date),
            select(wilkins_disaggregated, -date, -cs_date),
            select(redbluff_disaggregated, -date, -cs_date)) %>%
  select(date = cs_date, ord) %>%
  filter(!is.na(date))

use_data(all_flow, overwrite = TRUE)

