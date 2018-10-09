#east river sheet harbour to east river chester in kg


  inda = read.csv(file.path(project.datadirectory('bio.eels'),'data','ERCindexandfisheryto2018.csv'))

with(inda,plot(Year,KgTot,xlim=c(1990,1999),pch=16,ylim=c(0,400)))
i = inda[,c('Year','TRS.SH','TRS','KgTot')]
 

	inda$lTRS.SH = log(inda$TRS.SH)
     mod = glm(log(KgTot)~lTRS.SH,data=inda,)
     mod.sig <- summary(mod)$dispersion
   	a = data.frame(lTRS.SH=log(inda$TRS.SH[1:10]))
     lines(inda$Year[1:10],exp(predict(mod,a) + mod.sig),col='black',type='b')
j = data.frame(Year=inda$Year[1:10],KgEstimated = exp(predict(mod,a) + mod.sig))
   
#load(file.path(dir.output, 'escapementModelCPUETY.rdata'))


load(file.path(dir.output, 'escapementModelCPUETYNO2002.rdata'))

yrs = 1996:2018
TKG = apply(y$TRS,1,median)
lines(yrs[-7],TKG,type='b',pch=6,lty=3)
l = data.frame(Year=yrs[-7],EscapementModelTRSw2002=TKG)   



legend('topleft',pch=c(16,1,6),lty=c(0,1,3),legend=c('ERC_Index','Estimated from ERSH','Estimated from Catch Rate Model'),bty='n',cex=0.75)

savePlot(file.path(file=project.figuredirectory('bio.eels'),'TRSIndex.png'),type='png')


data = merge(merge(i,j,all=T),l,all=T)
write.csv(data,file.path(project.datadirectory('bio.eels'),'TRSIndices.csv')