 predPRA <- function(p,rand=T) {
 	with(p,{
	 		pM <- c()
 	
 		if(any(c(!exists('knife.edgePR',p), (exists('knife.edgePR',p) & p$knife.edgePR==FALSE)))) { 		
 			for(i in 1:nAges) {
 				
	    			if(rand)  pM[i] = rbeta(1,ypR[i],npR[i])
	    			if(!rand) stop('Not implemented')
	    		
	    	}
	    }
	    
	    if(any(c(exists('knife.edgePR',p) , p$knife.edgePR))) {
	    		if(!exists('pLAA',p)) stop('Need predicted Length at Age knife edge only works for Length')
	    		i = which.min(pLAA<size.knife.edge)
	    		pM[1:i] <- 0
	    		pM[(i):nAges] <- 1
	    	}
	    
	
	     return(pM)
	
		 })
	}