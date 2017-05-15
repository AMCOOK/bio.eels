predMSea <- function(p,rand=T) {
		with(p,{

					if(rand)  pW = rnorm(1, MSea, MSeaSigma)
	    			if(!rand) pW = MSea
	    			if(pW<0.001) pW = 0.001
	    return(pW) 	
		})
		


}