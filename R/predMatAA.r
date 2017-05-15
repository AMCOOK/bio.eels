 predMatAA <- function(p,rand=T) {
 	with(p,{
	 		pM <- c()
 	
 		for(i in 1:nAges) {
	    	if(rand)  pM[i] = rbeta(1,ymat[i],nmat[i])
	    	if(!rand) stop('Not implemented')
	     		}
	
	     return(pM)
	
		 })
	}