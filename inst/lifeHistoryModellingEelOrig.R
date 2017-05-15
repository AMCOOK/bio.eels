
# life history age based model for American Eel with example for maximum age of 10 years
# Load packages and functions
library(lattice)
library(mgcv)

sim <- 5000  # number of simulations to run
Y <- 200  # number of years in the simulation post initialization
# for ages 1 to 31; elver arriving to the area is age index 1
A <- 31    # age index, for initiailization

# ln of length at age, log.mean, log.sigma
Lt.log.mean <- c(2.1159, 2.5856, 3.2311, 3.5728, 3.6811, 3.8232, 3.8928, 3.9423, 3.9546, 3.9803,
                 3.9665, 4.0784, 4.1698, 4.2216, 4.2573, 4.2354, 4.2178, 4.2227, 4.2703, 4.2235,
                 4.1877, 4.283, 4.2049, 4.2032, 4.2085, 4.2292, 4.2017, 4.2017, 4.2017, 4.2017,
                 4.2017)
Lt.log.sigma <- c(0.1638, 0.3466, 0.3316, 0.2811, 0.3055, 0.2988, 0.2902, 0.2805, 0.2588, 0.1929,
                  0.2248, 0.23, 0.1291, 0.1293, 0.1275, 0.1192, 0.1077, 0.1085, 0.0951, 0.1075,
                  0.1094, 0.1396, 0.12, 0.1016, 0.0773, 0.0424, 0.076, 0.076, 0.076, 0.076,
                  0.076)
Wt.Log.alpha <- -7.5609
Wt.Log.beta <-  3.2934
Wt.Log.sigma <- 0.1632   # sigma error for the wt lgth regression, used to correct the mean when transforming from log
Wt <- array(0, A, dim=c(1,A))

pred.Wt <- array(0, A, dim=c(1,A))
for (a in 1:A){
  pred.Wt[a] <- exp(Wt.Log.alpha + rnorm(1, Lt.log.mean[a], Lt.log.sigma[a]) * Wt.Log.beta + 0.5*Wt.Log.sigma*Wt.Log.sigma)
#print(pred.Wt[a])
}

# natural mortality at age
M.min <- c(0.4103, 0.2014, 0.0757, 0.0451, 0.0383, 0.0309, 0.0278, 0.0258, 0.0253, 0.0243,
           0.0249, 0.021, 0.0183, 0.0169, 0.016, 0.0165, 0.017, 0.0169, 0.0157, 0.0168,
           0.0178, 0.0154, 0.0173, 0.0174, 0.0172, 0.0167, 0.0174, 0.0174, 0.0174, 0.0174,
           0.0174)
M.max <- c(0.5653, 0.2775, 0.1044, 0.0622, 0.0528, 0.0426, 0.0383, 0.0355, 0.0349, 0.0335,
           0.0342, 0.0289, 0.0252, 0.0233, 0.022, 0.0228, 0.0234, 0.0232, 0.0216, 0.0232,
           0.0245, 0.0212, 0.0239, 0.0239, 0.0237, 0.023, 0.024, 0.024, 0.024, 0.024,
           0.024)
M <- array(0, A, dim=c(1,A))

pred.M <- array(0, A, dim=c(1,A))
for (a in 1:A){
  pred.M[a] <- runif(1, M.min[a], M.max[a])
#print(pred.M[a])  
}

# prob of silvering 
Not.mat <- c(49.9, 49.9, 49.9, 49.9, 49.9, 49.9, 49, 48, 47, 46,
             45, 30, 28, 28, 28, 28, 28, 28, 28, 28,
             28, 28, 28, 28, 28, 28, 28, 28, 28, 28,
             28)
mat <- c(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 1, 2, 3, 4,
         5, 20, 22, 22, 22, 22, 22, 22, 22, 22,
         22, 22, 22, 22, 22, 22, 22, 22, 22, 22,
         22)
p.Mat <- array(0, A, dim=c(1,A))

pred.p.Mat <- array(0, A, dim=c(1,A))
for (a in 1:A){
  pred.p.Mat[a] <- rbeta(1, mat[a], Not.mat[a])
#print( pred.p.Mat[a])
}

# partial recruitment to anthropogenic mortality
pr.F.not <- c(49.9, 49.9, 30, 25, 20, 15, 10, 8, 6, 4,
              2, 1, 1, 1, 1, 1, 1, 1, 1, 1,
              1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
              1)
pr.F <- c(0.1, 0.1, 20, 25, 30, 35, 40, 42, 44, 46,
          48, 49, 49, 49, 49, 49, 49, 49, 49, 49,
          49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
          49)
PR.F <- array(0, A, dim=c(1,A))
print(PR.F)
pred.PR.F <- array(0, A, dim=c(1,A))
#print(pred.PR.F)
for (a in 1:A){
  pred.PR.F[a] <- rbeta(1, pr.F[a], pr.F.not[a])
#print(pred.PR.F[a])
}

# Sargasso Sea dynamic
# instantaneous mortality rate of migrating silver eels to the Sargasso Sea
   M.Sea <- 0.1
# interannual variation in silver eel mortality at sea exp(-M.Sea* exp(rnorm*M.Sea.sigma - 0.5*M.Sea.sigma^2)
   M.Sea.sigma <- 0.01

# SPR analysis using these life history parameter results in 1 elver producting 113 g of silver eel biomass
# therefore silver biomass (kg) to elver recruitment rate density independent, is 7.5
# we used 10 elvers per kg of silver eel biomass as the recruitment rate 
   alpha <- 10
# interannual variation in egg to elver survival  R = S * alpha * exp(rnorm*sigma - 0.5*sigma^2)
   alpha.sigma <- 0.2

# density dependent instantaneous mortality rate of elvers arriving to the area (M[1] = q * B.Tot[y])
# for carrying capacity of 200,000 kg of eels post elver in the area when elvers arrive
# loss[y] = 1-exp(-q*B.Tot[y]))
   # q <- 0.000015  # at capacity, 95% of elvers die, at half of capacity, loss = 78% 
     q <- 0.000007  # at capacity, 75% of elvers die, at half of capacity, loss = 50% 

# anthropogenic mortality parameters
   F <- 0   # fully recruited F value

# intializing matrices for holding time and age step values for abundance
p.Blim <- array(0, (Y+A), dim=c((Y+A),1) )   # proportion of simulations when standing stock is less than 20% carrying capacity
C.Y.Tot <- array(0, sim*(Y+A), dim=c(sim,(Y+A)) )   # total anthropogenic loss in number of yellow eel
C.S.Tot <- array(0, sim*(Y+A), dim=c(sim,(Y+A)) )   # total anthropogenic loss in number of silver eel
B.S <- array(0, sim*(Y+A), dim=c(sim,(Y+A)) )   # biomass in kg of silver eels at Sargasso Sea
B.Tot <- array(0, sim*(Y+A), dim=c(sim, (Y+A)) )   # biomass of eels in area at start of year when elvers arrive
p.B.Tot <-array(0, sim*(Y+A), dim=c(sim, (Y+A)) )   # if standing stock biomass is less tha 20% of carrying capacity
Loss.Elver <- array(0, sim*(Y+A), dim=c(sim,(Y+A)) )   # mortality rate of elver corrected for biomass of standing stock of eels at start year y
Elver <- array(0, sim*(Y+A), dim=c(sim,(Y+A)) )  # elver recruitment to the river
N <- array(0,sim*(A+1)*(Y+A), dim=c(sim, (Y+A),(A+1)) )  # eels by age at start of year
N.Y <- array(0,sim*(A+1)*(Y+A), dim=c(sim, (Y+A),(A+1)) )  # yellow eels by age in year afer anthropogenic mortality
N.S <- array(0,sim*(A+1)*(Y+A), dim=c(sim,(Y+A),(A+1)) )  # silver eels by age in year afer anthropogenic mortality
C.Y <- array(0,sim*(A+1)*(Y+A), dim=c(sim, (Y+A),(A+1)) )  # yellow eels by age in year lost to anthropogenic mortality
C.S <- array(0,sim*(A+1)*(Y+A), dim=c(sim, (Y+A),(A+1)) )  # silver eels by age in year lost to anthropogenic mortality
Wt.S <- array(0,sim*(A+1)*(Y+A), dim=c(sim, (Y+A),(A+1)) )  # weight of silver eels in kg by age arriving to Sargasso Sea
Wt.N <- array(0,sim*(A+1)*(Y+A), dim=c(sim, (Y+A),(A+1)) )  # weight of eels in kg by age at start of year
#print(Wt.N)
# timeout <- 1 #use this in part to keep track of the simulation count
for (s in 1:sim){
#  print(Sys.time())
# initializing the population for first A years of simulation
for (y in 1:A){
  N[s,y,1] <- 100000  # elvers arriving to the area

  for (a in 1:A){
    Wt[a] <- exp(Wt.Log.alpha + rnorm(1, Lt.log.mean[a], Lt.log.sigma[a]) * Wt.Log.beta + 0.5*Wt.Log.sigma*Wt.Log.sigma)/1000
    M[a] <- runif(1, M.min[a], M.max[a])
    p.Mat[a] <- rbeta(1, mat[a], Not.mat[a])
    PR.F[a] <- rbeta(1, pr.F[a], pr.F.not[a])
    
    N[s,(y+a),(a+1)] <- (N[s,(y+a-1),a] - C.Y[s,(y+a-1),a] - C.S[s,(y+a-1),a] - N.S[s,(y+a-1),a])*exp(-M[a])
    Wt.N[s,(y+a),(a+1)] <- N[s,(y+a),(a+1)] * Wt[a]
    C.Y[s,(y+a),(a+1)]<- N[s,(y+a),(a+1)]*(1-p.Mat[a])*(1-exp(-F*PR.F[a]))
    N.Y[s,(y+a),(a+1)]<- N[s,(y+a),(a+1)]*(1-p.Mat[a]) - C.Y[s,(y+a),(a+1)]
    C.S[s,(y+a),(a+1)] <- N[s,(y+a),(a+1)]*(p.Mat[a])*(1-exp(-F*PR.F[a]))
    N.S[s,(y+a),(a+1)] <- N[s,(y+a),(a+1)]*(p.Mat[a])-C.S[s,(y+a),(a+1)]
    Wt.S[s,(y+a),(a+1)] <- (N.S[s,(y+a),(a+1)] * exp(-M.Sea)) * Wt[a]
    
  }   # end age loop
  
  B.S[s,y] <- sum(Wt.S[s,y,])
  B.Tot[s,y] <- sum(Wt.N[s,y,2:(A+1)])
  p.B.Tot[s,y] <- (B.Tot[s,y] < 40000)*1  #assuming standing stock carrying capacity is 200000 kg
  C.Y.Tot[s,y] <- sum(C.Y[s,y,])
  C.S.Tot[s,y] <- sum(C.S[s,y,])
  Loss.Elver[s,y] <- 1-exp(-M[1]) 
  Elver[s,y] <- N[s,y,1]
}  #end year loop


