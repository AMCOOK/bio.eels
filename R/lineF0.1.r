lineF0.1 <- function(x){
	#from F0.1
	x1 = 0
	y1 = x[2]-x[1]*x[3]
	x2 = x[1]
	y2 = x[2]
	xx = data.frame(x=c(x1,x2),y=c(y1,y2))
	xp = data.frame(x=c(x2*0.5,x2*1.5))
	a  = lm(y~x,data=xx)
	f  = predict(a,newdata=xp)
	segments(x0=xp[1,1],x1=xp[2,1],y0=f[1],y1=f[2],col='green')
}