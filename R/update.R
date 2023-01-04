#' Update NetworkDifferencesAspect
#'
#' This functions updates an [NetworkDifferences] aspect with an other [NetworkDifferences] aspect or within an \link[RCX:createRCX]{RCX object}.
#'
#' @param x \link[RCX:createRCX]{RCX object} or [MetaRelSubNetVis] object; (to which the new [MetaRelSubNetVis] will be added)
#' @param metaRelSubNetVis [MetaRelSubNetVis] object; (the [MetaRelSubNetVis] aspect, that will be added)
#' @param ... additional parameters
#'
#' @return updated \link[RCX:createRCX]{RCX object} or [NetworkDifferences] object
#' @seealso [RCX::updateNodeAttributes], [RCX::updateEdgeAttributes], [RCX::updateNetworkAttributes]
#' @export
#'
#' @example
updateNetworkDifferences = function(x, networkDifferences, ...){
    ## Check the class of the given networkDifferences aspect
    if (class(networkDifferences)[2] != "NetworkDifferencesAspect") {
        stop('aspect must be from the type networkDifferencesAspect')
    }
    x$networkDifferences <- networkDifferences
    return(x)
}