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

	comD = aggregate(cbind(EFFORT_HOURS,LOG_WEIGHT)~GAZETTED_NAME+YYYY+DRAINAGE.AREA.KM2,data=h,FUN=sum)
		 inda = read.csv(file.path(dadir,'ERCindexandfisheryto2018.csv'))
		 inda = inda[7:nrow(inda),] 
		 w = which(inda$Year==2002)
		 inda$KgTot[w] <- 536 #Not a highly confident number but better than model likely
		 inda$EscKG[w] = inda$KgTot[w] - inda$ERC_L[w]
		 inda$URS = inda$KgTot / 136.59
	
u30R = median(inda$URS,na.rm=T)*0.69
u50R= median(inda$URS,na.rm=T)*0.49

u30BS = 2.55*0.69
u50BS = 2.55*0.49

km2 = 0:1000



plot((km2),u30R*km2,col='black',lwd=2,lty=1,type='l',xlab='Habtitat Area Km2',ylab='Habitat Based TAC or Landings')
#lines(km2,u30R*km2,col='blue',lwd=2,lty=4,type='l',xlab='Habtitat Area Km2',ylab='Habitat Based TAC')
#lines((km2),u50*km2,col='black',lwd=2,lty=1,type='l',xlab='Habtitat Area Km2',ylab='Habitat Based TAC')
lines((km2),u50R*km2,col='black',lwd=2,lty=2,type='l',xlab='Habtitat Area Km2',ylab='Habitat Based TAC')
abline(h=400,lwd=2,lty=3)
legend('topleft',c('TAC SPR50 Raw','TAC SPR30 Raw','Constant TAC'),lty=c(1,1,4,4,3),col=c('black','black','black'),bty='n',cex=0.75)
with(comD,points((DRAINAGE.AREA.KM2),LOG_WEIGHT,pch=16,cex=EFFORT_HOURS/max(EFFORT_HOURS)*3))
savePlot(file.path(project.figuredirectory('bio.eels'),paste('HabitatTACbySPRRawModelledwithData.png',sep="")),type='png')

