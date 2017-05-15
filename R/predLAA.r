 predLAA <- function(p,rand=T,lognormal=T) {
 	
 	with(p,{
	 			pW <- c()
 	
 				for(i in 1:nAges) {
	    			
	    			if(rand)  pW[i] = rnorm(1, LAA[i], LAAs[i])
	    			if(rand & lognormal)  pW[i] = (rlnorm(1, LAA[i], LAAs[i]))
	    			
	    			if(!rand) pW[i] = LAA[i]
	     			}

	     	if(exists('vonB',p)) {

	     		a=1

	     		  	}

		     	return(pW)
			 	})



 	}



	