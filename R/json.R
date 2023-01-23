#' Convert [NetworkDifferences] aspects to JSON
#'
#' Functions for converting the different aspects to JSON following the CX data structure definition
#' (see NDEx documentation: \url{https://home.ndexbio.org/data-model/}).
#'
#' For converting \link[RCX:createRCX]{RCX objects} to JSON, each aspect is processed by a generic function for its
#' aspect class. Those functions return a character only containing the JSON of this aspect, which is then
#' combined by [RCX::toCX] to be a valid CX data structure.
#'
#' To support the conversion for non-standard or own-defined aspects, generic functions for those aspect classes
#' have to be implemented.
#'
#' @param aspect [NetworkDifferences] aspect
#' @param verbose logical; whether to print what is happening
#' @param ... additional parameters, that might needed for extending
#'
#' @return character; JSON of an aspect
#' @export
#' @importFrom RCX rcxToJson
#' @seealso [RCX::toCX], [RCX::writeCX], [RCX::jsonToRCX], [RCX::readCX]
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
    } else {
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


#' Convert parsed JSON aspects to RCX
#'
#' Functions to handle parsed JSON for the [NetworkDifferences] aspect.
#'
#' These functions will be used in [RCX::processCX] to process the JSON data for every aspect.
#' Each aspect is accessible in the CX-JSON by a particular accession name (i.e. its aspect name; see NDEx documentation:
#' \url{https://home.ndexbio.org/data-model/}).
#' This name is used as class to handle different aspects by method dispatch.
#' This simplifies the extension of RCX for non-standard or self-defined aspects.
#'
#' The CX-JSON is parsed to R data types using the [jsonlite] package as follows:
#'
#' `jsonlite::fromJSON(cx, simplifyVector = FALSE)`
#'
#' This results in a list of lists (of lists...) to avoid automatic data type conversions, which affect the correctness and
#' usability of the data. Simplified JSON data for example [NodeAttributes] would be coerced into a data.frame,
#' therefore the `value` column looses the format for data types other than `string`.
#'
#' The *jsonData* will be a list with only one element named by the aspect:
#' `jsonData$<accessionName>`
#'
#' To access the parsed data for example nodes, this can be done by `jsonData$nodes`.
#' The single aspects are then created using the corresponding **create** functions and combined to an \link[RCX:createRCX]{RCX object}
#' object using the corresponding **update** functions.
#'
#' @param jsonData nested list from parsed JSON
#' @param verbose logical; whether to print what is happening
#'
#' @return created aspect or `NULL`
#' @export
#' @importFrom RCX jsonToRCX
#'
#' @seealso [RCX::rcxToJson], [RCX::toCX], [RCX::readCX], [RCX::writeCX]
jsonToRCX.NetworkDifferencesAspect = function(jsonData, verbose){
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
        oldIdRight = RCX:::.jsonV(data, "oir", default = NA, returnAllDefault=TRUE)
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