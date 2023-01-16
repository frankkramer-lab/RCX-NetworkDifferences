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
    aspect$matchByName = .convert2json.logical(aspect$matchByName)
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
    aspect$nodes = .convert2json.data.frame(.renameDF(aspect$nodes, map), skipNa = TRUE)
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
    aspect$nodeAttributes = .convert2json.data.frame(.renameDF(aspect$nodeAttributes, map), skipNa = TRUE)
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
    aspect$edges = .convert2json.data.frame(.renameDF(aspect$edges, map), skipNa = TRUE)
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
    aspect$edgeAttributes = .convert2json.data.frame(.renameDF(aspect$edgeAttributes, map), skipNa = TRUE)
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
    aspect$networkAttributes = .convert2json.data.frame(.renameDF(aspect$networkAttributes, map), skipNa = TRUE)
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
        data = jsonData[[2]]$nodes
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
        id = .jsonV(data, "@id")
        source = .jsonV(data, "s", default = NA, returnAllDefault=TRUE)
        target = .jsonV(data, "t", default = NA, returnAllDefault=TRUE)
        interaction = .jsonV(data, "i", default = NA, returnAllDefault=TRUE)
        oldIdLeft = .jsonV(data, "oil", default = NA, returnAllDefault=TRUE)
        oldIdRight = .jsonV(data, "oir", default = NA, returnAllDefault=TRUE)
        belongsToLeft = .jsonV(data, "btl", default = NA, returnAllDefault=TRUE)
        belongsToRight = .jsonV(data, "btr", default = NA, returnAllDefault=TRUE)
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
    }
    
    if(verbose) cat("create aspect...")
    result = list("matchByName" = matchByName, "nodes" = nodes, "nodeAttributes" = nodeAttributes,
                  "edges" = edges, "edgeAttributes" = edgeAttributes, "networkAttributes" = networkAttributes)
    class(result) = c(class(result), "NetworkDifferencesAspect")
    if(verbose) cat("done!\n")
    return(result)
}

#' Return data as a vector from a JSON list
#' 
#' @note Internal function only for convenience
#' @keywords internal
#'
#' @param data json list
#' @param acc accession name
#' @param default default return value
#' @param returnAllDefault whether to return the vector if all values are the default value (or `NULL` instead)
#'
#' @return vector
.jsonV = function(data, acc, default=NA, returnAllDefault=TRUE){
    cls = class(unlist(lapply(data, 
                              function(a){
                                  if(!acc %in% names(a)) return(NA)
                                  return(a[[acc]])
                              })))
    result = vapply(data, 
                    function(a){
                        if(!acc %in% names(a)) return(methods::
                                                          as(default, cls))
                        return(a[[acc]])
                    },
                    methods::as(TRUE, cls))
    if(!returnAllDefault){
        if(is.na(default)){
            if(all(is.na(result))) result = NULL
        }else{
            if(all(result==default)) result = NULL
        }
    }
    return(result)
}

#' Convert data to json by R class 
#'
#' @note Internal function only for convenience
#' @keywords internal
#' 
#' @param x data element
#' @param raw character; names of columns not to format (e.g. because it is already converted)
#'
#' @return character; json
#' @name convert2json
#'
#' @examples
#' NULL
.convert2json = function(x, ...){
    UseMethod(".convert2json",x)
}

#' @rdname convert2json
.convert2json.character = function(x){
    ## escape characters
    x = gsub(r"(\)",r"(\\)",x, fixed=TRUE)
    x = gsub("\n",r"(\\n)",x, fixed=TRUE)
    x = gsub("\t",r"(\\t)",x, fixed=TRUE)
    x = gsub("\r",r"(\\r)",x, fixed=TRUE)
    x = gsub(r"(")",r"(\")",x, fixed=TRUE)
    
    isNa = is.na(x)
    x[!isNa] = paste0('"',x[!isNa],'"')
    return(x)
}

#' @rdname convert2json
.convert2json.numeric = function(x){
    return(as.character(x))
}

#' @rdname convert2json
.convert2json.integer = .convert2json.numeric


#' @rdname convert2json
.convert2json.logical = function(x){
    x[!is.na(x)] = ifelse(x[!is.na(x)],'"true"','"false"')
    return(x)
}

#' @rdname convert2json
.convert2json.list = function(x, raw=c(), byElement=FALSE, skipNa=TRUE){
    if(skipNa) x[is.na(x)] = NULL
    x[vapply(x,is.null,logical(1))] = NULL
    
    nx = names(x)
    
    inRaw = nx %in% raw
    x[!inRaw] = vapply(x[!inRaw], 
                       function(x){.convert2json(x)},
                       character(1))
    
    if(byElement){
        result = paste0('{"name":"',nx,'","value":',x,'}', collapse = ",")
        result = paste0("[",result,"]")
        # result = paste0('{"',nx,'":',x,'}', collapse = ",")
        # result = paste0("[",result,"]")
    }else{
        result = paste0('"',nx,'":',x, collapse = ",")
        result = paste0("{",result,"}")
    }
    return(result)
}

#' @rdname convert2json
.convert2json.data.frame = function(x, raw=c(), skipNa=TRUE){
    for(col in colnames(x)){
        if(!col %in% raw) x[,col] = .convert2json(x[,col])
    }
    
    result = apply(x, 1, function(row){
        row = .convert2json(as.list(row), 
                            raw=colnames(x), 
                            skipNa=skipNa)
        return(row)
    })
    
    result = paste0(result, collapse = ",")
    result = paste0("[",result,"]")
    return(result)
}


#' Convert data types in `data.frame(dataType,isList)` to character of NDEx data types
#' 
#' @note Internal function only for convenience
#' @keywords internal
#'
#' @param df data.frame with dataType and isList: `data.frame(dataType,isList)`
#' @param cols named character; column names of dataType and isList in df
#'
#' @return character; NDEx data types (e.g. "string" or "list_of_integer")
#' @name convert-data-types-and-values
#'
#' @examples
#' df = data.frame(dataType=c("string","boolean","double","integer","long",
#'                            "string","boolean","double","integer","long"),
#'                 isList=c(FALSE,FALSE,FALSE,FALSE,FALSE,
#'                          TRUE,TRUE,TRUE,TRUE,TRUE))
#' df$value = list("string",TRUE,3.14,314,314,
#'                 c("str","ing"),c(TRUE,FALSE),c(3.14,1.0),c(314,666),c(314,666))
#' RCX:::.convertDataTypes(df)
#' RCX:::.convertValues(df)
.convertDataTypes = function(df, cols=c(dataType="dataType", isList="isList")){
    result = df[,cols["dataType"]]
    result = paste0(ifelse(df[,cols["isList"]],"list_of_",""), result)
    return(result)
}

#' @rdname convert-data-types-and-values
.convertValues = function(df, cols=c(value="value", isList="isList")){
    result = vapply(df[,cols["value"]], 
                    function(v){
                        if(is.null(v)){
                            v=""
                        }else{
                            v = .convert2json(v)
                        }
                        v = paste0(v, collapse = ",")
                        return(v)
                    },
                    character(1))
    result = ifelse(df[,cols["isList"]], paste0("[",result,"]"), result)
    return(result)
}


#' Convert a list of vectors to a character vector with pasted elements
#' 
#' @note Internal function only for convenience
#' @keywords internal
#'
#' @param l unnamed list
#' @param keepNa logical; whether to keep `NA` values or replace it with an empty list
#'
#' @return character
#'
#' @examples
#' l  = list(NA,c(2,3), 5)
#' RCX:::.convertRawList(l)
.convertRawList = function(l, keepNa=TRUE){
    result = NULL
    if(!is.null(l)){
        result = vapply(l, 
                        function(v){
                            if((length(v)==1)&&(is.na(v))){
                                if(!keepNa){
                                    v = "[]"
                                }else{
                                    v = as.character(NA)
                                }
                            }else{
                                v = .convert2json(v)
                                v = paste0(v, collapse = ",")
                                v = paste0("[",v,"]")
                            } 
                            return(v)
                        },
                        character(1))
    }
    return(result)
}


#' Rename data.frame columns by key-value pairs in rnames
#' 
#' @note Internal function only for convenience
#' @keywords internal
#'
#' @param df data.frame
#' @param rnames named character vector; `names(rnames)=colnames(df)`
#'
#' @return df with new colnames; or NULL on error
#'
#' @examples
#' nodes = data.frame(id=c(0,1,2),
#'                    name=c("CDK1",NA,"CDK3"),
#'                    represents=c(NA,"bla",NA))
#' rnames = c(id="@id", name="n", represents="r")
#' RCX:::.renameDF(nodes, rnames)
.renameDF = function(df, rnames) {
    if(!is.data.frame(df)) return(NULL)
    dfNames = colnames(df)
    colnames(df) = vapply(dfNames, 
                          function(n){
                              if(n %in% names(rnames)) n = rnames[n]
                              return(n)
                          },
                          character(1))
    return(df)
}


