#' @export
equilPlots <- function(yield,ssb,Fvec,ref=0.4,plots=T,ypr=FALSE){
			Fmax 	<- findMax(Fvec,yield)
			F.1  	<- F0.1(Fvec,yield)
			F40 	<- FSPR40(Fvec,ssb/ssb[1],ref=ref)
			
			if(plots) {
			par(mar=c(4,5,2,5))
			
			#plot spr and ypr equilibrium analysis
				b=2
				if(ypr) {
				plot(Fvec,yield,type='l',lty=2,xlab='F', ylab='Yield per Recruit')
				lineF0.1(F.1)
				arrows(x0=F.1[1],x1=F.1[1],y0=F.1[2],y1=-.05,angle=45,length=0.05)
				text(F.1[1]*0.85,0,'F0.1')
				arrows(x0=Fmax[1],x1=Fmax[1],y0=Fmax[2],y1=-.05,angle=45,length=0.05)
				text(Fmax[1]*1.1,0,'Fmax')
				par(new=T)
				b=4
				}
				plot(Fvec,ssb/ssb[1],type='l',lty=1,xlab='F', yaxt='n',ylab='',col='red',ylim=c(0,1))
				axis(side=b,at=seq(0,1,length=5))
				mtext(side=b,'Spawner Potential Ratio',line=3,col='red')
				arrows(x0=F40[1],x1=F40[1],y0=F40[2],y1=0,angle=45,length=0.05,col='red')
				text(F40[1]*1.1,1.33,'F40',col='red')
				text(1.4,5.5,paste('F0.1=',round(F.1[1],3)),cex=0.7)
				text(1.4,5.3,paste('Fmax=',round(Fmax[1],3)),cex=0.7)
				text(1.4,5.1,paste('F40=',round(F40[1],3)),cex=0.7)
				}
			return(c(Fmax=as.numeric(Fmax[1]), F0.1=as.numeric(F.1[1]),Fspr = as.numeric(F40[1])))
			}