LlmToOddsRatio <- function(lmm.fil, k)
{
  df.names <- colnames(lmm.fil) 
  p.col <- which(df.names == "Freq" | df.names == "FREQ" | df.names == "FRQ" | df.names == "A1FREQ" | df.names == "af"| df.names == "freq")
  if (length(p.col) == 0)
  {
  	stop("Please rename the allele frequency column FREQ or add an allele frequency for the effect allele from a reference.
  	      Alternatively, check that you have the correct seperator for your results file.")
  }
  p.beta <- which(df.names == "b" | df.names == "BETA" | df.names == "beta" | df.names == "EFFECT")
  if (length(p.beta) == 0)
  {
  	stop("Please rename the allele frequency column BETA or check that you have the correct seperator for your results file")
  }
  p    <- lmm.fil[, p.col]
  beta <- lmm.fil[, p.beta]
  # ------------
  # Odds ratio 3
  # -------------
  p_1 <- p  + (beta * p * (1 - p)) / k
  p_0 <- (p - k * p_1) / (1 - k)
  or.map.1  <- (p_1 * (1 - p_0)) / (p_0 * (1 - p_1))
  # -----------------------
  # Solve for the quadratic
  # -----------------------
  pp <- p
  c1 <- (1 - k) * (3 * beta - 2 * k * beta) + (beta * ((1 - k) ^ 2) * (1 - 2 * k)) / k
  c2 <- (1 - k) * (1 - 4 * beta * pp) - (2 * beta * pp * (1 - k) * (1 - 2 * k)) / k
  c3 <- (pp ^ 2) * beta * (1 - 2 * k) / k + pp * (k - 1 + beta)
  p.0.1 <- (-c2 + sqrt(c2 ^ 2 - 4 * c1 * c3)) / (2 * c1)
  p.0.2 <- (-c2 - sqrt(c2 ^ 2 - 4 * c1 * c3)) / (2 * c1)
  f0    <- c1 + c2 + c3
  if (!(all(c3 < 0) & all(f0 > 0)))
  {
  	bad <- which(f0 <= 0)
  	warning("The following lines don't have real roots p0 and p1")
  	return(lmm.fil[bad, ])
  }
  if (all(p.0.1 > 0 & p.0.1 < 1))
  {
  	p_0 <- p.0.1
  } else if (all(p.0.2 > 0 & p.0.2 < 1))
  {
  	p_0 <- p.0.2
  } else
  {
  	stop("All p0 and p1 values are not between 0 and 1")
  }
  # -------------------
  # Odds ratio quadratic
  # --------------------
  p_1 <- (p - (1 - k) * p_0 ) / k
  or.map.gld  <- (p_1 * (1 - p_0)) / (p_0 * (1 - p_1))
  # -------------------
  # Bind up the results 
  # -------------------
  res <- data.frame(lmm.fil, or.map.gld)
  colnames(res) <- c(colnames(lmm.fil), "OR")
  return(res)
}