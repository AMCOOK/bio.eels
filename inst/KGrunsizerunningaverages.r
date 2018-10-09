#KG run size running averages

load_all('~/git/bio.eels')
fidir = project.figuredirectory('bio.eels')
da = read.csv(file.path(project.datadirectory('bio.eels'),'TRSIndicesRuns.csv'))

plot(1990:2018,1:nrow(da),ylim=c(0,7),type='n',xlab='Year',ylab='Total Run Size per km2')

with(da,{
		points(Year,KgTot,pch=1)
		points(Year,KgEstimated,pch=2)
		points(Year,EscapementModel,pch=3)
		arrows(x0=KgTMaxX,x1=KgTMinX,y0=KgTot5,lty=2,length=0,col='blue',lwd=2.5)
		arrows(x0=KgEMaxX,x1=KgEMinX,y0=KgEstimated5,lty=3,length=0,col='blue',lwd=2.5)
		arrows(x0=EscMinX,x1=EscMaxX,y0=EscapementModel5,lty=4,length=0,col='blue',lwd=2.5)
		abline(h=median(KgTot,na.rm=T),col='red',lty=1,lwd=2)
		
		})

savePlot(file.path(fidir,'KgPerUnitRunningMeanArrows.png'),type='png')


plot(1990:2018,1:nrow(da),ylim=c(0,7),type='n',xlab='Year',ylab='Total Run Size per km2')

with(da,{
		points(Year,KgTot,pch=1,col='blue')
		points(Year,KgEstimated,pch=2,col='blue')
		points(Year,EscapementModel,pch=3,col='blue')
		lines(Year,KgTot5,lty=2,col='blue',lwd=2.5)
		lines(Year,KgEstimated5,lty=3,col='blue',lwd=2.5)
		lines(Year,EscapementModel5,lty=4,col='blue',lwd=2.5)
		abline(h=median(KgTot,na.rm=T),col='red',lty=1,lwd=2)
		abline(h=1.09,col='red',lty=2,lwd=2)
		abline(h=4.58,col='red',lty=2,lwd=2)	
		})
legend('topleft',legend=c('Raw Data','Estimated ERSH','EscapementModel','Long Term Median','95% CI of Long Term'),pch=c(1,2,3,NA,NA),lty=c(2,3,4,1,2),cex=0.8,lwd=2,bty='n',col=c('blue','blue','blue','red','red'))
savePlot(file.path(fidir,'KgPerUnitRunningMeanswCI.png'),type='png')
