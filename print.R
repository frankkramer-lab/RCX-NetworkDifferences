#' @rdname custom-print
#' @export
print.NetworkDifferencesAspect = function(aspect) {
    cat("Network differences:\n")
    cat("MatchByName:\n")
    cat(aspect$matchByName)
    cat("\n")
    cat("Nodes:\n")
    print(aspect$nodes)
    cat("NodeAttributes:\n")
    print(aspect$nodeAttributes)
    cat("Edges:\n")
    print(aspect$edges)
    cat("EdgeAttributes:\n")
    print(aspect$edgeAttributes)
    cat("NetworkAttributes:\n")
    print(aspect$networkAttributes)
}