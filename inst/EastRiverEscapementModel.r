###
###
####Relationship between Landings and Escapement with full quota captublue or not
###
###  inda = read.csv(file.path(dadir,'ERCindexandfisheryto2018.csv'))
###  with(inda,plot(EscKG~ERC_CPUE,type='p',col=Quota+1,pch=16))
###     mod = glm(log(EscKG)~ERC_CPUE:I(Quota<1),data=inda,)
###     model.matrix(mod)
###
###     mod.sig <- summary(mod)$dispersion
###     
###
###    a = subset(inda,Quota==0)
###    b = subset(inda,Quota>0)
###
###    a = a[order(a$ERC_CPUE),]
###    b = b[order(b$ERC_CPUE),]
###
###     lines(a$ERC_CPUE,exp(predict(mod,a) + mod.sig),col='black')
###     lines(b$ERC_CPUE,exp(predict(mod,b) + mod.sig),col='blue')
###     legend('topleft',pch=c(16,16),lty=c(1,1),col=c('black','blue'),legend=c('Quota Not Caught','Quota Caught'),cex=0.8, bty='n')
###
###
###
###
###
####predict EscKg based on CPUE
###
###
### load_all('~/git/bio.eels')
###            require(rjags)
###              rjags::load.module("dic")
###              rjags::load.module("glm")
###  dadir = file.path(project.datadirectory('bio.eels'),'data')
###fidir = file.path(project.datadirectory('bio.eels'),'figures')
###
###    dir.output = file.path(project.datadirectory('bio.eels'))
###     inda = read.csv(file.path(dadir,'ERCindexandfisheryto2018.csv'))
###     inda = inda[7:nrow(inda),] 
###     inda$ERC_CPUE[which(is.na(inda$CPUETY))] <- 0     
###     inda$ERC_L[which(is.na(inda$ERC_L))] <- 0     
###     inda$Quota[which(is.na(inda$Quota))] <- 0     
###     iT  = nrow(inda)         
###     #sH  = log(inda$TRS.SH[!is.na(inda$TRS.SH)])
###     isH = length(sH)
###     lesK = log(inda$EscKG)
###     esK  = (inda$EscKG)
###     mL = mean(lesK)
###     sdL = sd(lesK,na.rm=T)
###     qU  = 1-inda$Quota #to make not reaching quota = 1
###     #L 	 = inda$ERC_CPUE
###     L   = inda$CPUETY
###     LL  = inda$ERC_L
###     Ar = 136.59
###  #   L[which(is.na(L))] <- 0
###
###
###  sb = list(iT = iT,isH = isH,  esK = esK, qU = qU, L = L,sdL=sdL,LL=LL, Ar=Ar)
###
#####CPUETY###############################################
####jags
###
###    n.adapt = 1000 # burn-in  .. 4000 is enough for the full model but in case ...
###    n.iter = 15000
###    n.chains = 3
###    n.thin = 25 # use of uniform distributions causes high autocorrelations ? 
###    n.iter.final = n.iter * n.thin
###    fnres = file.path( project.datadirectory("bio.eels"), paste( "escapementModel", 2018,"rdata", sep=".") )
####non ts
###   
###    m = jags.model( file=file.path("/home/adam/git/bio.eels/inst/jags",'conditionalEscapementModelNoSh.jags'), data=sb, n.chains=n.chains, n.adapt=n.adapt ) 
###    tomonitor <- c('beta0','beta1','beta2','sigma','lmu','sH','L','esK', 'mu', 'sig','TRS','U','URS')
###   tomonitor = intersect( variable.names (m), tomonitor )
###    coef(m)
###    dic.samples(m, n.iter=n.iter ) # pDIC
###    dir.output = file.path(project.datadirectory('bio.eels'),'jagsModels')
###    dir.create(dir.output,showWarnings=F,recursive=T)
###  
###    y = jags.samples(m, variable.names=tomonitor, n.iter=n.iter.final, thin=n.thin) # sample from posterior
###
###save(y, file=file.path(dir.output, 'escapementModelCPUETY.rdata'))
###load(file.path(dir.output, 'escapementModelCPUETY.rdata'))
###
### #prediction errors
### es = apply(y$mu,1,median)
###median((es-esK) / esK,na.rm=T) #23.8% median prediction error
###
###
### #Violin plots for Total Run size
###yrs=inda$Year
###tsHists(y$TRS,xaxis=yrs,ylims=c(0,1200),ylab='Total Run Size (kg)')
###points(inda$Year,inda$KgTot,pch=16,col='blue')
###savePlot(file.path(fidir,'TotalRunSizeModelCPUETY.png'),type='png')
###
####Violin plots for Exploitation Estimate
###tsHists(y$U,xaxis=yrs,ylims=c(0,1),truncate.probs=c(0.025,0.995),ylab='Exploitation')
###abline(h=0.69, col='blue',lwd=2)
###savePlot(file.path(fidir,'ExploitationModelCPUETY.png'),type='png')
###
####Violin plots for KgRun per unit
###tsHists(y$URS,xaxis=yrs,ylims=c(0,8),truncate.probs=c(0.005,0.995),ylab='Run Size per KM2 of Rive')
###savePlot(file.path(fidir,'KgPerUnitModelCPUETY.png'),type='png')
###
####Prior Posterior for parameters/home/adam/git/bio.lobster/R/TempModelPlot.R
###  par(mfrow=c(3,1),mar=c(2,5,0,5),omi=c(0.75,0,0.5,0),las=1)
###       	  prr=NULL
###          prr$class='normal'
###          prr$mean=0
###          prr$sd=1/sqrt(0.001)
###          pdat = as.vector(y$beta0[,,])
###          plot.freq.distribution.prior.posterior( prior=prr, posterior=pdat ,xlab='beta0',legendadd=T)
###  
###  		prr=NULL
###          prr$class='normal'
###          prr$mean=0
###          prr$sd=1/sqrt(0.001)
###          pdat = as.vector(y$beta1[,,])
###          plot.freq.distribution.prior.posterior( prior=prr, posterior=pdat ,xlab='beta1',legendadd=T)
###
###  		prr=NULL
###          prr$class='normal'
###          prr$mean=0
###          prr$sd=1/sqrt(0.001)
###          pdat = as.vector(y$beta2[,,])
###          plot.freq.distribution.prior.posterior( prior=prr, posterior=pdat ,xlab='beta2',legendadd=T)
###
###savePlot(file.path(fidir,'PriorPostsCPUETY.png'),type='png')
###
##############################################################################################
###     #inda$ERC_CPUE[which(is.na(inda$ERC_CPUE))] <- 0     
###     inda$ERC_CPUE[which(is.na(inda$CPUETY))] <- 0     
###     
###     inda$ERC_L[which(is.na(inda$ERC_L))] <- 0     
###   
###     inda$Quota[which(is.na(inda$Quota))] <- 0     
###     iT  = nrow(inda)         
###     #sH  = log(inda$TRS.SH[!is.na(inda$TRS.SH)])
###     isH = length(sH)
###     lesK = log(inda$EscKG+.1)
###     esK  = (inda$EscKG)
###     mL = mean(lesK)
###     sdL = sd(lesK,na.rm=T)
###     qU  = 1-inda$Quota #to make not reaching quota = 1
###     #L    = inda$ERC_CPUE
###     L   = inda$ERC_CPUE
###     LL  = inda$ERC_L
###     Ar = 136.59
###  #   L[which(is.na(L))] <- 0
###
###
###  sb = list(iT = iT,isH = isH,  esK = esK, qU = qU, L = L,sdL=sdL,LL=LL, Ar=Ar)
###
#####ERC_CPUE###############################################
####jags
###
###    n.adapt = 1000 # burn-in  .. 4000 is enough for the full model but in case ...
###    n.iter = 15000
###    n.chains = 3
###    n.thin = 25 # use of uniform distributions causes high autocorrelations ? 
###    n.iter.final = n.iter * n.thin
###    fnres = file.path( project.datadirectory("bio.eels"), paste( "escapementModel", 2018,"rdata", sep=".") )
####non ts
###   
###    m = jags.model( file=file.path("/home/adam/git/bio.eels/inst/jags",'conditionalEscapementModelNoSh.jags'), data=sb, n.chains=n.chains, n.adapt=n.adapt ) 
###    tomonitor <- c('beta0','beta1','beta2','sigma','lmu','sH','L','esK', 'mu', 'sig','TRS','U','URS')
###   tomonitor = intersect( variable.names (m), tomonitor )
###    coef(m)
###    dic.samples(m, n.iter=n.iter ) # pDIC
###    dir.output = file.path(project.datadirectory('bio.eels'),'jagsModels')
###    dir.create(dir.output,showWarnings=F,recursive=T)
###  
###    y = jags.samples(m, variable.names=tomonitor, n.iter=n.iter.final, thin=n.thin) # sample from posterior
###
###save(y, file=file.path(dir.output, 'escapementModelCPUEERC.rdata'))
###load(file.path(dir.output, 'escapementModelCPUEERC.rdata'))
###
### #prediction errors
### es = apply(y$mu,1,median)
###median((es-esK) / esK,na.rm=T) #24.0 median prediction error
###
###
###
###
###
###
### #Violin plots for Total Run size
###yrs=inda$Year
###tsHists(y$TRS,xaxis=yrs,ylims=c(0,1200),ylab='Total Run Size (kg)')
###points(inda$Year,inda$KgTot,pch=16,col='blue')
###savePlot(file.path(fidir,'TotalRunSizeModelCPUEERC.png'),type='png')
###
####Violin plots for Exploitation Estimate
###tsHists(y$U,xaxis=yrs,ylims=c(0,1),truncate.probs=c(0.025,0.995),ylab='Exploitation')
###abline(h=0.69, col='blue',lwd=2)
###savePlot(file.path(fidir,'ExploitationModelCPUEERC.png'),type='png')
###
####Violin plots for KgRun per unit
###tsHists(y$URS,xaxis=yrs,ylims=c(0,8),truncate.probs=c(0.005,0.995),ylab='Run Size per KM2 of Rive')
###savePlot(file.path(fidir,'KgPerUnitModelCPUEERC.png'),type='png')
###
####Prior Posterior for parameters/home/adam/git/bio.lobster/R/TempModelPlot.R
###  par(mfrow=c(3,1),mar=c(2,5,0,5),omi=c(0.75,0,0.5,0),las=1)
###          prr=NULL
###          prr$class='normal'
###          prr$mean=0
###          prr$sd=1/sqrt(0.001)
###          pdat = as.vector(y$beta0[,,])
###          plot.freq.distribution.prior.posterior( prior=prr, posterior=pdat ,xlab='beta0',legendadd=T)
###  
###      prr=NULL
###          prr$class='normal'
###          prr$mean=0
###          prr$sd=1/sqrt(0.001)
###          pdat = as.vector(y$beta1[,,])
###          plot.freq.distribution.prior.posterior( prior=prr, posterior=pdat ,xlab='beta1',legendadd=T)
###
###      prr=NULL
###          prr$class='normal'
###          prr$mean=0
###          prr$sd=1/sqrt(0.001)
###          pdat = as.vector(y$beta2[,,])
###          plot.freq.distribution.prior.posterior( prior=prr, posterior=pdat ,xlab='beta2',legendadd=T)
###
###savePlot(file.path(fidir,'PriorPostsCPUEERC.png'),type='png')
###
###
###
###################################################################
####CPUETY with 2002 data 
#####################
###
### load_all('~/git/bio.eels')
###            require(rjags)
###              rjags::load.module("dic")
###              rjags::load.module("glm")
###  dadir = file.path(project.datadirectory('bio.eels'),'data')
###fidir = file.path(project.datadirectory('bio.eels'),'figures')
###
###    dir.output = file.path(project.datadirectory('bio.eels'))
###     inda = read.csv(file.path(dadir,'ERCindexandfisheryto2018.csv'))
###     inda = inda[7:nrow(inda),] 
###     w = which(inda$Year==2002)
###     inda$KgTot[w] <- 536 #Not a highly confident number but better than model likely
###     inda$EscKG[w] = inda$KgTot[w] - inda$ERC_L[w]
###     inda$ERC_CPUE[which(is.na(inda$CPUETY))] <- 0     
###     inda$ERC_L[which(is.na(inda$ERC_L))] <- 0     
###     inda$Quota[which(is.na(inda$Quota))] <- 0     
###     iT  = nrow(inda)         
###     sH  = log(inda$TRS.SH[!is.na(inda$TRS.SH)])
###     isH = length(sH)
###     lesK = log(inda$EscKG)
###     esK  = (inda$EscKG)
###     mL = mean(lesK)
###     sdL = sd(lesK,na.rm=T)
###     qU  = 1-inda$Quota #to make not reaching quota = 1
###     #L    = inda$ERC_CPUE
###     L   = inda$CPUETY
###     LL  = inda$ERC_L
###     Ar = 136.59
###    L[which(is.na(L))] <- 0
###
###
###  sb = list(iT = iT,isH = isH,  esK = esK, qU = qU, L = L,sdL=sdL,LL=LL, Ar=Ar)
###    n.adapt = 1000 # burn-in  .. 4000 is enough for the full model but in case ...
###    n.iter = 15000
###    n.chains = 3
###    n.thin = 25 # use of uniform distributions causes high autocorrelations ? 
###    n.iter.final = n.iter * n.thin
###    fnres = file.path( project.datadirectory("bio.eels"), paste( "escapementModel", 2018,"rdata", sep=".") )
####non ts
###   
###    m = jags.model( file=file.path("/home/adam/git/bio.eels/inst/jags",'conditionalEscapementModelNoSh.jags'), data=sb, n.chains=n.chains, n.adapt=n.adapt ) 
###    tomonitor <- c('beta0','beta1','beta2','sigma','lmu','sH','L','esK', 'mu', 'sig','TRS','U','URS')
###   tomonitor = intersect( variable.names (m), tomonitor )
###    coef(m)
###    dic.samples(m, n.iter=n.iter ) # pDIC
###    dir.output = file.path(project.datadirectory('bio.eels'),'jagsModels')
###    dir.create(dir.output,showWarnings=F,recursive=T)
###  
###    y = jags.samples(m, variable.names=tomonitor, n.iter=n.iter.final, thin=n.thin) # sample from posterior
###
###save(y, file=file.path(dir.output, 'escapementModelCPUETYw2002.rdata'))
###load(file.path(dir.output, 'escapementModelCPUETYw2002.rdata'))
###
### #prediction errors
### es = apply(y$mu,1,median)
###median((es-esK) / esK,na.rm=T) #14.2% median prediction error
###
###
### #Violin plots for Total Run size
###yrs=inda$Year
###tsHistsJAGS(y$TRS,xaxis=yrs,ylims=c(0,1200),ylab='Total Run Size (kg)')
###points(inda$Year,inda$KgTot,pch=16,col='blue')
###savePlot(file.path(fidir,'TotalRunSizeModelCPUETYw2002.png'),type='png')
###
####Violin plots for Exploitation Estimate
###tsHistsJAGS(y$U,xaxis=yrs,ylims=c(0,1),truncate.probs=c(0.025,0.995),ylab='Exploitation')
###points(inda$Year,inda$ERC_L/inda$KgTot,pch=16,col='blue')
###abline(h=0.69, col='blue',lwd=2)
###savePlot(file.path(fidir,'ExploitationModelCPUETYw2002.png'),type='png')
###
####Violin plots for KgRun per unit
###tsHistsJAGS(y$URS,xaxis=yrs,ylims=c(0,8),truncate.probs=c(0.005,0.995),ylab='Run Size per KM2 of River')
###points(inda$Year,inda$KgTot/Ar,pch=16,col='blue')
###savePlot(file.path(fidir,'KgPerUnitModelCPUETYw2002.png'),type='png')
###
####Prior Posterior for parameters/home/adam/git/bio.lobster/R/TempModelPlot.R
###  par(mfrow=c(3,1),mar=c(2,5,0,5),omi=c(0.75,0,0.5,0),las=1)
###          prr=NULL
###          prr$class='normal'
###          prr$mean=0
###          prr$sd=1/sqrt(0.001)
###          pdat = as.vector(y$beta0[,,])
###          plot.freq.distribution.prior.posterior( prior=prr, posterior=pdat ,xlab='beta0',legendadd=T)
###  
###      prr=NULL
###          prr$class='normal'
###          prr$mean=0
###          prr$sd=1/sqrt(0.001)
###          pdat = as.vector(y$beta1[,,])
###          plot.freq.distribution.prior.posterior( prior=prr, posterior=pdat ,xlab='beta1',legendadd=T)
###
###      prr=NULL
###          prr$class='normal'
###          prr$mean=0
###          prr$sd=1/sqrt(0.001)
###          pdat = as.vector(y$beta2[,,])
###          plot.freq.distribution.prior.posterior( prior=prr, posterior=pdat ,xlab='beta2',legendadd=T)
###
###savePlot(file.path(fidir,'PriorPostsCPUETYw2002.png'),type='png')
###
########################################################
######## Catch and escapment with effort and quota
###
###
###################################################################
####CPUETY with 2002 data 
#####################
###
### load_all('~/git/bio.eels')
###            require(rjags)
###              rjags::load.module("dic")
###              rjags::load.module("glm")
###  dadir = file.path(project.datadirectory('bio.eels'),'data')
###fidir = file.path(project.datadirectory('bio.eels'),'figures')
###
###    dir.output = file.path(project.datadirectory('bio.eels'))
###     inda = read.csv(file.path(dadir,'ERCindexandfisheryto2018.csv'))
###     inda = inda[7:nrow(inda),] 
###     w = which(inda$Year==2002)
###     inda$KgTot[w] <- 536 #Not a highly confident number but better than model likely
###     inda$EscKG[w] = inda$KgTot[w] - inda$ERC_L[w]
###     inda$ERC_CPUE[which(is.na(inda$CPUETY))] <- 0     
###     inda$ERC_L[which(is.na(inda$ERC_L))] <- 0     
###     inda$Quota[which(is.na(inda$Quota))] <- 0     
###     iT  = nrow(inda)         
###     sH  = log(inda$TRS.SH[!is.na(inda$TRS.SH)])
###     isH = length(sH)
###     lesK = log(inda$EscKG)
###     esK  = (inda$EscKG)
###     mL = mean(lesK)
###     sdL = sd(lesK,na.rm=T)
###     qU  = 1-inda$Quota #to make not reaching quota = 1
###     #L    = inda$ERC_CPUE
###     L   = inda$TC
###     E   = inda$HoursTY
###     LL  = inda$ERC_L
###     Ar = 136.59
###    L[which(is.na(L))] <- 0
###    E[which(is.na(E))] <- 0
###    LL[which(is.na(LL))] <- 0
###
###  sb = list(iT = iT,isH = isH,  esK = esK, qU = qU, L = L,E = E, sdL=sdL,LL=LL, Ar=Ar)
###    n.adapt = 1000 # burn-in  .. 4000 is enough for the full model but in case ...
###    n.iter = 15000
###    n.chains = 3
###    n.thin = 25 # use of uniform distributions causes high autocorrelations ? 
###    n.iter.final = n.iter * n.thin
###    fnres = file.path( project.datadirectory("bio.eels"), paste( "escapementModel", 2018,"rdata", sep=".") )
####non ts
###   
###    m = jags.model( file=file.path("/home/adam/git/bio.eels/inst/jags",'conditionalEscapementModelNoShCandE.jags'), data=sb, n.chains=n.chains, n.adapt=n.adapt ) 
###    tomonitor <- c('beta0','beta1','beta2','beta3','beta4','sigma','lmu','sH','L','esK', 'mu', 'sig','TRS','U','URS')
###   tomonitor = intersect( variable.names (m), tomonitor )
###    coef(m)
###    dic.samples(m, n.iter=n.iter ) # pDIC
###    dir.output = file.path(project.datadirectory('bio.eels'),'jagsModels')
###    dir.create(dir.output,showWarnings=F,recursive=T)
###  
###    y = jags.samples(m, variable.names=tomonitor, n.iter=n.iter.final, thin=n.thin) # sample from posterior
###
###save(y, file=file.path(dir.output, 'escapementModelCandEYw2002.rdata'))
###load(file.path(dir.output, 'escapementModelCandEYw2002.rdata'))
###
### #prediction errors
### es = apply(y$mu,1,median)
###median((es-esK) / esK,na.rm=T) #14.2% median prediction error
###
###
### #Violin plots for Total Run size
###yrs=inda$Year
###tsHistsJAGS(y$TRS,xaxis=yrs,ylims=c(0,1200),ylab='Total Run Size (kg)')
###points(inda$Year,inda$KgTot,pch=16,col='blue')
###savePlot(file.path(fidir,'TotalRunSizeModelCPUETYw2002.png'),type='png')
###
####Violin plots for Exploitation Estimate
###tsHistsJAGS(y$U,xaxis=yrs,ylims=c(0,1),truncate.probs=c(0.025,0.995),ylab='Exploitation')
###points(inda$Year,inda$ERC_L/inda$KgTot,pch=16,col='blue')
###abline(h=0.69, col='blue',lwd=2)
###savePlot(file.path(fidir,'ExploitationModelCPUETYw2002.png'),type='png')
###
####Violin plots for KgRun per unit
###tsHistsJAGS(y$URS,xaxis=yrs,ylims=c(0,8),truncate.probs=c(0.005,0.995),ylab='Run Size per KM2 of River')
###points(inda$Year,inda$KgTot/Ar,pch=16,col='blue')
###savePlot(file.path(fidir,'KgPerUnitModelCPUETYw2002.png'),type='png')
###
####Prior Posterior for parameters/home/adam/git/bio.lobster/R/TempModelPlot.R
###  par(mfrow=c(3,1),mar=c(2,5,0,5),omi=c(0.75,0,0.5,0),las=1)
###          prr=NULL
###          prr$class='normal'
###          prr$mean=0
###          prr$sd=1/sqrt(0.001)
###          pdat = as.vector(y$beta0[,,])
###          plot.freq.distribution.prior.posterior( prior=prr, posterior=pdat ,xlab='beta0',legendadd=T)
###  
###      prr=NULL
###          prr$class='normal'
###          prr$mean=0
###          prr$sd=1/sqrt(0.001)
###          pdat = as.vector(y$beta1[,,])
###          plot.freq.distribution.prior.posterior( prior=prr, posterior=pdat ,xlab='beta1',legendadd=T)
###
###      prr=NULL
###          prr$class='normal'
###          prr$mean=0
###          prr$sd=1/sqrt(0.001)
###          pdat = as.vector(y$beta2[,,])
###          plot.freq.distribution.prior.posterior( prior=prr, posterior=pdat ,xlab='beta2',legendadd=T)
###
###savePlot(file.path(fidir,'PriorPostsCPUETYw2002.png'),type='png')
###
###
###

#####################
##final model for assessment
########################

################################################################
#CPUETY removing all 2002 data 
##################

 load_all('~/git/bio.eels')
            require(rjags)
              rjags::load.module("dic")
              rjags::load.module("glm")
  dadir = file.path(project.datadirectory('bio.eels'),'data')
fidir = file.path(project.datadirectory('bio.eels'),'figures')

    dir.output = file.path(project.datadirectory('bio.eels'))
     inda = read.csv(file.path(dadir,'ERCindexandfisheryto2018.csv'))
     inda = inda[7:nrow(inda),] 
     w = which(inda$Year==2002)
     inda = inda[-w,]
     inda$ERC_CPUE[which(is.na(inda$CPUETY))] <- 0     
     inda$ERC_L[which(is.na(inda$ERC_L))] <- 0     
     inda$Quota[which(is.na(inda$Quota))] <- 0     
     iT  = nrow(inda)         
     sH  = log(inda$TRS.SH[!is.na(inda$TRS.SH)])
     isH = length(sH)
     lesK = log(inda$EscKG)
     esK  = (inda$EscKG)
     mL = mean(lesK)
     sdL = sd(lesK,na.rm=T)
     qU  = 1-inda$Quota #to make not reaching quota = 1
     #L    = inda$ERC_CPUE
     L   = inda$CPUETY
     LL  = inda$ERC_L
     Ar = 136.59
    L[which(is.na(L))] <- 0


  sb = list(iT = iT,isH = isH,  esK = esK, qU = qU, L = L,sdL=sdL,LL=LL, Ar=Ar)
    n.adapt = 1000 # burn-in  .. 4000 is enough for the full model but in case ...
    n.iter = 15000
    n.chains = 3
    n.thin = 25 # use of uniform distributions causes high autocorrelations ? 
    n.iter.final = n.iter * n.thin
    fnres = file.path( project.datadirectory("bio.eels"), paste( "escapementModel", 2018,"rdata", sep=".") )
#non ts
   
    m = jags.model( file=file.path("/home/adam/git/bio.eels/inst/jags",'conditionalEscapementModelNoSh.jags'), data=sb, n.chains=n.chains, n.adapt=n.adapt ) 
    tomonitor <- c('beta0','beta1','beta2','sigma','lmu','sH','L','esK', 'mu', 'sig','TRS','U','URS')
   tomonitor = intersect( variable.names (m), tomonitor )
    coef(m)
    dic.samples(m, n.iter=n.iter ) # pDIC
    dir.output = file.path(project.datadirectory('bio.eels'),'jagsModels')
    dir.create(dir.output,showWarnings=F,recursive=T)
  
    y = jags.samples(m, variable.names=tomonitor, n.iter=n.iter.final, thin=n.thin) # sample from posterior

save(y, file=file.path(dir.output, 'escapementModelCPUETYNO2002.rdata'))
load(file.path(dir.output, 'escapementModelCPUETYNO2002.rdata'))

 #prediction errors
 es = apply(y$mu,1,median)
median(abs((es-esK)) / esK,na.rm=T) #30.5% median absolute prediction error


 #Violin plots for Total Run size
yrs=inda$Year
tsHistsJAGS(y$TRS,xaxis=yrs,ylims=c(0,1200),ylab='Total Run Size (kg)')
points(c(inda$Year),c(inda$KgTot),pch=16,col='blue') 
ii = data.frame(Year = c(inda$Year,2002),KgTot = c(inda$KgTot,536))
ii = ii[order(ii$Year),]

lines(ii$Year[which(!is.na(ii$KgTot))],predict(loess(ii$KgTot~ii$Year,span=0.8,na.exclude=T)),col='blue',lwd=2)
yy = apply(y$TRS,1,median)
lines(ii$Year[-7],predict(loess(yy~ii$Year[-7],span=0.8,na.exclude=T)),col='black',lwd=2)
savePlot(file.path(fidir,'TotalRunSizeModelCPUETYNO2002.png'),type='png')

#Violin plots for Exploitation Estimate
tsHistsJAGS(y$U,xaxis=yrs,ylims=c(0,1),truncate.probs=c(0.025,0.995),ylab='Exploitation')
points(c(inda$Year,2002),c(inda$ERC_L/inda$KgTot,227.13/536),pch=16,col='blue')
abline(h=0.69, col='blue',lwd=2)
savePlot(file.path(fidir,'ExploitationModelCPUETYNO2002.png'),type='png')

#Violin plots for KgRun per unit
tsHistsJAGS(y$URS,xaxis=yrs,ylims=c(0,8),truncate.probs=c(0.005,0.995),ylab='Run Size per KM2 of River')
points(c(inda$Year,2002),c(inda$KgTot/Ar,536/Ar),pch=16,col='blue')
savePlot(file.path(fidir,'KgPerUnitModelCPUETYNO2002.png'),type='png')

quantile(y$beta0[,,],probs=c(0.025,0.5,0.975))
    
#Prior Posterior for parameters/home/adam/git/bio.lobster/R/TempModelPlot.R
  par(mfrow=c(3,1),mar=c(2,5,0,5),omi=c(0.75,0,0.5,0),las=1)
          prr=NULL
          prr$class='normal'
          prr$mean=0
          prr$sd=1/sqrt(0.001)
          pdat = as.vector(y$beta0[,,])
          plot.freq.distribution.prior.posterior( prior=prr, posterior=pdat ,xlab='beta0',legendadd=T)
  
      prr=NULL
          prr$class='normal'
          prr$mean=0
          prr$sd=1/sqrt(0.001)
          pdat = as.vector(y$beta1[,,])
          plot.freq.distribution.prior.posterior( prior=prr, posterior=pdat ,xlab='beta1',legendadd=T)

      prr=NULL
          prr$class='normal'
          prr$mean=0
          prr$sd=1/sqrt(0.001)
          pdat = as.vector(y$beta2[,,])
          plot.freq.distribution.prior.posterior( prior=prr, posterior=pdat ,xlab='beta2',legendadd=T)

savePlot(file.path(fidir,'PriorPostsCPUETYNO2002.png'),type='png')
