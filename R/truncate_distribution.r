#'	@export
truncate_distribution = function( W, Ql, Qu ) {
        Q = quantile( W, c(Ql, Qu), na.rm=T )
        W = W[which( W >= Q[1]  & W <= Q[2] )] 
        return (W)
      }
