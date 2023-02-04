#' Update RCX-object with NetworkDifferences aspect
#'
#' This functions updates an \link[RCX:createRCX]{RCX object} with a [NetworkDifferences] aspect
#' @param x \link[RCX:createRCX]{RCX object}; (to which the new [networkDifferences] will be added)
#' @param networkDifferences [NetworkDifferences] aspect
#' @param ... additional parameters
#'
#' @return updated \link[RCX:createRCX]{RCX object}
#' @export
updateNetworkDifferences = function(x, aspect){
    UseMethod("updateNetworkDifferences", x)
}

#' @rdname updateNetworkDifferences
#' @export
updateNetworkDifferences.NetworkDifferencesAspect = function(x, aspect, replace=TRUE, ...){
    res <- plyr::rbind.fill(x, aspect)
    
    if (!"NetworkDifferencesAspect" %in% class(res)) {
        class(res) <- append("NetworkDifferencesAspect", class(res))
    }
    return(res)
}

#' @rdname updateNetworkDifferences
#' @export
updateNetworkDifferences.RCX = function(x, networkDifferences, ...){
    ## Check the class of the given networkDifferences aspect
    if (class(networkDifferences)[2] != "NetworkDifferencesAspect") {
        stop('aspect must be from the type networkDifferencesAspect')
    }
    x$networkDifferences <- networkDifferences
    x <- updateMetaData(x, aspectClasses = aspectClasses)
    return(x)
}