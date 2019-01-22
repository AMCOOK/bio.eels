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

	com = aggregate(cbind(EFFORT_HOURS,LOG_WEIGHT)~GAZETTED_NAME+LICENCE+YYYY+DRAINAGE.AREA.KM2,data=h,FUN=sum)
ad = aggregate(DRAINAGE.AREA.KM2~YYYY,data=h,FUN=sum)
ad$TAC = ad$DRAINAGE.AREA.KM2*0.69


	comD = aggregate(cbind(EFFORT_HOURS,LOG_WEIGHT)~GAZETTED_NAME+YYYY+DRAINAGE.AREA.KM2,data=h,FUN=sum)

with(comD,plot(log(DRAINAGE.AREA.KM2),LOG_WEIGHT,pch=16,cex=EFFORT_HOURS/max(EFFORT_HOURS)*3,ylim=c(0,800), ylab='Catch Weight (kg)', xlab='Drainage Area (km2)',xaxt='n'))
	axis(side=1,at=c(2,3,4,5,6,7,8),labels=round(exp(c(2,3,4,5,6,7,8))))
	cc = comD[which(!is.na(comD$EFFORT_HOURS)),]
    cc = cc[order(cc$DRAINAGE.AREA.KM2),]
    cc$lDr = log(cc$DRAINAGE.AREA.KM2)
    mod = glm(log(LOG_WEIGHT+1)~lDr,data=cc,weights=cc$EFFORT_HOURS/max(cc$EFFORT_HOURS))
    model.matrix(mod)

    mod.sig <- summary(mod)$dispersion
	lmu <- predict(mod)
    sig = sqrt(exp(2*lmu+mod.sig)*(exp(mod.sig)-1))
    lines((cc$lDr),exp(predict(mod) + mod.sig),col='black',lwd=2)

	lines((cc$lDr),exp(predict(mod) + mod.sig)+sig,lty=2,lwd=2,col='black')
	lines((cc$lDr),exp(predict(mod) + mod.sig)-sig,lty=2,lwd=2,col='black')
 
 savePlot(file.path(fidir,'LandingsPerKm2.png'),type='png')       
