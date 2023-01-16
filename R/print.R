#' Printing the [NetworkDifferences] aspect
#'
#' These functions attempt to print the aspect of an RCX object in a more readable form.
#'
#' @param x [NetworkDifferences] aspect
#'
#' @return prints the [NetworkDifferences] aspect and returns it invisibly ([invisible](x))
#' @export
#' @name print
print.NetworkDifferencesAspect = function(x) {
    cat("Network differences:\n")
    cat("MatchByName:\n")
    cat(x$matchByName)
    cat("\n")
    cat("Nodes:\n")
    print(x$nodes)
    cat("NodeAttributes:\n")
    print(x$nodeAttributes)
    cat("Edges:\n")
    print(x$edges)
    cat("EdgeAttributes:\n")
    print(x$edgeAttributes)
    cat("NetworkAttributes:\n")
    print(x$networkAttributes)
    invisible(x)
}