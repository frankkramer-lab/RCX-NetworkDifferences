#' Update networkDifferences
#'
#' This functions updates an [networkDifferences] aspect with an other [networkDifferences] aspect or within an \link[RCX:createRCX]{RCX object}.
#'
#' @param x \link[RCX:createRCX]{RCX object} or [networkDifferences] object; (to which the new [networkDifferences] will be added)
#' @param networkDifferences [networkDifferences] object; (the [networkDifferences] aspect, that will be added)
#' @param ... additional parameters
#'
#' @return updated \link[RCX:createRCX]{RCX object} or [MetaRelSubNetVis] object
#' @seealso [RCX::updateNodeAttributes], [RCX::updateEdgeAttributes], [RCX::updateNetworkAttributes]
#' @export
updateNetworkDifferences = function(x, networkDifferences, ...){
    ## Check the class of the given networkDifferences aspect
    if (class(networkDifferences)[2] != "NetworkDifferencesAspect") {
        stop('aspect must be from the type networkDifferencesAspect')
    }
    x$networkDifferences <- networkDifferences
    return(x)
}