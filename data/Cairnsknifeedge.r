#base case from Chaput and Cairns with knife edge


p = list()

#fixed data
p$pWAA = c(0.2,18,106,159,212,265,317,370,423,475.9,528.5,580,633,685,737,790,842,894,946,998,1050,1101,1153,1205,1256,1308)
p$Ml  = c(0.593,0.069,0.031,0.026,0.022,0.02,0.019,0.017,0.016,0.015,0.015,0.014,0.014,0.013,0.013,0.012,0.012,0.012,0.011,0.011,0.011,0.01,0.01,0.01,0.01,0.01)
p$Mu  = c(1.46,0.171,0.076,0.063,0.055,0.05,0.046,0.043,0.04,0.038,0.036,0.035,0.033,0.032,0.031,0.03,0.029,0.028,0.028,0.027,0.026,0.026,0.025,0.025,0.024,0.024)
p$LAAl = c(6.2,8.9,13.4,20.1,22.7,24.3,25.4,26.5,29.3,40,29.1,63.5,51.2,48.8,55.1,60.5,61.6,56.3,61.4,58,56.2,63.4,55.1,59.5,58.7,63.2)
p$LAAu = c(10.7,22.5,29,33.1,34.8,48.4,54.1,62.3,67.6,66.1,74.4,88.6,78.3,76.8,86.7,81.4,83.8,80.1,81.9,81.9,75.6,109.8,91.3,80.5,73.2,72.8)
p$nAges = 26
p$LAA = c()
p$LAAs = c()
#carins et al 2006 wt length regression

p$wtreg = 'standard'
p$wt.La = 0.0007006
p$wt.Lb = 3.2332

#beta distiution parameters for maturity Probability
			p$nmat = c(49.9, 49.9, 49.9, 49.9, 49.9, 49.9, 49, 48, 47, 46,
			             45, 30, 28, 28, 28, 28, 28, 28, 28, 28,
			             28, 28, 28, 28, 28, 28, 28, 28, 28, 28,
			             28)
			p$ymat = c(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 1, 2, 3, 4,
			         5, 20, 22, 22, 22, 22, 22, 22, 22, 22,
			         22, 22, 22, 22, 22, 22, 22, 22, 22, 22,
			         22)


#beta distribution parameters for fishing mortality --- not sized based but aged based...should this be length based? or tied to the LAA? Also does not include elver fishin
			p$knife.edgePR=T
			p$size.knife.edge=35
		    
		    
#mortality in sargasso
			p$MSea =    0.1
			p$MSeaSigma = 0.01


# fecundity at length reg parameters from Tremblay 2009 Southern Gulf and Atl Seaboard
			p$fecA = 3673
			p$fecB = 1.761

# $ per kg at size
			p$value = c(1000,rep(2,p$nAges-1))
