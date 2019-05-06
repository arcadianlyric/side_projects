### CMS open payment dat analysis
# centers for medicare and medical services 
# download from here: 
# https://www.cms.gov/OpenPayments/Explore-the-Data/Dataset-Downloads.html

library(data.table)
library(tidyverse) 
library(ggplot2)
library(openintro)
library(choroplethr)
library(choroplethrMaps)
library(maps)
library(sqldf)

### read in data
dat <- fread("../data/OP_DTL_GNRL_PGYR2014_P06302015.csv")
# 10million rows, 5.8G
#
### by states 
# box plot
box.p= dat[-which(dat$Recipient_State %in% '0R'),]
boxplot(log(box.p$Total_Amount_of_Payment_USDollars) ~ box.p$Recipient_State, main="Total Amount of Payment", ylab="State", xlab="log Payment (USD)", outline=FALSE, horizontal=T, las=2, cex.lab=.8) 
dev.copy2pdf(file='boxplot-state-total-cost.pdf', height=10, width=5)
# mean and median cost 
state.dat <- ddply(dat, "Recipient_State", function(x) mean(x$Total_Amount_of_Payment_USDollars), .progress = "text")
state.dat.median <- ddply(dat, "Recipient_State", function(x) median(x$Total_Amount_of_Payment_USDollars), .progress = "text")
all_states <- map_data("state")
state.dat$region <- tolower(abbr2state(state.dat$Recipient_State))
state.dat.median$region <- tolower(abbr2state(state.dat.median$Recipient_State))
# mean barplot
ggplot() + 
    geom_polygon(dat=join(all_states, state.dat, by="region", type = "full"), aes(x=long, y=lat, group = group, fill=V1),colour="white") + 
    scale_fill_continuous(low = "white", high = "red", guide="colorbar")
dev.copy2pdf(file='map-state-mean-cost.pdf', height= 5, width=8)
# median barplot
ggplot() + 
    geom_polygon(dat=join(all_states, state.dat.median, by="region", type = "full"), aes(x=long, y=lat, group = group, fill=log(V1)),colour="white") + 
    scale_fill_continuous(low = "white", high = "red", guide="colorbar")
dev.copy2pdf(file='map-state-median-cost.pdf', height= 5, width=8)

### MN is a outlier
mn <- dat %>%
    subset(Recipient_State== 'MN') %>%
    select(Teaching_Hospital_ID, Teaching_Hospital_Name, Physician_Profile_ID, Recipient_State, Physician_Specialty, Total_Amount_of_Payment_USDollars, Date_of_Payment, Number_of_Payments_Included_in_Total_Amount, Form_of_Payment_or_Transfer_of_Value, Nature_of_Payment_or_Transfer_of_Value, Name_of_Associated_Covered_Drug_or_Biological1)

# national value
all <- dat %>%
    select(Teaching_Hospital_ID, Teaching_Hospital_Name, Physician_Profile_ID, Recipient_State, Physician_Specialty, Total_Amount_of_Payment_USDollars, Date_of_Payment, Number_of_Payments_Included_in_Total_Amount, Form_of_Payment_or_Transfer_of_Value, Nature_of_Payment_or_Transfer_of_Value, Name_of_Associated_Covered_Drug_or_Biological1)
# mn cost differs from national value
wilcox.test(all$Total_Amount_of_Payment_USDollars, mn$Total_Amount_of_Payment_USDollars)

### by Physician_Specialty
mn.cost= ddply(mn, "Physician_Specialty", function(x) sum(x$Total_Amount_of_Payment_USDollars), .progress = "text")
mn.cost[,2]=mn.cost[,2]/sum(mn.cost[,2])
# top 10 cost specialty
mn.cost10= mn.cost[order(mn.cost$V1, decreasing = T),][1:11,]
mn.cost10= mn.cost10[-which(mn.cost10$Physician_Specialty==''),]
# national value
all.cost= ddply(all, "Physician_Specialty", function(x) sum(x$Total_Amount_of_Payment_USDollars), .progress = "text")
all.cost[,2]=all.cost[,2]/sum(all.cost[,2])
# top 10 cost specialty
all.cost10= arrange(all.cost, desc(V1))[1:11,]
all.cost10= all.cost10[-which(all.cost10$Physician_Specialty==''),]
# merge
mn.all.cost= merge(mn.cost10, all.cost10,by='Physician_Specialty', all=T)
colnames(mn.all.cost)=c ('Physician_Specialty', 'MN','National-wide')
par(mar=c(5,20,4,2), xpd=T)
barplot(as.matrix(t(mn.all.cost[,2:3])), beside = T, horiz = T, col=c('mistyrose','lightblue'), names.arg = mn.all.cost[,1], las=2,  cex.names = 0.5, cex.axis= .5)
legend("bottom", legend=c("MN","National"), pch=c(16,16), col=c('mistyrose','lightblue'), title="Group", cex = .5, bty = 'n')
dev.copy2pdf(file='mn-national-Physician_Specialty.pdf')
# Allopathic & Osteopathic Physicians/ Orthopaedic Surgery/ Adult Reconstructive Orthopaedic Surgery cost the most
wilcox.test(all[which(all$Physician_Specialty=='Allopathic & Osteopathic Physicians/ Orthopaedic Surgery/ Adult Reconstructive Orthopaedic Surgery'),]$Total_Amount_of_Payment_USDollars, mn[which(mn$Physician_Specialty=='Allopathic & Osteopathic Physicians/ Orthopaedic Surgery/ Adult Reconstructive Orthopaedic Surgery'),]$Total_Amount_of_Payment_USDollars)
wilcox.test(all[which(all$Physician_Specialty=='Allopathic & Osteopathic Physicians/ Orthopaedic Surgery'),]$Total_Amount_of_Payment_USDollars, mn[which(mn$Physician_Specialty=='Allopathic & Osteopathic Physicians/ Orthopaedic Surgery'),]$Total_Amount_of_Payment_USDollars)

### by Physician, on Allopathic & Osteopathic Physicians/ Orthopaedic Surgery/ Adult Reconstructive Orthopaedic Surgery
mn.adultOth= mn[which(mn$Physician_Specialty=='Allopathic & Osteopathic Physicians/ Orthopaedic Surgery/ Adult Reconstructive Orthopaedic Surgery'),]
doc.adultOth= ddply(mn.adultOth, "Physician_Profile_ID", function(x) sum(x$Total_Amount_of_Payment_USDollars), .progress = "text")
colnames(doc.adultOth)=c('Physician_Profile_ID', 'Sum_Total_Amount_of_Payment_USDollars')
# bar plot
ggplot(dat=doc.adultOth, aes(x=Physician_Profile_ID, y=Sum_Total_Amount_of_Payment_USDollars)) +
    geom_bar(stat="identity", fill = "lightblue") +
    coord_flip()
dev.copy2pdf(file='mn-adultOth-docID.pdf', width=5, height=5)
