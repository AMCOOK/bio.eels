#' @export
solver = function(pars,fn,hess=F) {
					fit = optim(pars,fn,method='BFGS',hessian=hess)
					if(hess){
					fit$VarCov = solve(fit$hessian)  			#Variance-Covariance
					fit$SDs = sqrt(diag(fit$V))				#Standard deviations
					fit$Correlations = fit$V/(fit$S %o% fit$S) 	#Parameter correlation
				}
				return(fit)
		}
		