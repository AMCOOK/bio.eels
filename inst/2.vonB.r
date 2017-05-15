# 2. vonB's

require(devtools)
load_all('~/git/bio.eels')
options(stringsAsFactors=FALSE)


a = read.csv(file.path(project.datadirectory('bio.eels'),'data','ageInfo.csv'))

uR = c('Medway','Eel','LaHave')
oo = list()
for(i in 1:length(uR)) {
	print(uR[i])	
	u = subset(a,system==uR[i],select=c('age','length','phase','sex'))
	u = na.omit(u)

	
#did not fit t0 as we have such limited information for growth around the origin
	X11()
	oo[[i]] = vonB(a=u$age,l=u$length,walford=FALSE,plots=T,fit.t0=FALSE,conditional.bootstrap=T,init.pars = list(hinf = 80, K=0.125))[[2]]

}


#using raw lengths
ii = unique(a$age)
oo = list()
for(i in 1:length(ii)){
	oo[[i]] = with(subset(a,age==ii[i]),{c(ii[i],mean(log(length)), sd(log(length)),length(length))})
}
o = as.data.frame(do.call(rbind,oo))
names(o) = c('age','LAA','LAAs')

o = o[order(o$age),]


source('~/git/bio.eels/data/Cairnsknifeedge.r') 
for(i in 1:length(p$LAAl)) {
			j = findMoments(dist='lnorm',lo=p$LAAl[i],up=p$LAAu[i],l.perc=0.05, u.perc=0.95)
			p$LAA[i]  = j[[1]]
			p$LAAs[i] = sqrt(j[[2]])
		}
k = data.frame(age=1:p$nAges,LAA=p$LAA,LAAs=p$LAAs)

kk = merge(k,o,by='age',all=T)


p$LAA = c(kk$LAA.x[1:9],kk$LAA.y[10:26])
p$LAAs = c(kk$LAAs.x[1:9],kk$LAAs.y[10:26])

save(p,file='~/git/bio.eels/data/CairnsknifeedgeMarGrowth.rdata')