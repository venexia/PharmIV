\name{PharmIV}
\alias{PharmIV}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Power calculator for instrumental variable analysis in pharmacoepidemiology
}
\description{
This package calculates the power of instrumental variable analysis studies using a single binary instrument Z to analyse the causal effect of a binary exposure X on a continuous outcome Y.
}
\usage{
PharmIV(n = NULL, delta = NULL, alpha = 0.05, sigma = 1.00, prob_x1 = NULL, prob_z1 = NULL, cond_z1 = NULL, cond_z0 = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{n}{
Sample size
}
  \item{delta}{
Detectable treatment effect
}
  \item{alpha}{
Significance level (default = 0.05)
}
  \item{sigma}{
Residual variance (default = 1.00)
}
  \item{prob_x1}{
Frequency of exposure, P(X=1)
}
  \item{prob_z1}{
Frequency of instrument, P(Z=1)
}
  \item{cond_z1}{
Probability of exposure given the instrument Z=1, P(X=1|Z=1)
}
  \item{cond_z0}{
Probability of exposure given the instrument Z=0, P(X=1|Z=0)
}
}
\details{
The sample size and detectable treatment effect must be specified, along with at least three of the following: frequency of exposure, frequency of instrument, probability of exposure given the instrument Z=1, and probability of exposure given the instrument Z=0. The unspecified parmater will be determined from the others.
}
\value{
This package returns a data frame detailing the input parameters and the power of the instrumental variable analysis defined by them.
}
\references{
Walker, V. M., Davies, N. M., Windmeijer, F., Burgess, S. & Martin, R. M. Power calculator for instrumental variable analysis in pharmacoepidemiology. bioRxiv 084541 (2016). doi:10.1101/084541
}
\author{
Venexia Walker
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
  PharmIV(n = 10000, delta = 0.20, alpha = 0.05, sigma = 1, prob_x1 = 0.50, prob_z1 = 0.20, cond_z1 = 0.22, cond_z0 = 0.57)
  PharmIV(n = 10000, delta = 0.20, alpha = 0.05, sigma = 1, prob_x1 = 0.50, prob_z1 = 0.20, cond_z1 = 0.22)
  PharmIV(n = 10000, delta = 0.20, alpha = 0.05, sigma = 1, prob_x1 = 0.50, prob_z1 = 0.20, cond_z0 = 0.57)
  PharmIV(n = 10000, delta = 0.20, prob_x1 = 0.50, prob_z1 = 0.20, cond_z0 = 0.57)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{design}
