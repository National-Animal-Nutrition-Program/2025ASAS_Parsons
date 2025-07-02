# Create a package containing the data required for the example models
# Libraries ----
library(readxl)
library(data.table)
library(tidyverse)

# Load the data
excel_sheets(path = '../../../Documents/AS791_FundQuantThink/Data/LAN/LAN_1504_DATA.xlsx')
d.dmi = read_excel(path = '../../../Documents/AS791_FundQuantThink/Data/LAN/LAN_1504_DATA.xlsx',
                   sheet = "ADJ_70Day_Intake",
                   range = "A1:I5244") %>%
  as.data.table()
d.dmi
summary(d.dmi)

d.lan = read_excel(path = '../../../Documents/AS791_FundQuantThink/Data/LAN/LAN_1504_DATA.xlsx',
                   sheet = "LAN_1504",
                   range = c('B1:BH78')) %>%
  as.data.table()
names(d.lan)
d.lan = d.lan[,  c('VID','Pen','CreepTrt','WeanTrt','D_42_BW','Creep_Gain','Shipping_Loss','Day56_InitialBW','Day56_ADG','Day56_MMBW','Day56_DMI','Day56_Residual','D_1_EV','AVE_TTB','BVFREQ','BVDUR','BVFREQsd','BVDURsd')]
names(d.lan)
summary(d.lan)

# summarise data -----
names(d.dmi)
d.dmis = d.dmi[, list(uDMI = mean(Adj_Intake),
                      sdDMI = sd(Adj_Intake)),
               by = VID]
d.dmis[, cvDMI := sdDMI/uDMI]
d.dmis

d.dmis = d.dmis[VID %in% d.lan$VID,]

# Merge data
d.lan = merge.data.table(d.lan, d.dmis)
fwrite(d.lan, file = 'Data/LAN_heifer.csv')
