library(tidyverse)
library(lubridate)
library(devtools)
library(CDECRetrieve)

watersheds <- read_csv('data-raw/MikeWrightCalSimOct2017/cvpia_calsim_nodes.csv', skip = 1) %>% select(order, watershed)

cs <- read_csv('data-raw/MikeWrightCalSimOct2017/C1_C169.csv', skip = 1) %>%
  select(date = X2, C134, C165, C116, C123, C124, C125, C109, C137, C160) %>%
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
  mutate(propQyolo = D160/(D160 + C160),
         propQyolo1 = D160/(D160 + C160),
         propQyolo2 = D166A/C165,
         propQsutter = (D117 + D124 + D125 + D126)/C116,
         propQsutter1 = D117/C116,
         propQsutter2 = D124/C123,
         propQsutter3 = D125/C124,
         propQsutter4 = D126/C125) %>%
  select(date, starts_with('propQ'))

propQbypass %>%
  filter_at(vars(starts_with("prop")), any_vars(. > 1))


propQbypass %>% arrange(desc(propQyolo))

use_data(propQbypass, overwrite = TRUE)

# upsacQ--------------------------
# flow at Bend C109, CALSIMII units cfs, sit-model units cms
upsacQ <- misc_flows %>%
  select(date, upsacQcfs = C109) %>%
  mutate(upsacQcms = cvpiaFlow::cfs_to_cms(upsacQcfs))

use_data(upsacQ)



#  C400 flow at freeport
# 1) daily discharge of the Sacramento River at Freeport
# 2) an indicator variable for whether the DCC is open (1) or closed (0).
delta_cross_channel_closed <- read_csv('data-raw/DeltaCrossChannelTypicalOperations.csv', skip = 2) %>%
  mutate(Month = which(month.name == Month), prop_days_closed = `Days Closed` / days_in_month(Month)) %>%
  select(month = Month, days_closed = `Days Closed`, prop_days_closed)

devtools::use_data(delta_cross_channel_closed, overwrite = TRUE)

freeportQ <- read_csv('data-raw/MikeWrightCalSimOct2017/C169-422.csv', skip = 1) %>%
  select(date = X2, C400) %>%
  filter(!is.na(date)) %>%
  mutate(date = dmy(date),
         freeportQcfs = as.numeric(C400),
         freeportQcms = cfs_to_cms(freeportQcfs)) %>%
  select(date, freeportQcfs, freeportQcms) %>%
  filter(!is.na(freeportQcfs))

use_data(freeportQ)

# bypass over topped when stages above values:
# fremont > 32 and tisdale > 45.5
sac_stage_tisdale <- CDECRetrieve::cdec_query(stations = 'TIS', sensor_num = '1', dur_code = 'H',
                         start_date = '1997-02-25', end_date = '2017-02-25')

sac_stage_tisdale %>%
  filter(!is.na(datetime)) %>%
  mutate(date = as_date(datetime)) %>%
  select(date, stage_ft = parameter_value) %>%
  group_by(date) %>%
  summarise(daily_stage_ft = mean(stage_ft, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(month = month(date), year = year(date),
         overtopped = daily_stage_ft > 45.5) %>%
  group_by(month, year) %>%
  summarise(days_overtopped = sum(overtopped, na.rm = TRUE),
            total_days = n()) %>%
  ggplot(aes(x = as.factor(month), y = days_overtopped)) +
  geom_boxplot() +
  geom_jitter(size = .5, pch = 21, width = .2, height = 0) +
  theme_minimal() +
  labs(x = 'months', y = 'days tisdale overtopped') +
  theme(text = element_text(size = 18))

sac_stage_fremont <- CDECRetrieve::cdec_query(stations = 'FRE', sensor_num = '1', dur_code = 'H',
                                              start_date = '1984-01-01', end_date = '2017-02-25')

sac_stage_fremont %>%
  filter(!is.na(datetime)) %>%
  mutate(date = as_date(datetime)) %>%
  select(date, stage_ft = parameter_value) %>%
  group_by(date) %>%
  summarise(daily_stage_ft = mean(stage_ft, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(month = month(date), year = year(date),
         overtopped = daily_stage_ft > 32) %>%
  group_by(month, year) %>%
  summarise(days_overtopped = sum(overtopped, na.rm = TRUE),
            total_days = n()) %>%
  ggplot(aes(x = as.factor(month), y = days_overtopped)) +
  geom_boxplot() +
  geom_jitter(size = .5, pch = 21, width = .2, height = 0) +
  theme_minimal() +
  labs(x = 'months', y = 'days fremont overtopped') +
  theme(text = element_text(size = 18))
