iterateEelEquilCalcs <- function(p,niter,plot=T,F=NULL,Felv=NULL,ref=0.3) {
	
	out = list()
	F = if(is.null(F)) 0 else F;
	Felv = if(is.null(Felv)) 0 else Felv;
	
	
	for(j in 1:niter) {
		
		Y=c()
		S=c()
		#random variables
			p$pLAA   = predLAA(p,rand=T) #rnorm
			p$pWAA   = predWAA(p,rand=F) #esimted from random lengths above
			p$pMAA   = predMAA(p,rand=T) #runif
			p$pMatAA = predMatAA(p,rand=T) #rbeta
			p$ppR    = predPRA(p,rand=T) #rbeta
			p$pfecAA = predFec(p)
			p$pMSea  = predMSea(p,rand=T)
	
	if(any(F>0)) {
		for(i in 1:length(F)) {
		a = eelEquilProduction(p,rand=F,F=F[i])
		Y[i] = a$Catch
		S[i] = a$Eggs
		}

	out[[j]] <- equilPlots(yield=Y,ssb=S,Fvec=F,plot=F,ref=ref)
		}
	
	if(any(Felv>0)) {
		for(i in 1:length(Felv)) {
		a = eelEquilProduction(p,rand=F,F=0,Felv=Felv[i])
		Y[i] = a$Catch
		S[i] = a$Eggs
		}		
	out[[j]] <- equilPlots(yield=Y,ssb=S,Fvec=Felv,ref=ref,plots=F)
		}
	}

aout = do.call(rbind,out)

if(plot) {
	par(mfrow=c(3,1), mar = c(0, 3, 0, 1), omi = c(0.7, 0.3, 0.3, 0.3),las=1)

	hist(aout[,1],main='',ylab='Fmax','fd',xlim=c(0,.1),probability=T)
	abline(v=median(aout[,1]),col='red')
	legend('topright',lty=c(1),col=c('red'),paste('Median Fmax =',round(median(aout[,1]),3),sep=""),inset=c(0,0.2))
     

	hist(aout[,2],main='',ylab='F.1','fd',xlim=c(0,.1),probability=T)
	abline(v=median(aout[,2]),col='red',lwd=3)
	legend('topright',lty=c(1),col=c('red'),paste('Median F.1 =',round(median(aout[,2]),3),sep=""),inset=c(0,0.2))
    
	hist(aout[,3],main='',ylab='Fspr','fd',xlim=c(0,.1),probability=T)
	abline(v=median(aout[,3]),col='red',lwd=3)
	legend('topright',lty=c(1),col=c('red'),paste('Median Fspr =',round(median(aout[,3]),3),sep=""),inset=c(0,0.2))
	}

	return(aout)
}