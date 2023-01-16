#' Number of elements in [NetworkDifferences] aspect
#'
#' This function returns the number of elements in a [NetworkDifferences] aspect.
#'
#' The [RCX::countElements()] function uses method dispatch, so the default methods already returns the correct number for the most aspect classes.
#' This way it is easier to extend the data model.
#' This function implements the function for the [NetworkDifferences] aspect.
#'
#' @param x an object of [NetworkDifferences] aspect class.
#' @return integer; number of elements which is always 1.
#'
#' @seealso [RCX::countElements()], [RCX::hasIds()], [RCX::idProperty()], [RCX::refersTo()], [RCX::referredBy()], [RCX::maxId()]
#'
#' @importFrom RCX countElements
#' @export
countElements.NetworkDifferencesAspect = function(x){
    return(length(1))
}