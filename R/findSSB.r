findSSB <- function(x,spr,fvec,dat,ypr) {
	#x is nonparametric stock recruitment relationship
	#spr is equilibrium spawner per recruit analysis
	#dat is the SR data
	#From Cook 1998
		sp  <- data.frame(spr=spr,fvec=fvec)
		yp <- data.frame(ypr=ypr,fvec=fvec)
		n   <- nrow(sp)
		#s   <- data.frame(SSB=with(dat,seq(min(SSB), max(SSB*1),length.out=100)))
		#r   <- exp(predict(x,newdata=s))
		r   <- exp(predict(x))
		sor <- dat$SSB/r
		oo  <- c()
		for(i in 1:length(sor)) {
			ix <- which.min(abs(sor[i]-spr))
			if(ix>2 | ix<n-1) da = sp[ix+c(-1,0,1),]
			if(ix<=2 ) da = sp[1:3,]
			if(ix>=n-1 ) da = sp[n-2:n,]
			op <- lm(fvec~spr+I(spr^2),data=da)
			oo[i] <- predict(op,newdata=data.frame(spr=sor[i]))
		}
		oj <- c()
		for(j in 1:length(oo)) {
				ix <- which.min(abs(fvec-oo[i]))
				if(ix>2 | ix<n-1) da = yp[ix+c(-1,0,1),]
				if(ix<=2 ) da = yp[1:3,]
				if(ix>=n-1 ) da = yp[n-2:n,]
			op 		<- lm(ypr~fvec+I(fvec^2),data=da)
			oo[i] 	<- predict(op,newdata=data.frame(spr=sor[i]))		
						


		}
		data.frame(ssb=dat$SSB,r=r,F=oo)





}