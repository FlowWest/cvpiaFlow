-----
<img src="cvpia_logo.png" align="right" width="40%"/>

### Modeled Flow Data for the CVPIA SIT Model

*This data package contains modeled flow and diversion data for each of the watersheds within the CVPIA SIT Salmon Life Cycle Model.*

#### Installation

``` r
# install.packages("devtools")
devtools::install_github("FlowWest/cvpiaFlow")
```

#### Usage
This package provides flow related datasets to the [`cvpiaData`](https://flowwest.github.io/cvpiaData/) package.

``` r
# datasets within the package
data(package = 'cvpiaFlow')

# explore CALSIM II modeled flow mapped to CVPIA tributaries metadata
?cvpiaFlow::flows_cfs
```

#### About the Models
Output from two operational models are used to generate hydrologic inputs for the Salmon Population Model, Calite and CALSIM II. Both models replicate the operations of the Central Valley water system, with an emphasis on major reservoirs and diversions over a period of years. Calite is a simplified version of CALSIM, with fewer system nodes.   

The Callite run used for the Salmon Population Model is from the USBR Sacramento-San Joaquin Rivers Basin Study baseline run. Basin Studies are collaborative studies, cost-shared with non-Federal partners, to evaluate the impacts of climate change and help ensure sustainable water supplies by identifying strategies to address imbalances in water supply and demand. Other runs available in the Basin Study considered future operations under climate change. Calite would be the source of operational hydrology if climate change operations are considered by the SIT. 

The CALSIM II run is a Reclamation product used to replicate current operations for comparison with proposed adjustments under an ongoing Endangered Species Act consultation with the National Marine Fisheries Service. 

A current NMFS Biological Opinion concluded that, as proposed, CVP and SWP operations were likely to jeopardize the continued existence of four federally- listed anadromous fish species:   
  - Sacramento River winter-run Chinook salmon  
  - Central Valley spring-run Chinook salmon  
  - California Central Valley steelhead  
  - Southern distinct population segment of the North American green sturgeon   

This CALSIM II run was used as the basis of comparison for other potential operations that could offset impacts to listed species.

[More information on Calite](https://www.goldsim.com/Web/Applications/ExampleApplications/EnvironmentalExamples/CentralValley/) [More information on CALSIM II](http://baydeltaoffice.water.ca.gov/modeling/hydrology/CalSim/index.cfm)    
[CALSIM II Schematic](https://s3-us-west-2.amazonaws.com/cvpiaflow-r-package/BST_CALSIMII_schematic_040110.jpg)  
[More information on the Basin Studies](https://www.usbr.gov/watersmart/bsp/completed.html)  

<style>.logo{margin-top: 40px;}</style>
<div class = 'logo'>Data Assembled and Maintained by <a href = "http://www.flowwest.com/" target = "_blank"> <img src="TransLogoTreb.png" width="150px"/></div>
