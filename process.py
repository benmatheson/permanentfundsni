import pandas as pd
import matplotlib.pyplot as plt


sniRaw = pd.read_csv("data/20190810 Stautory Net Income - Sheet1 types.csv")

###dividend Amounts
divHxRaw = pd.read_csv("data/20190810 Dividend History 2018.csv")

divHxRaw

##permanent fund history

pfHxRaw = pd.read_csv("data/20190810 Fund Value.csv")

##rename columns
divHx = divHxRaw.rename(columns={"Dividend Year": "divYear", "State Population": 'pop', "Applications\nReceived": "appsReceived", "Applications\nPaid": "appsPaid", "Dividend Amount":"divAmount", "Percent Change": "percentChange", "Total Disbursed Amount": "totalDisbursed" })


sni = sniRaw[['year', 'sni' ]]

##convert from millions to actual dollars. 
sni = sni.assign(sniAmount = sni["sni"]*1000000)

##calculate the rolling average and standard deviation

sniMean = sni["sniAmount"].rolling(window=5).mean()
sniStd = sni["sniAmount"].rolling(window=5).std()
sniSum = sni["sniAmount"].rolling(window=5).sum()


### add the rolling STD and average to the dataframe
sni['rollingSni'] = sniMean
sni['rollingSniSum'] = sniSum
sni['rollingStd'] = sniStd



####do a very rough estimated dividend disbursement amount

sni =sni.assign(divRough = sni.rollingSni/2)
sni = sni.assign(divRough1 = (sni["rollingSniSum"]*.21)/2)
sni.head()





pfHx = pfHxRaw.rename(columns={"Fiscal Year": "fiscalYear", "Total Principal": "principal", "Total Earnings Reserve": "er", "Total Fund Value": "fundValue"  })


pfHx = pfHx.assign(principal = pfHx.principal*1000000)
pfHx = pfHx.assign(er = pfHx.er*1000000)
pfHx = pfHx.assign(fundValue = pfHx.fundValue*1000000)

pfHx.head()

#

fundValueStd = pfHx["fundValue"].rolling(window=5).std()
pfHx["fundValueStd"] = fundValueStd

pfHx.head()

####join up 

pfdJoin = pd.merge(divHx, sni, left_on="divYear", right_on="year")
pfdJoin = pd.merge(pfdJoin,pfHx, left_on="divYear", right_on = 'fiscalYear' )

#####create pfdDisbursement to value things

pfd = pfdJoin.assign(pomv = pfdJoin.totalDisbursed/pfdJoin.fundValue )
pfd = pfd.assign(disburseDiff = pfd.totalDisbursed- pfd.divRough1)

###necessary to get the  plots right
pfd = pfd.sort_values("divYear")


###get the diference between fundvalue std and sni std
pfd = pfd.assign(valueSniStdDiff = pfd.fundValueStd - pfd.rollingStd)
pfd = pfd.assign(valueSniStdDiffRatio = pfd.fundValueStd/ pfd.rollingStd)


# fundValueStd Normalized by FundVale

pfd = pfd.assign(normalizedvalueStd  = pfd['rollingStd']/pfd["fundValue"])




pfd = pfd.assign(normalizedMean  = pfd['rollingSni']/pfd["fundValue"])


pfdSort = pfd
pfd.to_csv("data/pfd_8_12.csv")



pfdSort.plot(x= "divYear",  y='fundValueStd', kind="scatter")
pfdSort.plot(x="divYear", y="rollingStd", kind="scatter")
pfdSort.plot(x="divYear", y="valueSniStdDiffRatio", kind="scatter")
pfdSort.plot(x="divYear", y="valueSniStdDiff", kind="scatter")
pfdSort.plot(x="divYear", y="normalizedvalueStd", kind="scatter")
pfdSort.plot(x="divYear", y="normalizedMean", kind="scatter")

##plots

### std of earnings 
pfdSort.plot(x="divYear", y="rollingStd", kind="line", marker="o")

##normalized by value.
pfdSort.plot(x="divYear", y="normalizedvalueStd", kind="line", marker='o', color='r')

###pfdAmount x fund value
pfdSort.plot(x= "fundValue",  y='totalDisbursed', kind="scatter")

### pomv on line

pfdSort.plot(x= "divYear",  y='pomv', kind="bar")



###


plt.show()

pfd.tail()


pfdSort.plot(x="divYear", y="pomv")



plt.plot(data=pfdSort, x="divYear", y="fundValueStd")
plt.show()



pfdSort.plot(x="divYear", y="rollingSni")


plt.show()





pfd.head()
pfd["fundValue"]


pfd.tail()










joinTest.head()





sni.head()
divHx.head()




###
plt.plot(sni['sniAmount'])
plt.show()









sni.describe()
sni.dtypes



maxPomv = pfd['pomv'].max()

maxPomv

pomvSorted = pfd.sort_values("pomv")

pomvSorted