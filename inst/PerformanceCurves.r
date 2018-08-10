#Eels
options(stringsAsFactors=F)

dadir = file.path(project.datadirectory('bio.eels'),'data')
fidir = file.path(project.datadirectory('bio.eels'),'figures')

fis = read.csv(file.path(dadir,'ELVER_FISHERY_1996_TO_2017.csv'))
ar = read.csv(file.path(dadir,'Framework_AreaTable_rgb_July_25.csv'))

#check naming
fG = unique(fis$GAZETTED_NAME)
aG = unique(ar$DRAINAGE_NAME)

h = merge(fis,ar,by.x=c('GAZETTED_NAME'),by.y = 'DRAINAGE_NAME') #lose 195 records where GAZETTED_NAME is NA

uH = unique(h$GAZETTED_NAME)
out = list()
m = 0
for(i in 1:length(uH)) {
		hp = subset(h,GAZETTED_NAME == uH[i])
		hY = unique(hp$YYYY)
		for(j in 1:length(hy)){
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
			out[[m]] = c(uH[i],hY[j],max(hpp$Csum), length(unique(hpp$STANDARD_DAY)),L25, L50, L75,  cEff, cTEff)
		}
	}

oi = as.data.frame(do.call(rbind,out))
names(oi) = c('GAZETTED_NAME','YYYY','TLog_Land','NumberOfFishingDays','L25','L50','L75','CumulativeEffort','CumulativeTotalEffort')
oi = toNums(oi,2:9)
##MISSING LOTS OF DATA
oN = aggregate(YYYY~GAZETTED_NAME,data=oi,FUN=length)
with(subset(oi,GAZETTED_NAME == oN[31,1]),{
	plot(YYYY,TLog_Land);x11()
	plot(TLog_Land,L50);x11()
	plot(YYYY,TLog_Land/CumulativeTotalEffort);x11()
	
})