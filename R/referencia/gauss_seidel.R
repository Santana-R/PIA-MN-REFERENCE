
# Referencia de clase: Gauss-Seidel es SOR con omega=1.
gauss_seidel <- function(A,b,x0=rep(0,length(b)),tol=1e-8,max_iter=10000L) {
  sor(A,b,x0,1,tol,max_iter)
}
