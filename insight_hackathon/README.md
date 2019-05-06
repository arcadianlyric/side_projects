### Description

The project is about exploring CMS (Centers of Medicare & Medical Services) open payment data.
Aimed to see the difference of regional payments and the medicare types that cost most money.   
Data downloaded from https://www.cms.gov/OpenPayments/Explore-the-Data/Dataset-Downloads.html
 
The data is 5.68GB, with 10,818,055 rows and 63 columns (OP_DTL_GNRL_PGYR2014_P06302015.csv).
The OpenPaymentsDataDictionary file explained data types. 
The analysis was focused on Total Amount of Payment in USDollars, Recipient State of patients, Physician Specialty and Physician ID (names can be matched from the dictionary file but not included here due to privacy concerns).

Figure.1
The box plot shows log transformed Total Amount of Payment to the medicare recipients/ case as grouped by sates. MN, FM and VT seems to be outliers. Since there are limited cases in FM and VT, only MN is of interest. Wilcoxon test shows the difference between MN and national value is significant.
The map plots show mean and log transformed median values of Total Amount of Payment, confirmed MN as a outlier. 

Figure.2
To find out the reason for MN to be a outlier, I isolated cases from MN. At first I thought it is because of the MAYO clinic, which is the top one national wide and hence may deal with difficult and high-price cases. But I did not found significant difference between mayo and other clinics on average cost. 
Then I compared the top10 most costly case types by physician specialty as percentage contribution to all payments. In both MN and all states, orthopaedic surgery related cases ("Allopathic & Osteopathic Physicians/ Orthopaedic Surgery/ Adult Reconstructive Orthopaedic Surgery" and "Allopathic & Osteopathic Physicians/ Orthopaedic Surgery") are the most costly, which is not surprising, but more significant in MN as tested by Wilcoxon test.  
For "Allopathic & Osteopathic Physicians/ Orthopaedic Surgery/ Adult Reconstructive Orthopaedic Surgery", physician under the ID 192705 contributed most to the bill. 
