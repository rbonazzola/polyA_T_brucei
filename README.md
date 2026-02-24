# Modelling poly-A tail degradation in _T. brucei_

## Loading and filtering the reads
```
source("preprocess.R")
dat1 <- readRDS("data/0506_tbrucei_R1.rds") |> filter_reads() |> filter_non_increasing()
dat2 <- readRDS("data/1107_tbrucei_R2.rds") |> filter_reads() |> filter_non_increasing()
```
