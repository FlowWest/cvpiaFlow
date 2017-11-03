library(tidyverse)
library(lubridate)
library(devtools)

watersheds <- read_csv('data-raw/MikeWrightCalSimOct2017/cvpia_calsim_nodes.csv', skip = 1) %>% select(order, watershed)

cs <- read_csv('data-raw/MikeWrightCalSimOct2017/C1_C169.csv', skip = 1) %>%
  select(date = X2, C134, C165, C116, C123, C124, C125, C109) %>%
  filter(!is.na(date)) %>%
  mutate(date = dmy(date))

ds <- read_csv('data-raw/MikeWrightCalSimOct2017/D100_D403.csv', skip = 1) %>%
  select(date = X2, D160, D166A, D117, D124, D125, D126) %>%
  filter(!is.na(date)) %>%
  mutate(date = dmy(date))

misc_flows <- left_join(cs, ds) %>%
  gather(node, flow, -date) %>%
  filter(!is.na(flow)) %>%
  mutate(flow = as.numeric(flow)) %>%
  spread(node, flow)

names(misc_flows)
# propQbypass----------------------

# propQyolo
# option 1: D160/C134
# option 2: to props, yolo 1 - D160/C134 & yolo 2 - D166A/C165

# propQsutter
# option 1: (D117 + D124 + D125 + D126)/C116
# option 2: sutter 1 - D117/C116 & sutter2 - D124/C123 & sutter3 - D125/C124 & sutter4 - D126/C125

propQbypass <- misc_flows %>%
  mutate(propQyolo = D160/C134,
         propQyolo1 = D160/C134,
         propQyolo2 = D166A/C165,
         propQsutter = (D117 + D124 + D125 + D126)/C116,
         propQsutter1 = D117/C116,
         propQsutter2 = D124/C123,
         propQsutter3 = D125/C124,
         propQsutter4 = D126/C125) %>%
  select(date, starts_with('propQ'))

use_data(propQbypass)

# upsacQ--------------------------
# flow at Bend C109, CALSIMII units cfs, sit-model units cms
upsacQ <- misc_flows %>%
  select(date, upsacQcfs = C109) %>%
  mutate(upsacQcms = cvpiaFlow::cfs_to_cms(upsacQcfs))

use_data(upsacQ)


# propQdcc---------------------------
# proportion of lower sac flow into georgiana slough and the delta cross channel
#  C400 flow at freeport
# 1) daily discharge of the Sacramento River at Freeport
# 2) an indicator variable for whether the DCC is open (1) or closed (0).
delta_cross_channel_closed <- read_csv('data-raw/DeltaCrossChannelTypicalOperations.csv', skip = 2) %>%
  mutate(Month = which(month.name == Month)) %>%
  select(-Note)

use_data(delta_cross_channel_closed)

freeportQ <- read_csv('data-raw/MikeWrightCalSimOct2017/C169-422.csv', skip = 1) %>%
  select(date = X2, C400) %>%
  filter(!is.na(date)) %>%
  mutate(date = dmy(date),
         freeportQcfs = as.numeric(C400),
         freeportQcms = cfs_to_cms(freeportQcfs)) %>%
  select(date, freeportQcfs, freeportQcms) %>%
  filter(!is.na(freeportQcfs))

use_data(freeportQ)
