.onLoad <- function(libname, pkgname) {
    RCX::setExtension(pkgname, "networkDifferences", "NetworkDifferencesAspect")
    invisible()
}
