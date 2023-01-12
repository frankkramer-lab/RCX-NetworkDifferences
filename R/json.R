#' Helper function to convert the networkDifferences-aspect
#'
#' @param aspect [NetworkDifferences] aspect
#' @param verbose logical; whether to print what is happening
#'
#' @return character; JSON of the [NetworkDifferences] aspect
#' 
#' @importFrom RCX .convert2json.logical, .convert2json.data.frame
rcxToJson.NetworkDifferencesAspect = function(aspect, verbose = FALSE) {
    if(verbose) cat("Convert NetworkDifferences to JSON...")
    ## Convert MatchByName
    aspect$matchByName = RCX:::.convert2json.logical(aspect$matchByName)
    ## Convert Nodes
    if (aspect$matchByName == "\"true\"") {
        map = c(id="@id",
                name="n",
                representLeft="rl",
                representRight="rr",
                oldIdLeft="oil",
                oldIdRight="oir",
                belongsToLeft="btl",
                belongsToRight="btr")
    }
    else {
        map = c(id="@id",
                nameLeft="nl",
                nameRight="nr",
                represent="r",
                oldIdLeft="oil",
                oldIdRight="oir",
                belongsToLeft="btl",
                belongsToRight="btr")
    }
    aspect$nodes = RCX:::.convert2json.data.frame(RCX:::.renameDF(aspect$nodes, map), skipNa = TRUE)
    ## Convert NodeAttributes
    map = c(propertyOf="po",
            name="n",
            belongsToLeft="btl",
            belongsToRight="btr",
            dataTypeLeft="dtl",
            dataTypeRight="dtr",
            isListLeft="ill",
            isListRight="ilr",
            valueLeft="vl",
            valueRight="vr")
    aspect$nodeAttributes = RCX:::.convert2json.data.frame(RCX:::.renameDF(aspect$nodeAttributes, map), skipNa = TRUE)
    ## Convert edges
    map = c(id="@id",
            name="n",
            source="s",
            target="t",
            interaction="i",
            oldIdLeft="oil",
            oldIdRight="oir",
            belongsToLeft="btl",
            belongsToRight="btr")
    aspect$edges = RCX:::.convert2json.data.frame(RCX:::.renameDF(aspect$edges, map), skipNa = TRUE)
    ## Convert edgeAttributes
    map = c(propertyOf="po",
            name="n",
            belongsToLeft="btl",
            belongsToRight="btr",
            dataTypeLeft="dtl",
            dataTypeRight="dtr",
            isListLeft="ill",
            isListRight="ilr",
            valueLeft="vl",
            valueRight="vr")
    aspect$edgeAttributes = RCX:::.convert2json.data.frame(RCX:::.renameDF(aspect$edgeAttributes, map), skipNa = TRUE)
    ## Convert nodeAttributes
    map = c(name="n",
            belongsToLeft="btl",
            belongsToRight="btr",
            dataTypeLeft="dtl",
            dataTypeRight="dtr",
            isListLeft="ill",
            isListRight="ilr",
            valueLeft="vl",
            valueRight="vr")
    aspect$networkAttributes = RCX:::.convert2json.data.frame(RCX:::.renameDF(aspect$networkAttributes, map), skipNa = TRUE)
    ## Create result
    json = paste0('{"matchByName":',aspect$matchByName,'},{"nodes":',aspect$nodes,'},{"nodeAttributes":',aspect$nodeAttributes,
                  '},{"edges":',aspect$edges,'},{"edgeAttributes":',aspect$edgeAttributes,'},{"networkAttributes":',aspect$networkAttributes,'}')
    json = paste0('{"NetworkDifferencesAspect":[',json,']}')
    if(verbose) cat("done!\n")
    return(json)
}

#' @rdname jsonToRCX
#' @export
jsonToRCX.NetworkDifferencesAspect = function(jsonData, verbose){
    
    RCX:::updateAspectClasses(aspectClasses, c(networkDifferences="NetworkDifferencesAspect"))
    #print(aspectClasses)
    if(verbose) cat("Parsing networkDifferences...")
    ## matchByName
    jsonData = jsonData[[1]]
    matchByName = TRUE
    if (jsonData[[1]]$matchByName == "false") {
        matchByName = FALSE
    }
    ## nodes
    nodes = data.frame()
    if (matchByName) {
        data = jsonData[[2]]$nodes
        id = RCX:::.jsonV(data, "@id")
        name = RCX:::.jsonV(data, "n", default = NA, returnAllDefault=TRUE)
        representLeft = RCX:::.jsonV(data, "rl", default = NA, returnAllDefault=TRUE)
        representRight = RCX:::.jsonV(data, "rr", default = NA, returnAllDefault=TRUE)
        oldIdLeft = RCX:::.jsonV(data, "oil", default = NA, returnAllDefault=TRUE)
        oldIdRight  = RCX:::.jsonV(data, "oir", default = NA, returnAllDefault=TRUE)
        belongsToLeft = RCX:::.jsonV(data, "btl", default = NA, returnAllDefault=TRUE)
        belongsToRight = RCX:::.jsonV(data, "btr", default = NA, returnAllDefault=TRUE)
        nodes = data.frame(id, name, representLeft, representRight, oldIdLeft, oldIdRight, belongsToLeft, belongsToRight)
    } 
    else {
        data = jsonData[[2]]$nodes
        id = RCX:::.jsonV(data, "@id")
        nameLeft = RCX:::.jsonV(data, "nl", default = NA, returnAllDefault=TRUE)
        nameRight = RCX:::.jsonV(data, "nr", default = NA, returnAllDefault=TRUE)
        represent = RCX:::.jsonV(data, "r", default = NA, returnAllDefault=TRUE)
        oldIdLeft = RCX:::.jsonV(data, "oil", default = NA, returnAllDefault=TRUE)
        oldIdRight  = RCX:::.jsonV(data, "oir", default = NA, returnAllDefault=TRUE)
        belongsToLeft = RCX:::.jsonV(data, "btl", default = NA, returnAllDefault=TRUE)
        belongsToRight = RCX:::.jsonV(data, "btr", default = NA, returnAllDefault=TRUE)
        nodes = data.frame(id, nameLeft, nameRight, represent, oldIdLeft, oldIdRight, belongsToLeft, belongsToRight)
    }
    
    ## nodeAttributes
    nodeAttributes = data.frame(propertyOf=character(),
                                name=character(),
                                belongsToLeft=character(),
                                belongsToRight=character(),
                                dataTypeLeft=character(),
                                dataTypeRight=character(),
                                isListLeft=character(),
                                isListRight=character(),
                                valueLeft=character(),
                                valueRight=character())
    data = jsonData[[3]]$nodeAttributes
    if (length(data) > 0) {
        propertyOf = RCX:::.jsonV(data, "po", default = NA, returnAllDefault=TRUE)
        name = RCX:::.jsonV(data, "n", default = NA, returnAllDefault=TRUE)
        belongsToLeft = RCX:::.jsonV(data, "btl", default = NA, returnAllDefault=TRUE)
        belongsToRight = RCX:::.jsonV(data, "btr", default = NA, returnAllDefault=TRUE)
        dataTypeLeft = RCX:::.jsonV(data, "dtl", default = NA, returnAllDefault=TRUE)
        dataTypeRight = RCX:::.jsonV(data, "dtr", default = NA, returnAllDefault=TRUE)
        isListLeft = RCX:::.jsonV(data, "ill", default = NA, returnAllDefault=TRUE)
        isListRight = RCX:::.jsonV(data, "ilr", default = NA, returnAllDefault=TRUE)
        valueLeft = RCX:::.jsonV(data, "vl", default = NA, returnAllDefault=TRUE) 
        valueRight = RCX:::.jsonV(data, "vr", default = NA, returnAllDefault=TRUE)
        nodeAttributes = data.frame(propertyOf, name, belongsToLeft, belongsToRight, 
                                    dataTypeLeft, dataTypeRight, isListLeft, isListRight,
                                    valueLeft, valueRight)
    }
    
    ## edges
    edges = data.frame(id=character(),
                       source=character(),
                       target=character(),
                       interaction=character(),
                       oldIdLeft=character(),
                       oldIdRight=character(),
                       belongsToLeft=character(),
                       belongsToRight=character())
    data = jsonData[[4]]$edges
    if (length(data) > 0) {
        id = RCX:::.jsonV(data, "@id")
        source = RCX:::.jsonV(data, "s", default = NA, returnAllDefault=TRUE)
        target = RCX:::.jsonV(data, "t", default = NA, returnAllDefault=TRUE)
        interaction = RCX:::.jsonV(data, "i", default = NA, returnAllDefault=TRUE)
        oldIdLeft = RCX:::.jsonV(data, "oil", default = NA, returnAllDefault=TRUE)
        oldIdRight  = RCX:::.jsonV(data, "oir", default = NA, returnAllDefault=TRUE)
        belongsToLeft = RCX:::.jsonV(data, "btl", default = NA, returnAllDefault=TRUE)
        belongsToRight = RCX:::.jsonV(data, "btr", default = NA, returnAllDefault=TRUE)
        edges = data.frame(id, source, target, interaction, oldIdLeft, oldIdRight, belongsToLeft, belongsToRight)
    }
    
    ## edgeAttributes
    edgeAttributes = data.frame(propertyOf=character(),
                                name=character(),
                                belongsToLeft=character(),
                                belongsToRight=character(),
                                dataTypeLeft=character(),
                                dataTypeRight=character(),
                                isListLeft=character(),
                                isListRight=character(),
                                valueLeft=character(),
                                valueRight=character())
    data = jsonData[[5]]$edgeAttributes
    if (length(data) > 0) {
        propertyOf = RCX:::.jsonV(data, "po", default = NA, returnAllDefault=TRUE)
        name = RCX:::.jsonV(data, "n", default = NA, returnAllDefault=TRUE)
        belongsToLeft = RCX:::.jsonV(data, "btl", default = NA, returnAllDefault=TRUE)
        belongsToRight = RCX:::.jsonV(data, "btr", default = NA, returnAllDefault=TRUE)
        dataTypeLeft = RCX:::.jsonV(data, "dtl", default = NA, returnAllDefault=TRUE)
        dataTypeRight = RCX:::.jsonV(data, "dtr", default = NA, returnAllDefault=TRUE)
        isListLeft = RCX:::.jsonV(data, "ill", default = NA, returnAllDefault=TRUE)
        isListRight = RCX:::.jsonV(data, "ilr", default = NA, returnAllDefault=TRUE)
        valueLeft = RCX:::.jsonV(data, "vl", default = NA, returnAllDefault=TRUE) 
        valueRight = RCX:::.jsonV(data, "vr", default = NA, returnAllDefault=TRUE)
        edgeAttributes = data.frame(propertyOf, name, belongsToLeft, belongsToRight, 
                                    dataTypeLeft, dataTypeRight, isListLeft, isListRight,
                                    valueLeft, valueRight)
    }
    
    ## networkAttributes
    networkAttributes = data.frame(name=character(),
                                belongsToLeft=character(),
                                belongsToRight=character(),
                                dataTypeLeft=character(),
                                dataTypeRight=character(),
                                isListLeft=character(),
                                isListRight=character(),
                                valueLeft=character(),
                                valueRight=character())
    data = jsonData[[6]]$networkAttributes
    if (length(data) > 0) {
        name = RCX:::.jsonV(data, "n", default = NA, returnAllDefault=TRUE)
        belongsToLeft = RCX:::.jsonV(data, "btl", default = NA, returnAllDefault=TRUE)
        belongsToRight = RCX:::.jsonV(data, "btr", default = NA, returnAllDefault=TRUE)
        dataTypeLeft = RCX:::.jsonV(data, "dtl", default = NA, returnAllDefault=TRUE)
        dataTypeRight = RCX:::.jsonV(data, "dtr", default = NA, returnAllDefault=TRUE)
        isListLeft = RCX:::.jsonV(data, "ill", default = NA, returnAllDefault=TRUE)
        isListRight = RCX:::.jsonV(data, "ilr", default = NA, returnAllDefault=TRUE)
        valueLeft = RCX:::.jsonV(data, "vl", default = NA, returnAllDefault=TRUE) 
        valueRight = RCX:::.jsonV(data, "vr", default = NA, returnAllDefault=TRUE)
        networkAttributes = data.frame(name, belongsToLeft, belongsToRight, 
                                       dataTypeLeft, dataTypeRight, isListLeft, isListRight,
                                       valueLeft, valueRight)
    }

    if(verbose) cat("create aspect...")
    result = list("matchByName" = matchByName, "nodes" = nodes, "nodeAttributes" = nodeAttributes,
                  "edges" = edges, "edgeAttributes" = edgeAttributes, "networkAttributes" = networkAttributes)
    class(result) = c(class(result), "NetworkDifferencesAspect")
    if(verbose) cat("done!\n")
    return(result)
}
