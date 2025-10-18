library(mcmc)
rm(list=ls())
data(logit, package="mcmc")

Y <- logit$y
X <- data.matrix(logit[, 2:5])
N <- 1e5
d <- 4
s <- 20

log_posterior <- function(beta) {
  # Log-likelihood
  linear_pred <- X %*% beta
  loglik <- sum(dbinom(Y, size=1, prob=1/(1+exp(-linear_pred)), log=TRUE))
  # Log-prior (normal prior)
  logprior <- sum(dnorm(beta, 0, s, log=TRUE))
  return(loglik + logprior)
}

# Initialize chain
beta <- matrix(0, nrow=N, ncol=d)
acc.prob <- numeric(N)

beta[1, ] <- rep(0, d) # initial state

for (i in 2:N) {
  if (i %% 1e4 == 0) print(paste("Iteration:", i))
  prop <- rnorm(d, mean=beta[i-1,], sd=0.48)
  log_alpha <- log_posterior(prop) - log_posterior(beta[i-1,])
  alpha <- min(1, exp(log_alpha))
  if (runif(1) < alpha) {
    beta[i, ] <- prop
    acc.prob[i] <- 1
  } else {
    beta[i, ] <- beta[i-1, ]
    acc.prob[i] <- 0
  }
}

acceptance_rate <- mean(acc.prob[-(1:1000)]) # discard first 1000 as burn-in
cat("Acceptance rate (post burn-in):", acceptance_rate, "\n")

# Plot acceptance rate convergence
plot(cumsum(acc.prob) / (1:N), type = "l", col="red",
     ylab = "Cumulative acceptance rate", xlab = "Iteration")
abline(h = 0.234, col = "blue", lty = 2) # Optimal for random walk MH in dimensions > 1

# Trace plot for each parameter
par(mfrow=c(2,2))
for (j in 1:d) {
  plot(beta[,j], type="l", main=paste("Trace plot for beta", j),
       ylab=paste("beta", j), xlab="Iteration")
}

# Posterior means after burn-in
posterior_means <- colMeans(beta[-(1:1000), ])
print(posterior_means)
