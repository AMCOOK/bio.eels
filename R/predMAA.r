 predMAA <- function(p,rand=T) {
 	with(p,{
	 		pM <- c()
 	
 		for(i in 1:nAges) {
	    	if(rand)  pM[i] = runif(1,Ml[i],Mu[i])
	    	if(!rand) pM[i] = mean(c(Ml[i],Mu[i]))
	     		}
	
	     return(pM)
	
		 })
	}