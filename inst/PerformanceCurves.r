#Eels
options(stringsAsFactors=F)
load_all('~/git/bio.eels')
dadir = file.path(project.datadirectory('bio.eels'),'data')
fidir = file.path(project.datadirectory('bio.eels'),'figures')

fis = read.csv(file.path(dadir,'ElverFishery_revised_for_adam.csv'))
ar = read.csv(file.path(dadir,'Framework_AreaTable_rgb_July_25.csv'))
ind = read.csv(file.path(dadir,'ERCindexandfisheryto2018.csv'))
#check naming
fG = unique(fis$GAZETTED_NAME)
aG = unique(ar$DRAINAGE_NAME)

h = merge(fis,ar,by.x=c('GAZETTED_NAME'),by.y = 'DRAINAGE_NAME') #lose 195 records where GAZETTED_NAME is NA

uH = unique(h$GAZETTED_NAME)
out = list()
m = 0
#Performance Curves
for(i in 1:length(uH)) {
		hp = subset(h,GAZETTED_NAME == uH[i])
		hY = unique(hp$YYYY)
		for(j in 1:length(hY)){
			m=m+1
			hpp = subset(hp,YYYY == hY[j])
			hpp = hpp[order(hpp$STANDARD_DAY),]
			hpp$Csum = cumsum(hpp$LOG_WEIGHT)
			hpp$sCsum = hpp$Csum / max(hpp$Csum)
			hpp$DOS = hpp$STANDARD_DAY - hpp$STANDARD_DAY[1] +1
			cTEff = cEff = NA
			if(all(!is.na(hpp$EFFORT_HOURS))) cEff = sum(hpp$EFFORT_HOURS)
			if(all(!is.na(hpp$EFFORT_TOTAL))) cTEff = sum(hpp$EFFORT_TOTAL)
			L25 = L50 = L75 = NA
			if(all(!is.na(hpp$Csum)) & length(hpp$Csum)>2 & sum(hpp$LOG_WEIGHT)>0) {
					L25 = findMed(hpp$DOS,hpp$sCsum,ref=0.25)[1]
					L50 = findMed(hpp$DOS,hpp$sCsum,ref=0.5)[1]
					L75 = findMed(hpp$DOS,hpp$sCsum,ref=0.75)[1]
				}
				if(is.na(hY[j])){
					m=m-1
					 next
					}
			out[[m]] = c(unique(hpp$LICENCE),uH[i],hY[j],max(hpp$Csum), length(unique(hpp$STANDARD_DAY)),L25, L50, L75,  cEff, cTEff,L50 + hpp$STANDARD_DAY[1])
		}
	}

oi = as.data.frame(do.call(rbind,out))
names(oi) = c('LICENCE','GAZETTED_NAME','YYYY','TLog_Land','NumberOfFishingDays','L25','L50','L75','CumulativeEffort','CumulativeTotalEffort','L50DoY')
oi = toNums(oi,c(1,3:10)
##MISSING LOTS OF DATA
oN = aggregate(YYYY~GAZETTED_NAME,data=oi,FUN=length)
with(subset(oi,GAZETTED_NAME == oN[116,1]),{
	plot(YYYY,TLog_Land);x11()
	plot(TLog_Land,L50);x11()
	plot(YYYY,TLog_Land/CumulativeTotalEffort);x11()	
})

oi$CPUE = oi$TLog_Land / oi$CumulativeEffort
oSS = merge(oi,ar,by.x=c('GAZETTED_NAME'),by.y = 'DRAINAGE_NAME') #lose 195 records where GAZETTED_NAME is NA)


#cape sable island--southern most tip 
y1 = 43.456781
x1 = -65.614128	
oSS$Dist = NA

require(fossil)
for(i in 1:nrow(oSS)) {
	oSS$Dist[i] = earth.dist(cbind(c(x1,oSS$LONG[i]), c(y1,oSS$LATT[i])))
}


oSr = subset(oSS,is.finite(CPUE))
with(subset(oSr,YYYY==2016),plot(LONG,L50DoY,cex=NumberOfFishingDays/max(NumberOfFishingDays)*4,pch=16))
with(subset(oSr,YYYY==2016),plot(Dist,L50DoY,cex=TLog_Land/max(TLog_Land)*4,pch=16))



#there is more Cumulative effort columns that cumulative total effort columns

a = lm(TLog_Land~log(DRAINAGE.AREA.KM2)+offset(CumulativeEffort),data=oSr,weights=NumberOfFishingDays+1,na.action=na.omit)


