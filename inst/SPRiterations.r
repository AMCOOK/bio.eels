#parameter file to pull all results together
require(devtools)
load_all('~/git/bio.eels')


#bring in the base data into workspace (all bundled as p)

#	source('~/git/bio.eels/data/baseLH.r')


#reflects full selectivity after 35cm as per maritimes fishery not a big change
#	source('~/git/bio.eels/data/LH2knifeedge.r') 

	#reflects Cairns model but fully selected after length 35cm
	
	source('~/git/bio.eels/data/Cairnsknifeedge.r') 
	
	#to get distributions for LAA
	jj = list()
	for(i in 1:length(p$LAAl)) {
		j = findMoments(dist='lnorm',lo=p$LAAl[i],up=p$LAAu[i],l.perc=0.05, u.perc=0.95)
		p$LAA[i]  = j[[1]]
		p$LAAs[i] = sqrt(j[[2]])
		}
		



#central tendencies derived where explictA

aa = list()
for(i in 1:10000) aa[[i]] <- predLAA(p,rand=T)
aa = do.call(rbind,aa)
p$pLAA = colMeans(aa)


			p$pWAA   = predWAA(p,rand=T) #esimted from random lengths above
		

aa = list()
for(i in 1:1000) aa[[i]] <- predMAA(p)
aa = do.call(rbind,aa)
p$pMAA = colMeans(aa)


			p$pMatAA = predMatAA(p,rand=T) #rbeta
			p$ppR    = predPRA(p,rand=T) #rbeta
			p$pfecAA = predFec(p)
			p$pMSea  = predMSea(p,rand=T)


png(file.path(file=project.figuredirectory('bio.eels'),'LAA.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
plot(1:p$nAges,p$pLAA,type='b',xlab='Age',ylab='Length',lwd=2,pch=16,cex.axis=1.5,cex.lab=1.5)
dev.off()
	

png(file.path(file=project.figuredirectory('bio.eels'),'WAA.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
plot(1:p$nAges,p$pWAA,type='b',xlab='Age',ylab='Weight',lwd=2,pch=16,,cex.axis=1.5,cex.lab=1.5)
dev.off()

png(file.path(file=project.figuredirectory('bio.eels'),'MAA.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
plot(1:p$nAges,p$pMAA,type='b',xlab='Age',ylab='Mortality',lwd=2,pch=16,,cex.axis=1.5,cex.lab=1.5)
dev.off()


	png(file.path(file=project.figuredirectory('bio.eels'),'MatAA.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
	plot(1:p$nAges,p$pMatAA,type='b',xlab='Age',ylab='Maturity',lwd=2,pch=16,,cex.axis=1.5,cex.lab=1.5)
	dev.off()


png(file.path(file=project.figuredirectory('bio.eels'),'ppR.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
plot(1:p$nAges,p$ppR,type='b',xlab='Age',ylab='Vulnerability',lwd=2,pch=16,,cex.axis=1.5,cex.lab=1.5)
dev.off()



png(file.path(file=project.figuredirectory('bio.eels'),'FecAA.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
plot(1:p$nAges,p$pfecAA,type='b',xlab='Age',ylab='Fecundity',lwd=2,pch=16,,cex.axis=1.5,cex.lab=1.5)
dev.off()



######random

png(file.path(file=project.figuredirectory('bio.eels'),'randomLAA.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
plot(1:p$nAges,p$pLAA,type='b',xlab='Age',ylab='Length',lwd=2,pch=16,cex.axis=1.5,cex.lab=1.5)
for(i in 1:1000) lines(1:p$nAges, predLAA(p,rand=T))
dev.off()

png(file.path(file=project.figuredirectory('bio.eels'),'randomWAA.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
plot(1:p$nAges,p$pWAA,type='b',xlab='Age',ylab='Weight',lwd=2,pch=16,,cex.axis=1.5,cex.lab=1.5)
for(i in 1:1000) {p$pLAA = predLAA(p,rand=T); lines(1:p$nAges, predWAA(p,rand=T))}
dev.off()

png(file.path(file=project.figuredirectory('bio.eels'),'randomMAA.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
plot(1:p$nAges,p$pMAA,type='b',xlab='Age',ylab='Mortality',lwd=2,pch=16,,cex.axis=1.5,cex.lab=1.5)
for(i in 1:1000) lines(1:p$nAges, predMAA(p,rand=T))
dev.off()


aa = list()
for(i in 1:1000) aa[[i]] <- predMatAA(p,rand=T)
aa = do.call(rbind,aa)
a = colMeans(aa)
png(file.path(file=project.figuredirectory('bio.eels'),'randomMatAA.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
plot(1:p$nAges,a,type='b',xlab='Age',ylab='Maturity',lwd=2,pch=16,,cex.axis=1.5,cex.lab=1.5)
for(i in 1:1000) lines(1:p$nAges, predMatAA(p,rand=T))

dev.off()


png(file.path(file=project.figuredirectory('bio.eels'),'randomppR.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
plot(1:p$nAges,p$ppR,type='b',xlab='Age',ylab='Vulnerability',lwd=2,pch=16,,cex.axis=1.5,cex.lab=1.5)
#for(i in 1:1000) lines(1:p$nAges, predMatAA(p,rand=T))
dev.off()



png(file.path(file=project.figuredirectory('bio.eels'),'randomFecAA.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
plot(1:p$nAges,p$pfecAA,type='b',xlab='Age',ylab='Fecundity',lwd=2,pch=16,,cex.axis=1.5,cex.lab=1.5)
for(i in 1:1000) {p$pLAA = predLAA(p,rand=T); lines(1:p$nAges, predFec(p))}
dev.off()






# output with Fishing eels and elvers

	F = seq(0,0.4,by=0.001)
	Felv = seq(0,1.5,by=0.001)
	 
	V = S = Y = matrix(NA,nrow=length(F),ncol=length(Felv))
	
	for(i in 1:length(F)) {
		for(j in 1:length(Felv)) {
		a = eelEquilProduction(p,rand=FALSE,F=F[i],Felv = Felv[j])
		Y[i,j] = a$Catch
		S[i,j] = a$Eggs
		V[i,j] = a$Value
			}
		}
		S1 = S/S[1,1]
				png(file.path(file=project.figuredirectory('bio.eels'),'baseEelElverSPR.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
			contour.mat <- ifelse(S1 > .5, 0, 1)
			contour.mat2 <- ifelse(S1<0.3, 0, 1)
			
			#puts the 
			filled.contour(S1, color = colorRampPalette(c('red','blue')),xlab='F adult',ylab='F elver',
               plot.axes = { contour(contour.mat2, levels = 1, lwd=3,lty=1,
                                     drawlabels = FALSE, axes = FALSE, 
                                     frame.plot = FFALSE, add = TRUE);
               				contour(contour.mat, levels = 1, lwd=3,lty=2,
                                     drawlabels = FALSE, axes = FALSE, 
                                     frame.plot = FFALSE, add = TRUE);
               axis(side=1,at=c(.2,.4,.6,.8),labels=quantile(F,c(.2,.4,.6,.8)));
               axis(side=2,at=c(.2,.4,.6,.8),labels=quantile(Felv,c(.2,.4,.6,.8)))
			      } )
			title('% SPR')
		dev.off()


#simple fixed output
	Felv=seq(0,1.5,by=0.01)
	Y = c()
	S = c()

	for(i in 1:length(Felv)) {
		a = eelEquilProduction(p,rand=FALSE,Felv=Felv[i],F=0)
		Y[i] = a$Catch
		S[i] = a$Eggs
		}


a = 	 FSPR40(Felv,S/S[1],ref=0.3)
b =		 FSPR40(Felv,S/S[1],ref=0.5)

	png(file.path(file=project.figuredirectory('bio.eels'),'ElverppR.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
		plot(1:p$nAges,c(1,rep(0,(p$nAges-1))),type='b',xlab='Age',ylab='Vulnerability',lwd=2,pch=16,,cex.axis=1.5,cex.lab=1.5)
	dev.off()
	

		
	
	png(file.path(file=project.figuredirectory('bio.eels'),'baseElverSPR.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
		plot(Felv,S/S[1],xlab='F elver',ylab='%SPR',lwd=1.5,lty=1,pch=16,type='l',ylim=c(0,1))
		arrows(x0=a[1],y1=0,y0=a[2],,angle=45,length=0.05,col='red',lwd=1.5)
		arrows(x0=b[1],y1=0,y0=b[2],,angle=45,length=0.05,col='red',lwd=1.5)
		text(a[1]+0.1,0,paste('F30=',round(a[1],2)),cex=0.8)
		text(b[1]-0.1,0,paste('F50=',round(b[1],2)),cex=0.8)
	dev.off()
				

###F on larger sizes

	Fvec=seq(0,0.4,by=0.001)
	Y = c()
	S = c()

	for(i in 1:length(Fvec)) {
		a = eelEquilProduction(p,rand=FALSE,Felv=0,F=Fvec[i])
		Y[i] = a$Catch
		S[i] = a$Eggs
		}


a = 	 FSPR40(Fvec,S/S[1],ref=0.3)
b =		 FSPR40(Fvec,S/S[1],ref=0.5)

	png(file.path(file=project.figuredirectory('bio.eels'),'eelppR.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
		plot(1:p$nAges,p$ppR,type='b',xlab='Age',ylab='Vulnerability',lwd=2,pch=16,,cex.axis=1.5,cex.lab=1.5)
	dev.off()
	

		
	
	png(file.path(file=project.figuredirectory('bio.eels'),'baseEelSPR.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
		plot(Fvec,S/S[1],xlab='F eel',ylab='%SPR',lwd=1.5,lty=1,pch=16,type='l',ylim=c(0,1))
		arrows(x0=a[1],y1=0,y0=a[2],,angle=45,length=0.05,col='red',lwd=1.5)
		arrows(x0=b[1],y1=0,y0=b[2],,angle=45,length=0.05,col='red',lwd=1.5)
		text(a[1]+0.03,0,paste('F30=',round(a[1],3)),cex=0.8)
		text(b[1]-0.03,0,paste('F50=',round(b[1],3)),cex=0.8)
	dev.off()
				

####Turbine mortality

	TurM = seq(0,2,by=0.01)
	Y = c()
	S = c()

	for(i in 1:length(TurM)) {
		p$turM = TurM[i]
		a = eelEquilProduction(p,rand=FALSE,Felv=0,F=0)
		Y[i] = a$Catch
		S[i] = a$Eggs
		print(TurM[i])
		}


a = 	 FSPR40(TurM,S/S[1],ref=0.3)
b =		 FSPR40(TurM,S/S[1],ref=0.5)


		
	
	png(file.path(file=project.figuredirectory('bio.eels'),'baseEelTurbineM.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
		plot(TurM,S/S[1],xlab='Turbine Mortality',ylab='%SPR',lwd=1.5,lty=1,pch=16,type='l',ylim=c(0,1))
		arrows(x0=a[1],y1=0,y0=a[2],,angle=45,length=0.05,col='red',lwd=1.5)
		arrows(x0=b[1],y1=0,y0=b[2],,angle=45,length=0.05,col='red',lwd=1.5)
		text(a[1]+0.03,0,paste('TurM30=',round(a[1],3)),cex=0.8)
		text(b[1]-0.03,0,paste('TurM50=',round(b[1],3)),cex=0.8)
	dev.off()
				





# Incorporate randomness in variables

#Felver
	Felv=seq(0,1.5,by=0.01)
	aa = iterateEelEquilCalcs(p=p,niter=20000,plot=T,Felv=Felv,ref=0.3)
	
	png(file.path(file=project.figuredirectory('bio.eels'),'randomElverSPR30.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
	 hist(aa[,3],xlab='Fspr30',main='',xlim=c(0.7,1.4))
	abline(v=median(aa[,3]),col='red',lwd=2) # 1.203
	dev.off()
	
	ab = iterateEelEquilCalcs(p=p,niter=20000,plot=T,Felv=Felv,ref=0.5)

	png(file.path(file=project.figuredirectory('bio.eels'),'randomElverSPR50.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
	hist(ab[,3],xlab='Fspr50',main='',xlim=c(0.4,0.8))
	abline(v=median(ab[,3]),col='red',lwd=2)#median(ab[,3]) = 0.69
	dev.off()
	
#FpostElver
	Fvec=seq(0,0.5,by=0.01)
	aaF = iterateEelEquilCalcs(p=p,niter=20000,plot=T,F=Fvec,Felv=NULL,ref=0.3)

	png(file.path(file=project.figuredirectory('bio.eels'),'randomEelSPR30.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
	hist(aaF[,3],xlab='Fspr30',main='')
	dev.off()
	

	abF = iterateEelEquilCalcs(p=p,niter=20000,plot=T,F=Fvec,Felv=NULL,ref=0.5)
	png(file.path(file=project.figuredirectory('bio.eels'),'randomEelSPR50.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
	hist(abF[,3],xlab='Fspr50',main='')
	dev.off()


#####
#Comparing Growth Effects
load(file='~/git/bio.eels/data/CairnsknifeedgeMarGrowth.rdata')

aa = list()
for(i in 1:10000) aa[[i]] <- predLAA(p,rand=T)
aa = do.call(rbind,aa)
p$pLAA = colMeans(aa)
			p$pWAA   = predWAA(p,rand=T) #esimted from random lengths above
aa = list()
for(i in 1:1000) aa[[i]] <- predMAA(p)
aa = do.call(rbind,aa)
p$pMAA = colMeans(aa)
			p$pMatAA = predMatAA(p,rand=T) #rbeta
			p$ppR    = predPRA(p,rand=T) #rbeta
			p$pfecAA = predFec(p)
			p$pMSea  = predMSea(p,rand=T)

pR = p


source('~/git/bio.eels/data/Cairnsknifeedge.r') 
	
	#to get distributions for LAA
	for(i in 1:length(p$LAAl)) {
		j = findMoments(dist='lnorm',lo=p$LAAl[i],up=p$LAAu[i],l.perc=0.05, u.perc=0.95)
		p$LAA[i]  = j[[1]]
		p$LAAs[i] = sqrt(j[[2]])
		}
aa = list()
for(i in 1:10000) aa[[i]] <- predLAA(p,rand=T)
aa = do.call(rbind,aa)
p$pLAA = colMeans(aa)

			p$pWAA   = predWAA(p,rand=T) #esimted from random lengths above
		aa = list()
		for(i in 1:1000) aa[[i]] <- predMAA(p)
		aa = do.call(rbind,aa)
		p$pMAA = colMeans(aa)
			p$pMatAA = predMatAA(p,rand=T) #rbeta
			p$ppR    = predPRA(p,rand=T) #rbeta
			p$pfecAA = predFec(p)
			p$pMSea  = predMSea(p,rand=T)


	png(file.path(file=project.figuredirectory('bio.eels'),'GrowthComps.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
		plot(1:p$nAges,p$pLAA,xlab='Age',ylab='Length',ylim=c(0,100),type='l',lwd=2)
		lines(1:pR$nAges,pR$pLAA,xlab='Age',ylab='Length',ylim=c(0,100),type='l',lwd=2,col='red')
		legend('topleft',c('Chaput and Cairns 2011','combined with Maritimes'),lty=c(1,1),col=c('black','red'),bty='n',cex=0.8)
	dev.off()


## #### Growth and ELvers
	Felv=seq(0,1.5,by=0.01)
	YR = c()
	SR = c()

	for(i in 1:length(Felv)) {
		a = eelEquilProduction(pR,rand=F,Felv=Felv[i],F=0)
		Y[i] = a$Catch
		SR[i] = a$Eggs
		}


aR = 	 FSPR40(Felv,SR/SR[1],ref=0.3)
bR =		 FSPR40(Felv,SR/SR[1],ref=0.5)

	Y = c()
	S = c()

	for(i in 1:length(Felv)) {
		a = eelEquilProduction(p,rand=F,Felv=Felv[i],F=0)
		Y[i] = a$Catch
		S[i] = a$Eggs
		}


a = 	 FSPR40(Felv,S/S[1],ref=0.3)
b =		 FSPR40(Felv,S/S[1],ref=0.5)



	png(file.path(file=project.figuredirectory('bio.eels'),'LAAonElverSPR.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')

		plot(Felv, S/S[1],type='l', lwd=2, xlab='F elver',ylab='SPR%',ylim=c(0,1))
		lines(Felv, SR/SR[1],type='l', lwd=2, xlab='F elver',ylab='SPR%','red')
		arrows(x0=a[1],y1=0,y0=a[2],,angle=45,length=0.05,col='black',lwd=1.5)
		arrows(x0=b[1],y1=0,y0=b[2],,angle=45,length=0.05,col='black',lwd=1.5)
		arrows(x0=aR[1],y1=0,y0=aR[2],,angle=45,length=0.05,col='red',lwd=1.5)
		arrows(x0=bR[1],y1=0,y0=bR[2],,angle=45,length=0.05,col='red',lwd=1.5)
		title='Elver SPR'

	dev.off()


#####Growth on eels

Fvec=seq(0,.4,by=0.01)
	YR = c()
	SR = c()

	for(i in 1:length(Fvec)) {
		a = eelEquilProduction(pR,rand=F,Felv=0,F=Fvec[i])
		Y[i] = a$Catch
		SR[i] = a$Eggs
		}


aR = 	 FSPR40(Fvec,SR/SR[1],ref=0.3)
bR =		 FSPR40(Fvec,SR/SR[1],ref=0.5)

	Y = c()
	S = c()

	for(i in 1:length(Fvec)) {
		a = eelEquilProduction(p,rand=F,Felv=0,F=Fvec[i])
		Y[i] = a$Catch
		S[i] = a$Eggs
		}


a = 	 FSPR40(Fvec,S/S[1],ref=0.3)
b =		 FSPR40(Fvec,S/S[1],ref=0.5)



	png(file.path(file=project.figuredirectory('bio.eels'),'LAAonEelSPR.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')

		plot(Fvec, S/S[1],type='l', lwd=2, xlab='F adult',ylab='SPR%',ylim=c(0,1))
		lines(Fvec, SR/SR[1],type='l', lwd=2, xlab='F adult',ylab='SPR%','red')
		arrows(x0=a[1],y1=0,y0=a[2],,angle=45,length=0.05,col='black',lwd=1.5)
		arrows(x0=b[1],y1=0,y0=b[2],,angle=45,length=0.05,col='black',lwd=1.5)
		arrows(x0=aR[1],y1=0,y0=aR[2],,angle=45,length=0.05,col='red',lwd=1.5)
		arrows(x0=bR[1],y1=0,y0=bR[2],,angle=45,length=0.05,col='red',lwd=1.5)
		title='Adult SPR'

	dev.off()



####################################################################################
#####
#Comparing Mortality Effects

source('~/git/bio.eels/data/Cairnsknifeedge.r') 
	
	#to get distributions for LAA
	for(i in 1:length(p$LAAl)) {
		j = findMoments(dist='lnorm',lo=p$LAAl[i],up=p$LAAu[i],l.perc=0.05, u.perc=0.95)
		p$LAA[i]  = j[[1]]
		p$LAAs[i] = sqrt(j[[2]])
		}
aa = list()
for(i in 1:10000) aa[[i]] <- predLAA(p,rand=T)
aa = do.call(rbind,aa)
p$pLAA = colMeans(aa)

			p$pWAA   = predWAA(p,rand=T) #esimted from random lengths above
		aa = list()
		for(i in 1:1000) aa[[i]] <- predMAA(p)
		aa = do.call(rbind,aa)
		p$pMAA = colMeans(aa)
			p$pMatAA = predMatAA(p,rand=T) #rbeta
			p$ppR    = predPRA(p,rand=T) #rbeta
			p$pfecAA = predFec(p)
			p$pMSea  = predMSea(p,rand=T)

pR = p

pR$pMAA = c(pR$pMAA[1],pR$pMAA[2:length(pR$pMAA)]*3)
	png(file.path(file=project.figuredirectory('bio.eels'),'MortalityComps.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')
		plot(1:p$nAges,p$pMAA,xlab='Age',ylab='Mortality',ylim=c(0,1.1),type='l',lwd=2)
		lines(1:pR$nAges,pR$pMAA,xlab='Age',ylab='Mortality',ylim=c(0,1.1),type='l',lwd=2,col='red')
		legend('topleft',c('Chaput and Cairns 2011','Chaput and Cairns 2011 x2 >1'),lty=c(1,1),col=c('black','red'),bty='n',cex=0.8)
	dev.off()


## #### Mortality and ELvers
	Felv=seq(0,1.5,by=0.01)
	YR = c()
	SR = c()

	for(i in 1:length(Felv)) {
		a = eelEquilProduction(pR,rand=F,Felv=Felv[i],F=0)
		Y[i] = a$Catch
		SR[i] = a$Eggs
		}


aR = 	 FSPR40(Felv,SR/SR[1],ref=0.3)
bR =		 FSPR40(Felv,SR/SR[1],ref=0.5)

	Y = c()
	S = c()

	for(i in 1:length(Felv)) {
		a = eelEquilProduction(p,rand=F,Felv=Felv[i],F=0)
		Y[i] = a$Catch
		S[i] = a$Eggs
		}


a = 	 FSPR40(Felv,S/S[1],ref=0.3)
b =		 FSPR40(Felv,S/S[1],ref=0.5)



	png(file.path(file=project.figuredirectory('bio.eels'),'MAAonElverSPR.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')

		plot(Felv, S/S[1],type='l', lwd=2, xlab='F elver',ylab='SPR%',ylim=c(0,1))
		lines(Felv, SR/SR[1],type='l', lwd=2, xlab='F elver',ylab='SPR%',col='red')
		arrows(x0=a[1],y1=0,y0=a[2],,angle=45,length=0.05,col='black',lwd=1.5)
		arrows(x0=b[1],y1=0,y0=b[2],,angle=45,length=0.05,col='black',lwd=1.5)
		arrows(x0=aR[1],y1=0,y0=aR[2],,angle=45,length=0.05,col='red',lwd=1.5)
		arrows(x0=bR[1],y1=0,y0=bR[2],,angle=45,length=0.05,col='red',lwd=1.5)
		title='Elver SPR'

	dev.off()


#####Mortality on eels

Fvec=seq(0,.4,by=0.01)
	YR = c()
	SR = c()

	for(i in 1:length(Fvec)) {
		a = eelEquilProduction(pR,rand=F,Felv=0,F=Fvec[i])
		Y[i] = a$Catch
		SR[i] = a$Eggs
		}


aR = 	 FSPR40(Fvec,SR/SR[1],ref=0.3)
bR =		 FSPR40(Fvec,SR/SR[1],ref=0.5)

	Y = c()
	S = c()

	for(i in 1:length(Fvec)) {
		a = eelEquilProduction(p,rand=F,Felv=0,F=Fvec[i])
		Y[i] = a$Catch
		S[i] = a$Eggs
		}


a = 	 FSPR40(Fvec,S/S[1],ref=0.3)
b =		 FSPR40(Fvec,S/S[1],ref=0.5)



	png(file.path(file=project.figuredirectory('bio.eels'),'MAAonEelSPR.png'),units='in',width=15,height=12,pointsize=18, res=300,type='cairo')

		plot(Fvec, S/S[1],type='l', lwd=2, xlab='F adult',ylab='SPR%',ylim=c(0,1))
		lines(Fvec, SR/SR[1],type='l', lwd=2, xlab='F adult',ylab='SPR%',col='red')
		arrows(x0=a[1],y1=0,y0=a[2],,angle=45,length=0.05,col='black',lwd=1.5)
		arrows(x0=b[1],y1=0,y0=b[2],,angle=45,length=0.05,col='black',lwd=1.5)
		arrows(x0=aR[1],y1=0,y0=aR[2],,angle=45,length=0.05,col='red',lwd=1.5)
		arrows(x0=bR[1],y1=0,y0=bR[2],,angle=45,length=0.05,col='red',lwd=1.5)
		title='Adult SPR'

	dev.off()



