#' Total Flow Diverted
#' @description A dataset containing the diverted flow in cfs within watersheds for
#' use with the CVPIA Science Integration Team Decision Support Model.
#'
#' @format dataframe with 985 rows and 32 variables:
#' \describe{
#' \item{date}{CALSIM II date}
#' \item{Upper Sacramento River}{D104}
#' \item{Antelope Creek}{(C11307 / (C11307 + C11308 + C11309) * D11305)}
#' \item{Battle Creek}{no modeled diversions}
#' \item{Bear Creek}{no modeled diversions}
#' \item{Big Chico Creek}{no modeled diversions}
#' \item{Butte Creek}{(C217B + D217)}
#' \item{Clear Creek}{no modeled diversions}
#' \item{Cottonwood Creek}{no modeled diversions}
#' \item{Cow Creek}{no modeled diversions}
#' \item{Deer Creek}{(C11309 / (C11307 + C11308 + C11309) * D11305)}
#' \item{Elder Creek}{(C11303 / (C11303 + C11304) * D11301)}
#' \item{Mill Creek}{(C11308 / (C11307 + C11308 + C11309) * D11305)}
#' \item{Paynes Creek}{no modeled diversions}
#' \item{Stony Creek}{D17301}
#' \item{Thomes Creek}{(C11304 / (C11303 + C11304) * D11301)}
#' \item{Upper-mid Sacramento River}{(D109 + D112 + D113A + D113B + D114 + D118 + D122A + D122B + D123 + D124A + D128_WTS + D128)}
#' \item{Sutter Bypass}{no modeled diversions}
#' \item{Bear River}{D285}
#' \item{Feather River}{(D201 + D202 + D7A + D7B)}
#' \item{Yuba River}{D230}
#' \item{Lower-mid Sacramento River}{(D129A + D134 + D162 + D163 + D165)}
#' \item{Yolo Bypass}{no modeled diversions}
#' \item{American River}{D302}
#' \item{Lower Sacramento River}{(D167 + D168 + D168A_WTS)}
#' \item{Calaveras River}{(D506A + D506B + D506C + D507)}
#' \item{Cosumnes River}{no modeled diversions}
#' \item{Mokelumne River}{(D503A + D503B + D503C + D502A + D502B)*}
#' \item{Merced River}{(D562 + D566)}
#' \item{Stanislaus River}{D528}
#' \item{Tuolumne River}{D545}
#' \item{San Joaquin River}{(D637 + D630B + D630A + D620B)}
#' }
#'
#' @details The proportion diverted was calculated using 'FLOW-CHANNEL' and 'FLOW-DELIVERY' nodes from CALSIM II.
#' The nodes and calculation for each watershed are outlined above.
#'
#' The diversions of Antelope Creek, Deer Creek and Mill Creek are represented by one diversion node.
#' Diversions for these creeks were estimated in proportion to their flow. Elder Creek and Thomes Creek
#' are also represented with a single node and their diversions were estimated using the same method.
#'
#' *Mokelumne River flow and diversions are from a separate model provided by EBMUD.
#'
#' The CALSIM II run is a Reclamation product used to replicate current operations for comparison
#' with proposed adjustments under an ongoing Endangered Species Act consultation with the National Marine
#' Fisheries Service. A current NMFS Biological Opinion concluded that, as proposed, CVP and SWP operations
#' were likely to jeopardize the continued existence of four federally- listed anadromous fish species:
#' Sacramento River winter-run Chinook salmon, Central Valley spring-run Chinook salmon, California Central Valley
#' steelhead, and the Southern distinct population segment of the North American green sturgeon. This CALSIM II
#' run was used as the basis of comparison for other potential operations that could offset impacts to listed species.
#' More information on CALSIM II is available \href{http://baydeltaoffice.water.ca.gov/modeling/hydrology/CalSim/index.cfm}{here}
#'
#' \href{https://s3-us-west-2.amazonaws.com/cvpiaflow-r-package/BST_CALSIMII_schematic_040110.jpg}{CALSIM II schematic}
#'
#' @source
#' \itemize{
#'   \item \strong{Data Wrangling:} Sadie Gill  \email{sgill@@flowwest.com}
#'   \item \strong{Node Selection:} Mark Tompkins \email{mtompkins@@flowwest.com} and Mike Urkov \email{mike.urkov@@gmail.com}
#'   \item \strong{CALSIM Model Output:} Michael Wright \email{mwright@@usbr.gov}
#' }
#'
"total_diverted"

#' Proportion of Flow Diverted
#' @description A dataset containing the proportion of flow diverted within watersheds for
#' use with the CVPIA Science Integration Team Decision Support Model.
#'
#' @format dataframe with 985 rows and 32 variables:
#' \describe{
#' \item{date}{CALSIM II date}
#' \item{Upper Sacramento River}{D104 / C104}
#' \item{Antelope Creek}{(C11307 / (C11307 + C11308 + C11309) * D11305) / C11307}
#' \item{Battle Creek}{no modeled diversions}
#' \item{Bear Creek}{no modeled diversions}
#' \item{Big Chico Creek}{no modeled diversions}
#' \item{Butte Creek}{(C217B + D217) / (C217B + D217 + C217A)}
#' \item{Clear Creek}{no modeled diversions}
#' \item{Cottonwood Creek}{no modeled diversions}
#' \item{Cow Creek}{no modeled diversions}
#' \item{Deer Creek}{(C11309 / (C11307 + C11308 + C11309) * D11305) / C11309}
#' \item{Elder Creek}{(C11303 / (C11303 + C11304) * D11301) / C11303}
#' \item{Mill Creek}{(C11308 / (C11307 + C11308 + C11309) * D11305) / C11308}
#' \item{Paynes Creek}{no modeled diversions}
#' \item{Stony Creek}{D17301 / C42}
#' \item{Thomes Creek}{(C11304 / (C11303 + C11304) * D11301) / C11304}
#' \item{Upper-mid Sacramento River}{(D109 + D112 + D113A + D113B + D114 + D118 + D122A + D122B + D123 + D124A + D128_WTS + D128) / C110}
#' \item{Sutter Bypass}{no modeled diversions}
#' \item{Bear River}{D285 / (C285 + D285)}
#' \item{Feather River}{(D201 + D202 + D7A + D7B) / C6}
#' \item{Yuba River}{D230 / (C230 + D230)}
#' \item{Lower-mid Sacramento River}{(D129A + D134 + D162 + D163 + D165) / C128}
#' \item{Yolo Bypass}{no modeled diversions}
#' \item{American River}{D302 / C9}
#' \item{Lower Sacramento River}{(D167 + D168 + D168A_WTS) / C166}
#' \item{Calaveras River}{(D506A + D506B + D506C + D507) / C92}
#' \item{Cosumnes River}{no modeled diversions}
#' \item{Mokelumne River}{(D503A + D503B + D503C + D502A + D502B) / C91*}
#' \item{Merced River}{(D562 + D566) / C561}
#' \item{Stanislaus River}{D528 / C520}
#' \item{Tuolumne River}{D545 / C540}
#' \item{San Joaquin River}{(D637 + D630B + D630A + D620B) / (D637 + D630B + D630A + D620B + C637)}
#' }
#'
#' @details The proportion diverted was calculated using 'FLOW-CHANNEL' and 'FLOW-DELIVERY' nodes from CALSIM II.
#' The nodes and calculation for each watershed are outlined above.
#'
#' The diversions of Antelope Creek, Deer Creek and Mill Creek are represented by one diversion node.
#' Diversions for these creeks were estimated in proportion to their flow. Elder Creek and Thomes Creek
#' are also represented with a single node and their diversions were estimated using the same method.
#'
#' *Mokelumne River flow and diversions are from a separate model provided by EBMUD.
#'
#' The CALSIM II run is a Reclamation product used to replicate current operations for comparison
#' with proposed adjustments under an ongoing Endangered Species Act consultation with the National Marine
#' Fisheries Service. A current NMFS Biological Opinion concluded that, as proposed, CVP and SWP operations
#' were likely to jeopardize the continued existence of four federally- listed anadromous fish species:
#' Sacramento River winter-run Chinook salmon, Central Valley spring-run Chinook salmon, California Central Valley
#' steelhead, and the Southern distinct population segment of the North American green sturgeon. This CALSIM II
#' run was used as the basis of comparison for other potential operations that could offset impacts to listed species.
#' More information on CALSIM II is available \href{http://baydeltaoffice.water.ca.gov/modeling/hydrology/CalSim/index.cfm}{here}
#'
#' \href{https://s3-us-west-2.amazonaws.com/cvpiaflow-r-package/BST_CALSIMII_schematic_040110.jpg}{CALSIM II schematic}
#'
#' @source
#' \itemize{
#'   \item \strong{Data Wrangling:} Sadie Gill  \email{sgill@@flowwest.com}
#'   \item \strong{Node Selection:} Mark Tompkins \email{mtompkins@@flowwest.com} and Mike Urkov \email{mike.urkov@@gmail.com}
#'   \item \strong{CALSIM Model Output:} Michael Wright \email{mwright@@usbr.gov}
#' }
#'
"proportion_diverted"

#' Flow
#' @description A dataset containing the flow in cfs within watersheds for
#' use with the CVPIA Science Integration Team Decision Support Model to develope habitat inputs.
#'
#' @format dataframe with 985 rows and 33 variables:
#' \describe{
#' \item{date}{CALSIM II date}
#' \item{Upper Sacramento River}{C104}
#' \item{Antelope Creek}{C11307}
#' \item{Battle Creek}{C10803}
#' \item{Bear Creek}{C11001*}
#' \item{Big Chico Creek}{C11501}
#' \item{Butte Creek}{C217A}
#' \item{Clear Creek}{C3}
#' \item{Cottonwood Creek}{C10802}
#' \item{Cow Creek}{C10801}
#' \item{Deer Creek}{C11309}
#' \item{Elder Creek}{C11303}
#' \item{Mill Creek}{C11308}
#' \item{Paynes Creek}{C11001}
#' \item{Stony Creek}{C142A}
#' \item{Thomes Creek}{C11304}
#' \item{Upper-mid Sacramento River}{C115}
#' \item{Sutter Bypass}{D117 + D124 + D125 + D126}
#' \item{Bear River}{C285}
#' \item{Feather River}{C203}
#' \item{Yuba River}{C230}
#' \item{Lower-mid Sacramento River1}{C134}
#' \item{Lower-mid Sacramento River2}{C160}
#' \item{Yolo Bypass}{C157}
#' \item{American River}{C9}
#' \item{Lower Sacramento River}{C166}
#' \item{Calaveras River}{C92}
#' \item{Cosumnes River}{C501}
#' \item{Mokelumne River}{C91**}
#' \item{Merced River}{C561}
#' \item{Stanislaus River}{C520}
#' \item{Tuolumne River}{C540}
#' \item{San Joaquin River}{C630}
#' }
#'
#' @details The flow is represented using 'FLOW-CHANNEL' and 'FLOW-DELIVERY' nodes from CALSIM II.
#' The nodes and calculation for each watershed are outlined above.
#'
#' The Lower-mid Sacramento River has two nodes, one above Fremont Weir (C134) and one below (C160).
#' When calculating habitat for the Lower-Mid Sacramento river, calculate the habitat at each flow node and
#' sum them proportion to the length of stream above and below the weir:
#' \deqn{35.6/58 * (habitat at C134) + 22.4/58 * (habitat at C160)}
#'
#' *Because there are no modeled flows at Bear Creek, flows at Paynes Creek are used
#' **Mokelumne River flow is from a separate model provided by EBMUD.
#'
#' The CALSIM II run is a Reclamation product used to replicate current operations for comparison
#' with proposed adjustments under an ongoing Endangered Species Act consultation with the National Marine
#' Fisheries Service. A current NMFS Biological Opinion concluded that, as proposed, CVP and SWP operations
#' were likely to jeopardize the continued existence of four federally- listed anadromous fish species:
#' Sacramento River winter-run Chinook salmon, Central Valley spring-run Chinook salmon, California Central Valley
#' steelhead, and the Southern distinct population segment of the North American green sturgeon. This CALSIM II
#' run was used as the basis of comparison for other potential operations that could offset impacts to listed species.
#' More information on CALSIM II is available \href{http://baydeltaoffice.water.ca.gov/modeling/hydrology/CalSim/index.cfm}{here}
#'
#' \href{https://s3-us-west-2.amazonaws.com/cvpiaflow-r-package/BST_CALSIMII_schematic_040110.jpg}{CALSIM II schematic}
#'
#' @source
#' \itemize{
#'   \item \strong{Data Wrangling:} Sadie Gill  \email{sgill@@flowwest.com}
#'   \item \strong{Node Selection:} Mark Tompkins \email{mtompkins@@flowwest.com} and Mike Urkov \email{mike.urkov@@gmail.com}
#'   \item \strong{CALSIM Model Output:} Michael Wright \email{mwright@@usbr.gov}
#' }
#'
"flows"

#' Proportion of Sacramento River Flow through the Sutter and Yolo Bypasses
#' @description A dataset containing the proportion of Sacramento River flow within the bypasses for
#' use with the CVPIA Science Integration Team Decision Support Model to apportion fish onto the bypasses.
#'
#' @format dataframe with 984 rows and 9 variables:
#' \describe{
#' \item{date}{CALSIM II date}
#' \item{propQyolo}{D160/C134}
#' \item{propQyolo1}{D160/C134}
#' \item{propQyolo2}{D166A/C165}
#' \item{propQsutter}{(D117 + D124 + D125 + D126)/C116}
#' \item{propQsutter1}{D117/C116}
#' \item{propQsutter2}{D124/C123}
#' \item{propQsutter3}{D125/C124}
#' \item{propQsutter4}{D126/C125}
#' }
#'
#' @details The proportions of Sacramento River flowing through the bypasses are represented using
#' 'FLOW-CHANNEL' and 'FLOW-DELIVERY' nodes from CALSIM II.
#' The nodes and calculation for each watershed are outlined above.
#'
#' \strong{Model Usage:}
#'
#' Option 1 - propQyolo and propQsutter represent the proportion of flow as a single value for the bypasses
#'
#' Option 2 - use the numbered propQ columns to represent the proportion of flow at each weir
#'
#' The CALSIM II run is a Reclamation product used to replicate current operations for comparison
#' with proposed adjustments under an ongoing Endangered Species Act consultation with the National Marine
#' Fisheries Service. A current NMFS Biological Opinion concluded that, as proposed, CVP and SWP operations
#' were likely to jeopardize the continued existence of four federally- listed anadromous fish species:
#' Sacramento River winter-run Chinook salmon, Central Valley spring-run Chinook salmon, California Central Valley
#' steelhead, and the Southern distinct population segment of the North American green sturgeon. This CALSIM II
#' run was used as the basis of comparison for other potential operations that could offset impacts to listed species.
#' More information on CALSIM II is available \href{http://baydeltaoffice.water.ca.gov/modeling/hydrology/CalSim/index.cfm}{here}
#'
#' \href{https://s3-us-west-2.amazonaws.com/cvpiaflow-r-package/BST_CALSIMII_schematic_040110.jpg}{CALSIM II schematic}
#'
#' @source
#' \itemize{
#'   \item \strong{Data Wrangling:} Sadie Gill  \email{sgill@@flowwest.com}
#'   \item \strong{Node Selection:} Mark Tompkins \email{mtompkins@@flowwest.com} and Mike Urkov \email{mike.urkov@@gmail.com}
#'   \item \strong{CALSIM Model Output:} Michael Wright \email{mwright@@usbr.gov}
#' }
#'
"propQbypass"

#' Upper Sacramento River Flow
#' @description A dataset containing the Upper Sacramento River flow in cfs and cms
#'
#' @format dataframe with 984 rows and 3 variables:
#' \describe{
#' \item{date}{CALSIM II date}
#' \item{upsacQcfs}{C109, flow in cfs}
#' \item{upsacQcms}{C109, flow in cms}
#' }
#'
#' @details The Upper Sacramento River is represented using node CALSIM II 'FLOW-CHANNEL' C109 node at Bend.
#'
#' The CALSIM II run is a Reclamation product used to replicate current operations for comparison
#' with proposed adjustments under an ongoing Endangered Species Act consultation with the National Marine
#' Fisheries Service. A current NMFS Biological Opinion concluded that, as proposed, CVP and SWP operations
#' were likely to jeopardize the continued existence of four federally- listed anadromous fish species:
#' Sacramento River winter-run Chinook salmon, Central Valley spring-run Chinook salmon, California Central Valley
#' steelhead, and the Southern distinct population segment of the North American green sturgeon. This CALSIM II
#' run was used as the basis of comparison for other potential operations that could offset impacts to listed species.
#' More information on CALSIM II is available \href{http://baydeltaoffice.water.ca.gov/modeling/hydrology/CalSim/index.cfm}{here}
#'
#' \href{https://s3-us-west-2.amazonaws.com/cvpiaflow-r-package/BST_CALSIMII_schematic_040110.jpg}{CALSIM II schematic}
#'
#' @source
#' \itemize{
#'   \item \strong{Data Wrangling:} Sadie Gill  \email{sgill@@flowwest.com}
#'   \item \strong{Node Selection:} Mark Tompkins \email{mtompkins@@flowwest.com} and Mike Urkov \email{mike.urkov@@gmail.com}
#'   \item \strong{CALSIM Model Output:} Michael Wright \email{mwright@@usbr.gov}
#' }
#'
"upsacQ"

#' Return Flow
#' @description A dataset containing the proportion flows at tributary junction
#' coming from natal watershed using October CALSIM II flows. These proportions are used to estimate
#' straying in the CVPIA SIT Salmon Population Model.
#'
#' @format dataframe with 31 rows and 83 variables:
#' \describe{
#' \item{watershed}{31 CVPIA watersheds}
#' \item{1921-10-31}{The modeled proportion flow for October 1921}
#' \item{Years 1922 - 2001}{....}
#' \item{2002-10-31}{The modeled proportion flow for October 2002}
#' }
#'
#' @details This dataset is formated with years as columns and each row containing all observations
#' for one watershed.
#'
#'
#' \strong{Flow into Upper-mid Sacramento River:}
#' \itemize{
#'   \item Upper Sacramento River
#'   \item Antelope Creek
#'   \item Battle Creek
#'   \item Bear Creek
#'   \item Big Chico Creek
#'   \item Butte Creek
#'   \item Clear Creek
#'   \item Cottonwood Creek
#'   \item Cow Creek
#'   \item Deer Creek
#'   \item Elder Creek
#'   \item Mill Creek
#'   \item Paynes Creek
#'   \item Stony Creek
#'   \item Thomes Creek
#' }
#'
#' \strong{Flow into Feather River:}
#' \itemize{
#'   \item Bear River
#'   \item Yuba River
#' }
#'
#' \strong{Flow into Lower-mid Sacramento River:}
#' \itemize{
#'   \item Feather River
#' }
#'
#' \strong{Flow into Lower Sacramento River:}
#' \itemize{
#'   \item American River
#' }
#'
#' \strong{Flow into San Joaquin River:}
#' \itemize{
#'   \item Merced River
#'   \item Tuolumne River
#'   \item Stanislaus River
#' }
#'
#' The Mokulumne River, Calaveras River, and Cosumnes River are assigened 100\%.
#'
#' The CALSIM II run is a Reclamation product used to replicate current operations for comparison
#' with proposed adjustments under an ongoing Endangered Species Act consultation with the National Marine
#' Fisheries Service. A current NMFS Biological Opinion concluded that, as proposed, CVP and SWP operations
#' were likely to jeopardize the continued existence of four federally- listed anadromous fish species:
#' Sacramento River winter-run Chinook salmon, Central Valley spring-run Chinook salmon, California Central Valley
#' steelhead, and the Southern distinct population segment of the North American green sturgeon. This CALSIM II
#' run was used as the basis of comparison for other potential operations that could offset impacts to listed species.
#' More information on CALSIM II is available \href{http://baydeltaoffice.water.ca.gov/modeling/hydrology/CalSim/index.cfm}{here}
#'
#' \href{https://s3-us-west-2.amazonaws.com/cvpiaflow-r-package/BST_CALSIMII_schematic_040110.jpg}{CALSIM II schematic}
#'
#' @source
#' \itemize{
#'   \item \strong{Data Wrangling:} Sadie Gill  \email{sgill@@flowwest.com}
#'   \item \strong{Node Selection:} Mark Tompkins \email{mtompkins@@flowwest.com} and Mike Urkov \email{mike.urkov@@gmail.com}
#'   \item \strong{CALSIM Model Output:} Michael Wright \email{mwright@@usbr.gov}
#' }
#'
"return_flow"

#' The Flow from Lower Sacramento River into the Central/South Delta
#' @description A dataset containing the flow at Freeport Weir. To be used for routing fish from the Lower
#' Sacramento River into the Central/South delta in the SIT Salmon Lifecycle Model.
#'
#' @format dataframe with 996 rows and 3 variables:
#' \describe{
#' \item{date}{CALSIM II date}
#' \item{freeportQcfs}{C400 - flow in cubic feet per second}
#' \item{freeportQcms}{C400 - flow in cubic meters per second}
#' }
#'
#' @details The flow at Freeport Weir is represented using node CALSIM II 'FLOW-CHANNEL' C400 and the
#'
#' The CALSIM II run is a Reclamation product used to replicate current operations for comparison
#' with proposed adjustments under an ongoing Endangered Species Act consultation with the National Marine
#' Fisheries Service. A current NMFS Biological Opinion concluded that, as proposed, CVP and SWP operations
#' were likely to jeopardize the continued existence of four federally- listed anadromous fish species:
#' Sacramento River winter-run Chinook salmon, Central Valley spring-run Chinook salmon, California Central Valley
#' steelhead, and the Southern distinct population segment of the North American green sturgeon. This CALSIM II
#' run was used as the basis of comparison for other potential operations that could offset impacts to listed species.
#' More information on CALSIM II is available \href{http://baydeltaoffice.water.ca.gov/modeling/hydrology/CalSim/index.cfm}{here}
#'
#' \href{https://s3-us-west-2.amazonaws.com/cvpiaflow-r-package/BST_CALSIMII_schematic_040110.jpg}{CALSIM II schematic}
#'
#' @source
#' \itemize{
#'   \item \strong{Data Wrangling:} Sadie Gill  \email{sgill@@flowwest.com}
#'   \item \strong{Node Selection:} Mark Tompkins \email{mtompkins@@flowwest.com} and Mike Urkov \email{mike.urkov@@gmail.com}
#'   \item \strong{CALSIM Model Output:} Michael Wright \email{mwright@@usbr.gov}
#' }
#'
"freeportQ"

#' Delta Cross Channel Operations
#' @description The number of days the Delta Cross Channel gates are closed for each month
#' @format dataframe with 12 rows and 2 variables:
#' \describe{
#' \item{Month}{Integar representation of months}
#' \item{Days Closed}{the number of days the delta cross channel gates are typically closed}
#' }
#' @details By rule, 45 days between November-January, based on real time monitoring.
#' For modeling purposes, the days were divided evenly across the three months.
#'
#' Note: Some real-time changes possible based on:
#' \itemize{
#'  \item fish monitoring
#'  \item interior delta salinity
#'  \item flood operations
#' }
#'
#' In May, typically open for Memorial Day.
#'
#' @source \href{http://www.westcoast.fisheries.noaa.gov/central_valley/water_operations/ocap.html}{2009 NMFS BiOp Action IV.1 and D-1641}
#' Compiled by Mike Urkov \email{mike.urkov@@gmail.com}
#'
"delta_cross_channel_closed"
