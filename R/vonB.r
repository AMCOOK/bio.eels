#' @export
vonB <- function(l,a, plots=T,init.pars=list(hinf=100, K=0.3, t0=0),walford=T,fit.t0=F,conditional.bootstrap=T){


     if(walford) {
        x <- sort(unique(a))
	 	mh <- c(); mi<-c()
	 	for(j in 1:length(x)){mh[j] <- mean(l[a==x[j]],na.rm=T)}
	 	for(i in 2:(length(mh))) {mi[i]<-mh[i]-mh[i-1]}
	 	if(any(na.omit(mi<0))) {
	 		aa<-which(mi<0)
	 		for(k in 1:length(aa)) {
	 			if(aa[k]==length(mi)) {
	 					mh<-mh[-length(mh)]
	 					a<-a[-length(a)]
	 					}else{
	 		mh[aa[k]]<-mean(c(mh[aa[k]-1],mh[aa[k]+1]))
	 				}
	 			}
	 		}
	 	walford <- lm(mh[2:length(mh)]~mh[1:(length(mh)-1)])
	 	init.pars$hinf <- as.numeric(walford$coefficients[1]/(1-walford$coefficients[2]))
	 	init.pars$K <- as.numeric((walford$coefficients[2]))
	 	init.pars$t0 <- 0
		}
	  
	  if(fit.t0) {
				lvbf <- nls(l~hinf*(1-exp(-K*(a-t0))), start = init.pars)
				lvb.fit = summary(lvbf)
				parameters1<-as.data.frame(lvb.fit$parameters)

			} else {

				init.pars$t0 = NULL
				lvbf <- nls(l~hinf*(1-exp(-K*(a))), start = init.pars)
				lvb.fit = summary(lvbf)
				print(lvb.fit)
				parameters1<-as.data.frame(lvb.fit$parameters)
			
			}

		if(plots){
				plot(a,l,ylab='Fish Length',xlab='Age',col='black',pch='.',cex=3,xlim=c(0,40),ylim=c(0,100))
				A <- unique(a)
				A <- A[order(A)]
				if(fit.t0)	ht <- parameters1[1,1]*(1-exp(-parameters1[2,1]*(A-parameters1[3,1])))   
				if(!fit.t0)	ht <- parameters1[1,1]*(1-exp(-parameters1[2,1]*(A-0)))
				lines(A,ht,lwd=2,col='red')
			}


	if(conditional.bootstrap) {
			if(fit.t0) init.pars = list(hinf=parameters1[1,1],K=parameters1[2,1],t0 = parameters[3,1])
			if(!fit.t0) init.pars = list(hinf=parameters1[1,1],K=parameters1[2,1])
			
			bs.par = NULL
			pp = predict(lvbf)
			rr = residuals(lvbf)
			
			for(i in 1:1000) {
						A =  a
						L = pp + sample(rr,length(rr))
			
					if(fit.t0)  ai = try(nls(L~hinf*(1-exp(-K*(A-t0))),start = init.pars))
					if(!fit.t0) ai = try(nls(L~hinf*(1-exp(-K*(A))),start = init.pars))
	            
    		        bs.par <- rbind(bs.par,t(summary(ai)$parameters[,1]))
				}
			parameters = list(parameters1, bs.par)
		
		}


	return(parameters)
	}

	