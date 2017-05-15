
F0.1 <- function(x,y,fref=0.1,npts = 3){
	#B. Mohn
		np 		= length(x)
		s0 		=  coef(lm(y[1:npts] ~ x[1:npts] + I(x[1:npts]^2)))[2]
		dydx 	= (y[2:np] - y[1:np-1])/(x[2:np] - x[1:np-1])
		ix 		= which.min(abs(dydx - (fref*s0)))
		ixx 	= min(np-1,max(2,ix))
		tx 		= x[ixx + c(-1,0,1)]
		ty 		= y[ixx + c(-1,0,1)]
		cou 	= lm(ty ~ tx + I(tx^2))
		co      = coef(cou)
		xmax 	= ((s0 * fref) - co[2]) /(2 * co[3])
		ymax 	= co %*% (xmax^(0:2))
		return(c(F=xmax,Yield=ymax,slope=s0*fref,Ref=fref))
}


