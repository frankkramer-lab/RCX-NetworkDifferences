rcxToJson.NetworkDifferencesAspect = function(aspect, verbose = FALSE, ...) {
    if(verbose) cat("Convert NetworkDifferences to JSON...")
    
    aspect$matchByName = .convert2json.logical(aspect$matchByName)
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
    aspect$nodes = .convert2json(.renameDF(aspect$nodes, map), skipNa = TRUE) 
    
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
    aspect$nodeAttributes = .convert2json(.renameDF(aspect$nodeAttributes, map), skipNa = TRUE)
    
    map = c(id="@id", 
            name="n", 
            source="s",
            target="t",
            interaction="i",
            oldIdLeft="oil",
            oldIdRight="oir",
            belongsToLeft="btl",
            belongsToRight="btr")
    aspect$edges = .convert2json(.renameDF(aspect$edges, map), skipNa = TRUE)
    
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
    aspect$edgeAttributes = .convert2json(.renameDF(aspect$edgeAttributes, map), skipNa = TRUE)
    
    map = c(name="n", 
            belongsToLeft="btl",
            belongsToRight="btr",
            dataTypeLeft="dtl",
            dataTypeRight="dtr",
            isListLeft="ill",
            isListRight="ilr",
            valueLeft="vl",
            valueRight="vr")
    aspect$networkAttributes = .convert2json(.renameDF(aspect$networkAttributes, map), skipNa = TRUE)
    
    json = paste0('{"matchByName":',aspect$matchByName,'},{"nodes":',aspect$nodes,'},{"nodeAttributes":',aspect$nodeAttributes,
                  '},{"edges":',aspect$edges,'},{"edgeAttributes":',aspect$edgeAttributes,'},{"networkAttributes":',aspect$networkAttributes,'}')
    json = paste0('{"networkDifferences":[',json,']}')
    if(verbose) cat("done!\n")
    return(json)
}

#' @rdname jsonToRCX
#' @export
jsonToRCX.networkDifferences = function(jsonData, verbose){
    if(verbose) cat("Parsing networkDifferences...")
    ## matchByName
    data = jsonData$networkDifferences[[1]]$matchByName
    matchByName = TRUE
    if (data == "false") {
        matchByName = FALSE
    }
    ## nodes
    nodes = data.frame()
    if (matchByName) {
        data = jsonData$networkDifferences[[2]]$nodes
        id = .jsonV(data, "@id")
        name = .jsonV(data, "n", default = NA, returnAllDefault=TRUE)
        representLeft = .jsonV(data, "rl", default = NA, returnAllDefault=TRUE)
        representRight = .jsonV(data, "rr", default = NA, returnAllDefault=TRUE)
        oldIdLeft = .jsonV(data, "oil", default = NA, returnAllDefault=TRUE)
        oldIdRight  = .jsonV(data, "oir", default = NA, returnAllDefault=TRUE)
        belongsToLeft = .jsonV(data, "btl", default = NA, returnAllDefault=TRUE)
        belongsToRight = .jsonV(data, "btr", default = NA, returnAllDefault=TRUE)
        nodes = data.frame(id, name, representLeft, representRight, oldIdLeft, oldIdRight, belongsToLeft, belongsToRight)
    } 
    else {
        data = jsonData$networkDifferences[[2]]$nodes
        id = .jsonV(data, "@id")
        nameLeft = .jsonV(data, "nl", default = NA, returnAllDefault=TRUE)
        nameRight = .jsonV(data, "nr", default = NA, returnAllDefault=TRUE)
        represent = .jsonV(data, "r", default = NA, returnAllDefault=TRUE)
        oldIdLeft = .jsonV(data, "oil", default = NA, returnAllDefault=TRUE)
        oldIdRight  = .jsonV(data, "oir", default = NA, returnAllDefault=TRUE)
        belongsToLeft = .jsonV(data, "btl", default = NA, returnAllDefault=TRUE)
        belongsToRight = .jsonV(data, "btr", default = NA, returnAllDefault=TRUE)
        nodes = data.frame(id, nameLeft, nameRight, represent, oldIdLeft, oldIdRight, belongsToLeft, belongsToRight)
    }
    
    
    ## nodeAttributes
    data = jsonData$networkDifferences[[3]]$nodeAttributes
    propertyOf = .jsonV(data, "po", default = NA, returnAllDefault=TRUE)
    name = .jsonV(data, "n", default = NA, returnAllDefault=TRUE)
    belongsToLeft = .jsonV(data, "btl", default = NA, returnAllDefault=TRUE)
    belongsToRight = .jsonV(data, "btr", default = NA, returnAllDefault=TRUE)
    dataTypeLeft = .jsonV(data, "dtl", default = NA, returnAllDefault=TRUE)
    dataTypeRight = .jsonV(data, "dtr", default = NA, returnAllDefault=TRUE)
    isListLeft = .jsonV(data, "ill", default = NA, returnAllDefault=TRUE)
    isListRight = .jsonV(data, "ilr", default = NA, returnAllDefault=TRUE)
    valueLeft = .jsonV(data, "vl", default = NA, returnAllDefault=TRUE) 
    valueRight = .jsonV(data, "vr", default = NA, returnAllDefault=TRUE)
    nodeAttributes = data.frame(propertyOf, name, belongsToLeft, belongsToRight, 
                                dataTypeLeft, dataTypeRight, isListLeft, isListRight,
                                valueLeft, valueRight)
    
    ## edges
    data = jsonData$networkDifferences[[4]]$edges
    id = .jsonV(data, "@id")
    source = .jsonV(data, "s", default = NA, returnAllDefault=TRUE)
    target = .jsonV(data, "t", default = NA, returnAllDefault=TRUE)
    interaction = .jsonV(data, "i", default = NA, returnAllDefault=TRUE)
    oldIdLeft = .jsonV(data, "oil", default = NA, returnAllDefault=TRUE)
    oldIdRight  = .jsonV(data, "oir", default = NA, returnAllDefault=TRUE)
    belongsToLeft = .jsonV(data, "btl", default = NA, returnAllDefault=TRUE)
    belongsToRight = .jsonV(data, "btr", default = NA, returnAllDefault=TRUE)
    edges = data.frame(id, source, target, interaction, oldIdLeft, oldIdRight, belongsToLeft, belongsToRight)
    
    ## edgeAttributes
    data = jsonData$networkDifferences[[5]]$edgeAttributes
    propertyOf = .jsonV(data, "po", default = NA, returnAllDefault=TRUE)
    name = .jsonV(data, "n", default = NA, returnAllDefault=TRUE)
    belongsToLeft = .jsonV(data, "btl", default = NA, returnAllDefault=TRUE)
    belongsToRight = .jsonV(data, "btr", default = NA, returnAllDefault=TRUE)
    dataTypeLeft = .jsonV(data, "dtl", default = NA, returnAllDefault=TRUE)
    dataTypeRight = .jsonV(data, "dtr", default = NA, returnAllDefault=TRUE)
    isListLeft = .jsonV(data, "ill", default = NA, returnAllDefault=TRUE)
    isListRight = .jsonV(data, "ilr", default = NA, returnAllDefault=TRUE)
    valueLeft = .jsonV(data, "vl", default = NA, returnAllDefault=TRUE) 
    valueRight = .jsonV(data, "vr", default = NA, returnAllDefault=TRUE)
    edgeAttributes = data.frame(propertyOf, name, belongsToLeft, belongsToRight, 
                                dataTypeLeft, dataTypeRight, isListLeft, isListRight,
                                valueLeft, valueRight)
    
    ## networkAttributes
    data = jsonData$networkDifferences[[6]]$networkAttributes
    name = .jsonV(data, "n", default = NA, returnAllDefault=TRUE)
    belongsToLeft = .jsonV(data, "btl", default = NA, returnAllDefault=TRUE)
    belongsToRight = .jsonV(data, "btr", default = NA, returnAllDefault=TRUE)
    dataTypeLeft = .jsonV(data, "dtl", default = NA, returnAllDefault=TRUE)
    dataTypeRight = .jsonV(data, "dtr", default = NA, returnAllDefault=TRUE)
    isListLeft = .jsonV(data, "ill", default = NA, returnAllDefault=TRUE)
    isListRight = .jsonV(data, "ilr", default = NA, returnAllDefault=TRUE)
    valueLeft = .jsonV(data, "vl", default = NA, returnAllDefault=TRUE) 
    valueRight = .jsonV(data, "vr", default = NA, returnAllDefault=TRUE)
    networkAttributes = data.frame(name, belongsToLeft, belongsToRight, 
                                   dataTypeLeft, dataTypeRight, isListLeft, isListRight,
                                   valueLeft, valueRight)
    if(verbose) cat("create aspect...")
    result = list("matchByName" = matchByName, "nodes" = nodes, "nodeAttributes" = nodeAttributes,
                  "edges" = edges, "edgeAttributes" = edgeAttributes, "networkAttributes" = networkAttributes)
    .addClass(result) = .CLS$networkDifferences
    if(verbose) cat("done!\n")
    return(result)
}