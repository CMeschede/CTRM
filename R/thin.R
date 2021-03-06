#' Apply a higher threshold to a CTRM process
#'
#' Drop all but the \code{k} largest observations.
#'
#' @param ctrm A \code{\link{ctrm}} object.
#'        k    Discard all but the \code{k} largest magnitudes.
#' @return A \code{\link{ctrm}} object, with fewer observations.
#' @export

thin <- function(ctrm, k) {
  n <- length(coredata.ctrm(ctrm))
  if (k > n)
    stop("Can't threshold to ", k, " observations if I only have ", n)
  JJ <- coredata.ctrm(ctrm)
  idxJ <- order(JJ, decreasing = TRUE)
  new_magnitudes  <- JJ[idxJ[1:k]]
  TT <- time(ctrm)
  new_times       <- TT[idxJ[1:k]]
  out <- CTRM::ctrm(x = new_times, y = new_magnitudes)
  new_estimates <- environment(ctrm)$MLestimates
  if (!is.null(new_estimates)) {
    new_estimates <- new_estimates[new_estimates$k <= k,]
    environment(out)$MLestimates <- new_estimates
  }
  out
}
