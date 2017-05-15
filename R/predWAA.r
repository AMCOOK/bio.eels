 predWAA <- function(p,rand=T) {
 	with(p,{
	 		pW <- c()
 	
 		for(i in 1:nAges) {
	    	#if(wtreg=='log')  pW[i] = exp(wt.La + log(pLAA[i]) * wt.Lb + 0.5*wt.Ls^2)
	    	if(wtreg=='standard') pW[i] = wt.La * pLAA[i] ^ wt.Lb 
	    	  		}
	
	     return(pW)
	
		 })
	}