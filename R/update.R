#' Update RCX-object with NetworkDifferences aspect
#'
#' This functions updates an \link[RCX:createRCX]{RCX object} with a [NetworkDifferences] aspect
#' @param x \link[RCX:createRCX]{RCX object}; (to which the new [networkDifferences] will be added)
#' @param networkDifferences [NetworkDifferences] aspect
#' @param ... additional parameters
#'
#' @return updated \link[RCX:createRCX]{RCX object}
#' @export
updateNetworkDifferences = function(x, networkDifferences, replace=TRUE, ...){
    UseMethod("updateNetworkDifferences", x)
}

#' @rdname updateNetworkDifferences
#' @export
updateNetworkDifferences.RCX = function(x, networkDifferences, ...){
    ## Check the class of the given networkDifferences aspect
    if (class(networkDifferences)[2] != "NetworkDifferencesAspect") {
        stop('aspect must be from the type networkDifferencesAspect')
    }
    x$networkDifferences <- networkDifferences
    return(x)
}