
library(tidyverse)
library(ggthemes)
library(ggrepel)

setwd("projects/sni/data")

getwd()


pfd <- read_csv("pfd_8_12.csv")
pfd <-  pfd %>% mutate (divYearShort = substr(divYear,3,4))


varBlue = "#1F618D"
b = 1000000000




ggplot(pfd)+
  geom_col(aes(x=divYear, y=sniAmount/b), fill=varBlue)+
  geom_col(data = pfd %>% filter(divYear ==2009), aes(x=divYear, y=sniAmount/b), fill="salmon")+
  ggtitle("The Agony and Ecstasy of Stautory Net Income")+
  ylab("Statutory Net Income ($billions)")+
xlab("")+
  scale_x_continuous(breaks=seq(1982,2018,2))+
  theme_hc()+
  theme(plot.margin = unit(c(1,1,1,1), "cm"))+
  theme(plot.title = element_text( face = "bold"))+
  ggsave(width= 8, height=6, dpi=200, units="in", "plots/barSni.png")


ggplot(pfd)+
  geom_col(aes(x=divYear, y=rollingSni/b), fill=varBlue)+
  ggtitle("Stautory Net Income 5-Year Rolling Average Smoothes Things")+
  ylab("Rolling Statutory Net Income ($billions)")+
  xlab("")+
  theme(plot.margin = unit(c(1,1,1,1), "cm"))+
  scale_x_continuous(breaks=seq(1982,2018,2))+
  theme_hc()+
  theme(plot.title = element_text( face = "bold"))+
  
  ggsave(width= 8, height=6, dpi=200, units="in", "plots/barSniRolling.png")







ggplot(pfd)+
  geom_col(aes(x=divYear, y=divAmount), fill=varBlue)+
  ggtitle("Dividends Grow (and shrink) Over the Years")+
  ylab("Dividend Size")+
  xlab("")+
  scale_x_continuous(breaks=seq(1982,2018,2))+
  theme_hc()+
  theme(plot.margin = unit(c(1,1,1,1), "cm"))+
  theme(plot.title = element_text( face = "bold"))+
  
  ggsave(width= 8, height=6, dpi=200, units="in", "plots/barDividend.png")




####STD SNI LINE






###########HISTOGEAM

# 
# ggplot(pfd %>% filter(divYear !=1982))+
#   geom_histogram(aes(pomv*100), bins=8)+
#   ggtitle("5-Year Standard Deviation")+
#   theme_hc()+
#   theme(plot.margin = unit(c(1,1,1,1), "cm"))+
#   theme(plot.title = element_text( face = "bold"))+
#   
#   ggsave(width= 5, height=5, dpi=200, units="in", "plots/histoPOMV.png")
# 
# 
# ####STD SNI LINE


ggplot(pfd)+
  geom_line(aes(x=divYear, y=rollingStd/1000000000), color=varBlue)+
  geom_point(aes(x=divYear, y=rollingStd/1000000000), color=varBlue)+
  ylab("5-Year SD (billions)")+
  xlab("")+
  ggtitle("Growing Volatility (Standard Deviation) of 5-Year Statutory Net Income")+
  
  scale_x_continuous(breaks=seq(1982,2018,2))+
  theme_hc()+
  theme(plot.margin = unit(c(1,1,1,1), "cm"))+
  theme(plot.title = element_text( face = "bold"))+
  
  ggsave(width= 8, height=6, dpi=200, units="in", "plots/lineDivYearRollingStd.png")

####STD SNI LINE NORMALIZED BY VALUE


ggplot(pfd)+
  geom_line(aes(x=divYear, y=normalizedvalueStd), color=varBlue)+
  geom_point(aes(x=divYear, y=normalizedvalueStd), color=varBlue)+
  scale_x_continuous(breaks=seq(1982,2018,2))+
  ggtitle("Growing Volatility (SD) of 5-Year Statutory Net Income Normalized")+
  
ylab("5-year SD normalized by fund value")+
  xlab("")+
  theme_hc()+
  theme(plot.margin = unit(c(1,1,1,1), "cm"))+
  theme(plot.title = element_text( face = "bold"))+
  
ggsave(width= 8, height=6, dpi=200, units="in", "plots/lineDivYearRollingStdNormalized.png")



####scatter for disbursed

ggplot(pfd)+
  # geom_point(aes(x=fundValue/b, y=totalDisbursed/b), fill="white", color="white" ,size=2)+
  geom_point(aes(x=fundValue/b, y=totalDisbursed/b), fill=varBlue,color=varBlue, size=2)+
  # geom_text(aes(x=fundValue/b, y=totalDisbursed/b, label=divYear), nudge_x = 1.6)+
  geom_text_repel(aes(x=fundValue/b, y=totalDisbursed/b, label=divYear), segment.size=.4, nudge_x = 1.6)+
  xlab("Fund Value ($ billions)")+
  ylab("Amount Spent on Dividends ($billions)")+
  ggtitle("Dividend Amount Grows With Fund Value (Or It Used To)")+
  scale_y_continuous(breaks=seq(0,7,.2))+
  scale_x_continuous(breaks=seq(0,65,5))+
  ylim(0,1.5)+
  theme_hc()+
  theme(plot.margin = unit(c(1,1,1,1), "cm"))+
  theme(plot.title = element_text( face = "bold"))+
  
  ggsave(width= 8, height=6, dpi=200, units="in", "plots/scatterFundValueTotalDisbursed.png")




#########


ggplot(pfd %>% filter(divYear !=1982))+
  # geom_point(aes(x=fundValue/b, y=totalDisbursed/b), fill="white", color="white" ,size=2)+
  geom_point(aes(x=divAmount, y=pomv*100), fill="black",color=varBlue, size=2)+
  # geom_text(aes(x=fundValue/b, y=totalDisbursed/b, label=divYear), nudge_x = 1.6)+
  geom_text_repel(aes(x=divAmount, y= pomv*100, label=divYear), segment.size=.4, nudge_x = 1.6)+
  xlab("Dividend Amount")+
  ylab("Dividend Draw as Percent of Fund Value")+
  ggtitle("Big Draws and Small Draws Depending on the Market (1982 not shown)")+
  # scale_y_continuous(breaks=seq(0,7,.2))+
  # scale_x_continuous(breaks=seq(0,65,5))+
  # ylim(0,1.5)+
  theme_hc()+
  theme(plot.margin = unit(c(1,1,1,1), "cm"))+
  theme(plot.title = element_text( face = "bold"))+
  
  ggsave(width= 8, height=6, dpi=200, units="in", "plots/scatterDivSizeByPOMVN.png")










#########Line for POMV Disbursed

ggplot(pfd)+
  geom_line(aes(x=divYear, y=pomv*100), color= varBlue)+
  geom_point(aes(x=divYear, y=pomv*100), color = varBlue)+
  xlim(1982, 2018)+
  scale_x_continuous(breaks=seq(1982,2018,2))+
  ylab("Percent of Fund Value")+
  xlab("Year")+
  ggtitle("How Big Was the Draw? Dividend as Percent of Fund Value")+
  scale_y_continuous(breaks=seq(0,5,.5))+
  theme(plot.margin = unit(c(1,1,1,1), "cm"))+
  ylim(0,15)+
  theme_hc()+
  theme(plot.title = element_text( face = "bold"))+
  
  ggsave(width= 8, height=6, dpi=200, units="in", "plots/linePomv.png")



ggplot(pfd %>% filter(divYear != 1982))+
  geom_line(aes(x=divYear, y=pomv*100), color= varBlue)+
  geom_point(aes(x=divYear, y=pomv*100), color = varBlue)+
  xlim(1982, 2018)+
  scale_x_continuous(breaks=seq(1982,2018,2))+
  scale_y_continuous(breaks=seq(0,5,.5))+
  ylim(0,5)+
  ylab("Percent of Fund Value")+
  xlab("Year")+
  ggtitle("How Big Was the Draw?: Dividend as Percent of Fund Value ('83-'18)")+

  theme_hc()+
  theme(plot.margin = unit(c(1,1,1,1), "cm"))+
  theme(plot.title = element_text( face = "bold"))+
  
  ggsave(width= 8, height=6, dpi=200, units="in", "plots/linePomvNo1982.png")




pomvMedian <- median(pfd$pomv)





