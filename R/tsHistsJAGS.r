#' @export
#histograms on side for time series

tsHistsJAGS <- function(jags.model.object,xaxis,ylims=c(0,1000),truncate.probs = c(0.005, 0.995),ylab='Total Run Size Kg',xlab='Year') {
	
		x = jags.model.object
		M=list()
		L = 1:dim(x)[1]
		for(l in 1:length(L)){
			X = as.vector(x[L[l],,])
			X = truncate_distribution(X,truncate.probs[1], truncate.probs[2])
			Xm = ceiling(max(X)*10)/10
			Xl = floor(min(X)*10)/10
			Xmed = median(X)
			Xs = seq(Xl,Xm,length.out=100)
			g = hist(X,plot=F,breaks=Xs)
			M[[l]] = list(mids = g$mids, dens = g$density,med = Xmed)
		}

		plot(xaxis,1:length(xaxis),type='n',ylim=c(ylims),ylab=ylab,xlab=xlab)

		for(i in 1:length(xaxis)) {
			t = M[[i]]
			t$dens = t$dens / max(t$dens) * 0.48
			xs = c((t$dens+xaxis[i]),rev(xaxis[i]-t$dens))
			ys= c(t$mids,rev(t$mids))
			polygon(xs,ys,col='grey')
			points(xaxis[i],t$med,pch=16)
		}


}