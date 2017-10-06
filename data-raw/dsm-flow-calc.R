library(readr)

wilkins <- read_csv("data-raw/WilkinsSlough.csv", skip=1)

denoms <- rowSums(wilkins[, 4:ncol(wilkins)])

wilkins$denominator <- denoms

# basic logic to be implemented
apply(wilkins[, 4:ncol(wilkins)], 2, function(x) (x/denoms) * wilkins$WilkinsSlough)
