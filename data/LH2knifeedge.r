#base case from Chaput and Cairns with knife edge

p = list()

#fixed data
			p$nAges = 31
			#Mean Length at age cm
			p$LAA <- c(8.297,13.271,25.307,35.616,39.69,45.75,49.048,51.537,52.175,53.533,52.799,59.051,64.703,68.142,70.619,69.089,67.884,68.217,71.543,68.272, 65.871,72.457,67.014,66.9,67.256,68.662,66.8,66.8,66.8,66.8,66.8)

			p$LAAs <- c(1.178,1.414,1.393,1.325,1.357,1.348,1.337,1.324,1.295,1.213,1.252,1.259,1.138,1.138,1.136,1.127,1.114,1.115,1.1,1.113,1.116,1.15,1.127,
			1.107,1.08,1.043,1.079,1.079,1.079,1.079,1.079)

			#log length weight regression parameters
					p$wtreg='log'
					p$wt.La  = -7.5609
					p$wt.Lb  =  3.2934
					p$wt.Ls  =  0.1632   # sigma error for the wt lgth regression, used to correct the mean when transforming from log

##Incredibly small range of M for random
			p$Ml = c(0.4103, 0.2014, 0.0757, 0.0451, 0.0383, 0.0309, 0.0278, 0.0258, 0.0253, 0.0243,
			           0.0249, 0.021, 0.0183, 0.0169, 0.016, 0.0165, 0.017, 0.0169, 0.0157, 0.0168,
			           0.0178, 0.0154, 0.0173, 0.0174, 0.0172, 0.0167, 0.0174, 0.0174, 0.0174, 0.0174,
			           0.0174)
			p$Mu = c(0.5653, 0.2775, 0.1044, 0.0622, 0.0528, 0.0426, 0.0383, 0.0355, 0.0349, 0.0335,
			           0.0342, 0.0289, 0.0252, 0.0233, 0.022, 0.0228, 0.0234, 0.0232, 0.0216, 0.0232,
			           0.0245, 0.0212, 0.0239, 0.0239, 0.0237, 0.023, 0.024, 0.024, 0.024, 0.024,
			           0.024)

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