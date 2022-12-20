#' Aspect for tracking the differences of two RCX-objects
#' 
#' @details 
#' The left and right \code{\link{RCX-object}} are compared regarding the differences of the node, nodeAttributes, edges, edgeAttributes, and networkAttributes.
#' 
#' Two nodes are equal when their names/represents (depending on *matchByName*) are equal. 
#' The networkDifferences can only be created if the RCX-objects have names for their nodes (if *matchByName* `TRUE`) or
#' represents for their nodes (if *matchByName* `FALSE`).
#' The columns for the the nodes-dataframe are: (*matchByName* `TRUE`) id, name, representLeft, representRight, oldIdLeft, oldIdRight, belongsToLeft, belongsToRight,
#' (*matchByName* `FALSE`) id, nameLeft, nameRight, represent, oldIdLeft, oldIdRight, belongsToLeft, belongsToRight.
#' The ids start at zero and each node is assigned a new id.
#' 
#' Two nodeAttributes are equal if they belong to the same node name / represent (depending on *matchByName*-boolean) and if the names are written the same.
#' The columns for the nodeAttributes-dataframe are: propertyOf, name, belongsToLeft, belongsToRight, dataTypeLeft, dataTypeRight, isListLeft, isListRight, valueLeft, valueRight.
#' 
#' Two edges are equal if their sources and targets are equal (names/represents depending on *matchByName*) and if their interactions are equal or both interactions do not have a value (NA-value). 
#' The edges are undirected that means that the source and target can be switched, more precisely the edges e1=(s, t) and e2=(t,s) would be equal.
#' If one interaction has no value (NA) and the other interaction has a value, the edges are different.
#' The columns for the edge-dataframe are: id, source, target, interaction, oldIdLeft, oldIdRight, belongsToLeft, belongsToRight.
#' The ids start to ascend from zero.
#' 
#' Two edgeAttributes are equal if they belong to the same edge and if the names of the edgeAttributes are equal.
#' The columns for the edgeAttributes-dataframe are: propertyOf, name, belongsToLeft, belongsToRight, dataTypeLeft, dataTypeRight, isListLeft, isListRight, valueLeft, valueRight.
#' 
#' Two networkAttributes are equal if the names are equal.
#' The columns for the networkAttributes-dataframe are: name, belongsToLeft, belongsToRight, dataTypeLeft, dataTypeRight, isListLeft, isListRight, valueLeft, valueRight.
#' 
#' @param left \code{\link{RCX-object}} that is compared with the right network
#' @param right \code{\link{RCX-object}} that is compared with the left network
#' @param matchByName logical (optional default value `TRUE`); if *matchByName* is `TRUE`, two nodes are equal when their names are equal, 
#' if *matchByName* is `FALSE`, two nodes are equal when their represents are equal.
#'
#' @return list-object that consists of the *matchByName-boolean* and five dataframes for the differences of the tracked aspects
#' 
#' @note The execution of the function is interrupted and a warning message is displayed if *matchByName* is `TRUE` and one or both networks do not have names for their nodes.
#' It works analogously if *matchByName* is `FALSE` and one or both networks do not have represents for their nodes. 
#' 
#' @importFrom RCX Defaults
#' 
#' @name createNetworkDifferences
#' @export
compareNetworks = function(left=NULL, right=NULL, matchByName=TRUE) {
    ## Stop if the network cannot be created.
    if (matchByName && (length(left$nodes$name)==0 || length(right$nodes$name)==0))  {
        stop('Both networks need names for matchByName')
    }  
    if (!matchByName && (length(left$nodes$represent)==0 || length(right$nodes$represent)==0))  {
        stop('Both networks need represents for matchByRepresent')
    }  
    #---Create result network---------------------------------------------------
    resultRCX <- createRCX(nodes = left$nodes, edges = left$edges)
    resultRCX <- updateNodes(resultRCX, nodes = right$nodes)
    # Update propertyOf from the right network
    if (length(right$nodeAttributes$propertyOf) > 0) {
        rightNodeAttrUpdated <- right$nodeAttributes
        rightNodes <- resultRCX$nodes[!is.na(resultRCX$nodes$oldId),]
        for (i in c(1:nrow(rightNodeAttrUpdated))) {
            #get new node id
            newId = rightNodes[rightNodes$oldId == rightNodeAttrUpdated[i,]$propertyOf,]$id
            rightNodeAttrUpdated[i,]$propertyOf = newId
        }
    }
    # Update the source and target of the right networks
    rightEdgesUpdated <- right$edges
    for (i in c(1:nrow(rightEdgesUpdated))) {
        newSource = rightNodes[rightNodes$oldId == rightEdgesUpdated[i,]$source,]$id
        rightEdgesUpdated[i,]$source = newSource
        newTarget = rightNodes[rightNodes$oldId == rightEdgesUpdated[i,]$target,]$id
        rightEdgesUpdated[i,]$target = newTarget
    }
    resultRCX <- updateEdges(resultRCX, edges = rightEdgesUpdated, keepOldIds = TRUE)
    # Update propertyOf from the right network
    if (length(right$edgeAttributes$propertyOf) > 0) {
        rightEdgeAttrUpdated <- right$edgeAttributes
        rightEdges <- resultRCX$edges[!is.na(resultRCX$edges$oldId),]
        for (i in c(1:nrow(rightEdgeAttrUpdated))) {
            #get new node id
            newId = rightEdges[rightEdges$oldId == rightEdgeAttrUpdated[i,]$propertyOf,]$id
            rightEdgeAttrUpdated[i,]$propertyOf = newId
        }
    }
    resultRCX$edges$oldId[c(1:length(left$edges$id))] <- left$edges$id
    # Add the old ids from the left network
    resultRCX$nodes$oldId[c(1:length(left$nodes$id))] <- left$nodes$id
    if (length(right$nodeAttributes$propertyOf) > 0) {
        resultRCX <- updateNodeAttributes(resultRCX, nodeAttributes = rbind(left$nodeAttributes, rightNodeAttrUpdated))
    }
    if (length(right$edgeAttributes$propertyOf) > 0) {
        resultRCX <- updateEdgeAttributes(resultRCX, edgeAttributes = rbind(left$edgeAttributes, rightEdgeAttrUpdated))
    }
    #---NODES-----------------------------------------------------------------------
    ## Check if both networks have nodes
    if (length(left$nodes$id)==0 || length(right$nodes$id)==0) {
        stop('NetworkDifferences cannot be created when one network does not have nodes')
    }
    ## Create result dataframe for the nodes.
    ## Dataframe is changed later, if matchByName=TRUE "represent" is named representLeft" and the column "representRight" is added in order to track 
    ## different represents with same name (analogously with matchByRepresents and names)
    nodes = data.frame(
        id = c(0:(length(left$nodes$id)-1)), 
        name = rep(NA, length(left$nodes$id)),
        represent = rep(NA, length(left$nodes$id)),
        oldIdLeft = left$nodes$id,
        oldIdRight = rep(NA, length(left$nodes$id)),
        belongsToLeft = rep(TRUE, length(left$nodes$id)),
        belongsToRight = rep(FALSE, length(left$nodes$id))
    )
    
    ## Check if matchByName is TRUE
    if (matchByName) {
        ## The left network has names and the name column can be initialized
        nodes$name <- left$nodes$name
        
        ## Check if the left and right networks have represents
        existRepresentLeft = FALSE
        if (length(left$nodes$represent) > 0) {
            nodes$represent <- left$nodes$represent
            existRepresentLeft = TRUE
        }
        existRepresentRight = FALSE
        if (length(right$nodes$represent) > 0) {
            existRepresentRight = TRUE
        }
        
        ## Rename "represent" to "representLeft"
        names(nodes)[names(nodes) == 'represent'] <- 'representLeft'
        ## Add additional column "representRight"
        nodes$representRight <- rep(NA, length(left$nodes$id))
        nodes <- nodes[, c("id", "name", "representLeft", "representRight", "oldIdLeft", "oldIdRight", "belongsToLeft", "belongsToRight")]
        
        ## Iterate through all names of nodes in right and check if this name already exists in the dataframe and if not add a new row
        for (node in right$nodes$name){
            ## Node name already exists and the values from the right network are added
            if (node %in% nodes$name){
                ## Get the index of the row of the existing node name
                index = match(node, nodes$name)
                nodes$belongsToRight[index] = TRUE
                ## Check if the right network has a represent for the node and if so, add the represent to nodes
                if (existRepresentRight) {
                    nodes$representRight[index] = right$nodes[right$nodes$name == node,]$represent
                }
                ## Add the id the node has in the right network
                nodes$oldIdRight[index] = right$nodes[right$nodes$name == node,]$id
            } 
            ## Node name does not exists and a new row is added
            else { 
                ## Add the id the node has in the right network
                oldIdRight = right$nodes[which(right$nodes$name == node),]$id
                ## Check if the right network has a represent for the node and if so, add the represent to nodes
                represent = NA
                if (existRepresentRight) {
                    represent = right$nodes[right$nodes$id == oldIdRight,]$represent
                }
                ## Add new row
                new_row = c(nrow(nodes), node, NA, represent, NA, oldIdRight, FALSE, TRUE)
                nodes = rbind(nodes, new_row)
            }
        }
    } 
    ## MatchByRepresents
    else { 
        ## The left network has represents for the nodes and that can be added to the dataframe
        nodes$represent <- left$nodes$represent
        
        ## Check if the left and right networks have names for the nodes
        existNameLeft = FALSE
        if (length(left$nodes$name) > 0) {
            nodes$name <- left$nodes$name
            existNameLeft = TRUE
        }
        existNameRight = FALSE
        if (length(right$nodes$name) > 0) {
            existNameRight = TRUE
        }
        
        ## Rename "name" to "nameLeft"
        names(nodes)[names(nodes) == 'name'] <- 'nameLeft'
        ## Add additional column "nameRight"
        nodes$nameRight <- rep(NA, length(left$nodes$id))
        nodes <- nodes[, c("id", "nameLeft", "nameRight", "represent", "oldIdLeft", "oldIdRight", "belongsToLeft", "belongsToRight")]
        
        ## Iterate through all represents of nodes in right and check if this represent already exists in nodes and if not, add a new row
        for (represent in right$nodes$represent){
            ## Node represent already exists and the values from the right network are added
            if (represent %in% nodes$represent){
                ## Get the index of the row of the existing node represent
                index = match(represent, nodes$represent)
                nodes$belongsToRight[index] = TRUE
                ## If the right network has names for the nodes, add the name to nodes
                if (existNameRight) {
                    nodes$nameRight[index] = right$nodes[right$nodes$represent == represent,]$name
                }
                ## Add the id the node has in the right network
                nodes$oldIdRight[index] = right$nodes[right$nodes$represent == represent,]$id
            }
            ## Represent does not exist and a new row is added
            else { 
                oldIdRight = right$nodes[which(right$nodes$represent == represent),]$id
                name = NA
                ## Check if name exists in the right network
                if (existNameRight) {
                    name = right$nodes[which(right$nodes$id == oldIdRight),]$name
                }
                ## Add new row
                new_row = c(nrow(nodes), NA, name, represent, NA, oldIdRight, FALSE, TRUE)
                nodes = rbind(nodes, new_row)
            }
        }
    }
    ## Convert the booleans to strings
    nodes$belongsToLeft <- as.character(nodes$belongsToLeft)
    nodes$belongsToRight <- as.character(nodes$belongsToRight)
    #---NODEATTRIBUTES--------------------------------------------------------------
    ## Create result dataframe for nodeAttributes
    nodeAttributes <- data.frame(matrix(ncol=10, nrow=0))
    colnames(nodeAttributes) <- c("propertyOf", "name", "belongsToLeft", "belongsToRight", "dataTypeLeft", 
                                  "dataTypeRight", "isListLeft", "isListRight", "valueLeft", "valueRight")
    ## Check if there are only nodeAttributes in the left network
    if ((length(left$nodeAttributes$propertyOf) > 0) && (length(right$nodeAttributes$propertyOf) == 0)) {
        ## Initialize the dataframe
        nodeAttributes = data.frame(
            propertyOf = left$nodeAttributes$propertyOf,
            name = left$nodeAttributes$name,
            belongsToLeft = rep(TRUE, length(left$nodeAttributes$propertyOf)),
            belongsToRight = rep(FALSE, length(left$nodeAttributes$propertyOf)),
            dataTypeLeft = left$nodeAttributes$dataType,
            dataTypeRight = rep(NA, length(left$nodeAttributes$propertyOf)),
            isListLeft = left$nodeAttributes$isList,
            isListRight = rep(NA, length(left$nodeAttributes$propertyOf)),
            valueLeft = I(left$nodeAttributes$value),
            valueRight = I(rep(NA, length(left$nodeAttributes$propertyOf)))
        )
        ## Filter from the nodes-dataframe the rows that have a value for oldIdLeft
        nodes_oldIdLeft <- nodes[!is.na(nodes$oldIdLeft),]
        ## Update propertyOf
        for (i in c(1:nrow(nodeAttributes))) {
            row = nodeAttributes[i,]
            nodeAttributes[i,]$propertyOf = nodes_oldIdLeft[which(nodes_oldIdLeft$oldIdLeft==row$propertyOf),]$id
        }
    }
    ## Check if there are only nodeAttributes in the right network
    else if (length(left$nodeAttributes$propertyOf)==0 && length(right$nodeAttributes$propertyOf)>0) {
        ## Initialize dataframe
        nodeAttributes = data.frame(
            propertyOf = right$nodeAttributes$propertyOf,
            name = right$nodeAttributes$name,
            belongsToLeft = rep(FALSE, length(right$nodeAttributes$propertyOf)),
            belongsToRight = rep(TRUE, length(right$nodeAttributes$propertyOf)),
            dataTypeLeft = rep(NA, length(right$nodeAttributes$propertyOf)),
            dataTypeRight = right$nodeAttributes$dataType,
            isListLeft = rep(NA, length(right$nodeAttributes$propertyOf)),
            isListRight = right$nodeAttributes$isList,
            valueLeft = I(rep(NA, length(right$nodeAttributes$propertyOf))),
            valueRight = I(right$nodeAttributes$value)
        )
        ## Filter from the nodes-dataframe the rows that have a value for oldIdRight (not NA)
        nodes_oldIdRight = nodes[!is.na(nodes$oldIdRight),]
        ## Update propertyOf
        for (i in c(1:nrow(nodeAttributes))) {
            row = nodeAttributes[i,]
            nodeAttributes[i,]$propertyOf = nodes_oldIdRight[nodes_oldIdRight$oldIdRight == row$propertyOf,]$id
        }
    } 
    ## Check if both networks have nodeAttributes
    else if ((length(left$nodeAttributes$propertyOf) > 0) && (length(right$nodeAttributes$propertyOf) > 0)) {
        ## Initialize dataframe
        nodeAttributes <- data.frame(
            propertyOf = left$nodeAttributes$propertyOf,
            name = left$nodeAttributes$name,
            belongsToLeft = rep(TRUE, length(left$nodeAttributes$propertyOf)),
            belongsToRight = rep(FALSE, length(left$nodeAttributes$propertyOf)),
            dataTypeLeft = left$nodeAttributes$dataType,
            dataTypeRight = rep(NA, length(left$nodeAttributes$propertyOf)),
            isListLeft = left$nodeAttributes$isList,
            isListRight = rep(NA, length(left$nodeAttributes$propertyOf)),
            valueLeft = I(left$nodeAttributes$value),
            valueRight = I(rep(NA, length(left$nodeAttributes$propertyOf)))
        )
        
        ## Create help-dataframes
        nodes_oldIdRight = nodes[!is.na(nodes$oldIdRight),]
        nodes_oldIdLeft = nodes[!is.na(nodes$oldIdLeft),]
        ## Update propertyOf
        for (i in c(1:nrow(nodeAttributes))) {
            row = nodeAttributes[i,]
            nodeAttributes[i,]$propertyOf = nodes_oldIdLeft[nodes_oldIdLeft$oldIdLeft == row$propertyOf,]$id
        }
        ## MatchByName is TRUE
        if (matchByName) {
            ## Iterate through the nodeAttributes of the right network
            for (i in c(1:nrow(right$nodeAttributes))) {
                nodeAttributeFound = FALSE
                for (j in c(1:nrow(left$nodeAttributes))) {
                    ## Check if the nodeAttribute already exists in nodeAttributes
                    if ((nodes_oldIdRight[(nodes_oldIdRight$oldIdRight == right$nodeAttributes$propertyOf[i]),]$name == 
                         nodes[(nodes$id == nodeAttributes$propertyOf[j]),]$name) &&
                        (right$nodeAttributes$name[i] == nodeAttributes$name[j])) {
                        nodeAttributeFound = TRUE
                        # Add values to nodesAttributes
                        nodeAttributes$dataTypeRight[j] = right$nodeAttributes$dataType[i]
                        nodeAttributes$isListRight[j] = right$nodeAttributes$isList[i]
                        nodeAttributes$valueRight[j] = I(right$nodeAttributes$value[i])
                        nodeAttributes$belongsToRight[j] = TRUE
                    }
                }
                ## Check if the nodeAttribute from the right network does not exist in the nodeAttributes-dataframe
                if (!nodeAttributeFound) {
                    ## Get the new id of the node to which the nodeAttribute belongs
                    new_propertyOf = nodes_oldIdRight[nodes_oldIdRight$oldIdRight == right$nodeAttributes$propertyOf[i],]$id
                    ## Add new row
                    new_row = c(new_propertyOf, right$nodeAttributes$name[i], 
                                FALSE, TRUE, NA, right$nodeAttributes$dataType[i], 
                                NA, right$nodeAttributes$isList[i], NA, list(right$nodeAttributes$value[i]))                   
                    nodeAttributes = rbind(nodeAttributes, new_row)
                }
            }
        } 
        ## MatchByRepresent is set
        else {
            ## Iterate through the nodeAttributes of the right network
            for (i in c(1: length(right$nodeAttributes$propertyOf))) {
                nodeAttributeFound = FALSE
                for (j in c(1: length(nodeAttributes$propertyOf))) {
                    # Check if f the nodeAttribute already exists in nodeAttributes 
                    if ((nodes_oldIdRight[nodes_oldIdRight$oldIdRight == right$nodeAttributes$propertyOf[i],]$represent == 
                         nodes[(nodes$id == nodeAttributes$propertyOf[j]),]$represent) &&
                        (right$nodeAttributes$name[i] == nodeAttributes$name[j])) {
                        nodeAttributeFound = TRUE
                        # Add the values
                        nodeAttributes$dataTypeRight[j] = right$nodeAttributes$dataType[i]
                        nodeAttributes$isListRight[j] = right$nodeAttributes$isList[i]
                        nodeAttributes$valueRight[j] = I(right$nodeAttributes$value[i])
                        nodeAttributes$belongsToRight[j] = TRUE                    
                    }
                }
                ## Check if the nodeAttribute from the right network does not exist in the nodeAttributes-dataframe
                if (!nodeAttributeFound) {
                    ## Get the new id of the node to which the nodeAttribute belongs
                    new_id = nodes[which(nodes$oldIdRight == right$nodeAttributes$propertyOf[i]), 1]
                    ## Add a new row
                    new_row = c(new_id, right$nodeAttributes$name[i], FALSE, TRUE, 
                                NA, right$nodeAttributes$dataType[i], NA, 
                                right$nodeAttributes$isList[i], NA, 
                                list(right$nodeAttributes$value[i]))
                    nodeAttributes = rbind(nodeAttributes, new_row)
                }
            }
        }
    }
    ## Convert the booleans to strings
    nodeAttributes$belongsToLeft <- as.character(nodeAttributes$belongsToLeft)
    nodeAttributes$belongsToRight <- as.character(nodeAttributes$belongsToRight)
    nodeAttributes$isListLeft <- as.character(nodeAttributes$isListLeft)
    nodeAttributes$isListRight <- as.character(nodeAttributes$isListRight)
    ## All values are strings or NA
    nodeAttributes$valueLeft <- as.vector(nodeAttributes$valueLeft,'character')
    nodeAttributes$valueLeft[nodeAttributes$valueLeft == "NA"] <- NA
    nodeAttributes$valueRight <- as.vector(nodeAttributes$valueRight,'character')
    nodeAttributes$valueRight[nodeAttributes$valueRight == "NA"] <- NA
    #---EDGES-----------------------------------------------------------------------
    ## Create result dataframe for edges
    edges <- data.frame(matrix(ncol=8, nrow=0))
    x <- c("id", "source", "target", "interaction", "oldIdLeft", "oldIdRight", "belongsToLeft", "belongsToRight")
    colnames(edges) <- x
    ## Check if only the left networks has edges
    if ((length(left$edges$id) > 0) && (length(right$edges$id) == 0)) {
        ## Initialize the dataframe
        edges <- data.frame(
            id = c(0: (length(left$edges$id) - 1)),
            source = left$edges$source,
            target = left$edges$target,
            interaction = rep(NA, length(left$edges$id)),
            oldIdLeft = left$edges$id,
            oldIdRight = rep(NA, length(left$edges$id)),
            belongsToLeft = rep(TRUE, length(left$edges$id)),
            belongsToRight = rep(FALSE, length(left$edges$id))
        )
        ## Check if the left network has values for the interactions
        if (length(left$edges$interaction) > 0) {
            edges$interaction <- left$edges$interaction
        }
        ## Filter from the nodes-dataframe the rows that have a value for oldIdLeft (not NA)
        nodes_oldIdLeft <- nodes[!is.na(nodes$oldIdLeft),]
        ## Update the ids of the source and target
        for (i in c(1:nrow(edges))) {
            row = edges[i,]
            if (row$belongsToLeft == "TRUE") {
                edges[i,]$source = nodes_oldIdLeft[nodes_oldIdLeft$oldIdLeft == row$source,]$id
                edges[i,]$target = nodes_oldIdLeft[nodes_oldIdLeft$oldIdLeft == row$target,]$id
            }
        }
    }
    ## Check if only the right networks has edges
    else if ((length(left$edges$id) == 0) && (length(right$edges$id) > 0)) {
        ## Initialize the dataframe
        edges <- data.frame(
            id = c(0: (length(right$edges$id) - 1)),
            source = right$edges$source,
            target = right$edges$target,
            interaction = rep(NA, length(right$edges$id)),
            oldIdLeft = rep(NA, length(right$edges$id)),
            oldIdRight = right$edges$id,
            belongsToLeft = rep(FALSE, length(right$edges$id)),
            belongsToRight = rep(TRUE, length(right$edges$id))
        )
        ## If the right network has values for interaction, initialize the interaction column with them 
        if (length(right$edges$interaction) > 0) {
            edges$interaction <- right$edges$interaction
        }
        ## Filter from the nodes-dataframe the rows that have a value for oldIdRight (not NA)
        nodes_oldIdRight = nodes[!is.na(nodes$oldIdRight),]
        ## Update source and target ids
        for (i in c(1:nrow(edges))) {
            row = edges[i,]
            if (row$belongsToRight == "TRUE") {
                ## set the new ids for source and targets
                edges[i,]$source = nodes_oldIdRight[nodes_oldIdRight$oldIdRight == row$source,]$id
                edges[i,]$target = nodes_oldIdRight[nodes_oldIdRight$oldIdRight == row$target,]$id
            }
        }
    } 
    ## Check if both networks have edges
    else if ((length(left$edges$id) > 0) && (length(right$edges$id) > 0)) {
        ## Initialize the dataframe
        edges = data.frame(
            id = c(0: (length(left$edges$id) - 1)),
            source = left$edges$source,
            target = left$edges$target,
            interaction = rep(NA, length(left$edges$id)),
            oldIdLeft = left$edges$id,
            oldIdRight = rep(NA, length(left$edges$id)),
            belongsToLeft = rep(TRUE, length(left$edges$id)),
            belongsToRight = rep(FALSE, length(left$edges$id))
        )
        ## Check if the left network has values for the interaction and if so add them to the column interaction
        existInteractionLeft = FALSE
        if (length(left$edges$interaction) > 0) {
            edges$interaction = left$edges$interaction
            existInteractionLeft = TRUE
        }
        ## Check if the right network has values for the interaction
        existInteractionRight = FALSE
        if (length(right$edges$interaction) > 0) {
            existInteractionRight = TRUE
        }
        
        ## Filter from the nodes-dataframe the rows that have a value for oldIdLeft (not NA)
        nodes_oldIdLeft = nodes[!is.na(nodes$oldIdLeft),]
        ## Update the ids for source and targets
        for (i in c(1:nrow(edges))) {
            row = edges[i,]
            if (row$belongsToLeft == "TRUE") {
                edges[i,]$source = nodes_oldIdLeft[nodes_oldIdLeft$oldIdLeft == row$source,]$id
                edges[i,]$target = nodes_oldIdLeft[nodes_oldIdLeft$oldIdLeft == row$target,]$id
            }
        }
        ## matchByName is set
        if (matchByName) {
            ## Iterate through edges in the right dataframe
            for (i in 1:length(right$edges$id)){
                edgeFound = FALSE
                ## Iterate through the edges in the edges-dataframe
                for (j in 1:length(left$edges$id)) {
                    ## Check if the edges share the same source and target names and the same interaction
                    if ((left$nodes[left$nodes$id == left$edges$source[j],]$name == right$nodes[right$nodes$id == right$edges$source[i],]$name && 
                         left$nodes[left$nodes$id == left$edges$target[j],]$name == right$nodes[right$nodes$id == right$edges$target[i],]$name) ||
                        (left$nodes[left$nodes$id == left$edges$target[j],]$name == right$nodes[right$nodes$id == right$edges$source[i],]$name &&
                         left$nodes[left$nodes$id == left$edges$source[j],]$name == right$nodes[right$nodes$id == right$edges$target[i],]$name)) {
                        ## If only one interaction has no value, the edges are not equal
                        if (existInteractionLeft && existInteractionRight && xor(is.na(left$edges$interaction[j]), is.na(right$edges$interaction[i]))) {
                            next
                        }
                        ## Check if the edge already exists in the edges-dataframe
                        if ((left$edges$interaction[j] == right$edges$interaction[i]) || identical(left$edges$interaction[j], right$edges$interaction[i])) {
                            edges$belongsToRight[j] = TRUE
                            edges$oldIdRight[j] = right$edges[i,]$id
                            edgeFound = TRUE
                        }
                    } 
                }
                ## The edge does not exist in the edges-dataframe
                if (!edgeFound) {
                    ## Get the new id for the source
                    s_name = right$nodes[right$nodes$id == right$edges$source[i],]$name
                    s_new_id = nodes[nodes$name == s_name,]$id
                    ## Get the new id for the target
                    t_name = right$nodes[right$nodes$id == right$edges$target[i],]$name
                    t_new_id = nodes[nodes$name == t_name,]$id
                    interaction = NA
                    ## Check if the right network has values for interaction
                    if (existInteractionRight) {
                        interaction = right$edges$interaction[i]
                    }
                    ## Add new row
                    new_row = c(nrow(edges),  s_new_id, t_new_id, interaction, NA, right$edges$id[i], FALSE, TRUE)
                    edges = rbind(edges, new_row)
                }
            }
        } 
        # MatchByRepresent is set
        else {
            ## Iterate through the edges in the right dataframe
            for (i in 1:length(right$edges$id)){
                edgeFound = FALSE
                for (j in 1:length(left$edges$id)) { 
                    ## Check if the edges share the same source and target represent and the same interaction
                    if ((left$nodes[left$nodes$id == left$edges$source[j],]$represent == right$nodes[right$nodes$id == right$edges$source[i],]$represent && 
                         left$nodes[left$nodes$id == left$edges$target[j],]$represent == right$nodes[right$nodes$id == right$edges$target[i],]$represent) ||
                        (left$nodes[left$nodes$id == left$edges$target[j],]$represent == right$nodes[right$nodes$id == right$edges$source[i],]$represent &&
                         left$nodes[left$nodes$id == left$edges$source[j],]$represent == right$nodes[right$nodes$id == right$edges$target[i],]$represent)) {
                        ## If only one interaction has no values, the edges are not equal
                        if (!existInteractionLeft || !existInteractionRight || xor(is.na(left$edges$interaction[j]), is.na(right$edges$interaction[i]))) {
                            next
                        }
                        ## The edge already exists in the edges-dataframe
                        edges$belongsToRight[i] = TRUE
                        edges$oldIdRight[i] = right$edges[which(right$edges$id == right$edges$id[i]),]$id
                        edgeFound = TRUE
                    } 
                }
                ## The edge does not exist in the edges-dataframe
                if (!edgeFound) {
                    ## Get the new source id
                    s_rep = right$nodes[right$nodes$id == right$edges$source[i],]$represents
                    s_new_id = nodes[nodes$represent == s_rep,]$id
                    ## Get the new target id
                    t_rep = right$nodes[right$nodes$id == right$edges$target[i],]$represents
                    t_new_id = nodes[nodes$represent== t_rep,]$id
                    interaction = NA
                    ## Check if the right network has values for interaction
                    if (existInteractionRight) {
                        interaction = right$edges$interaction[i]
                    }
                    ## Add new row
                    new_row = c(nrow(edges),  s_new_id, t_new_id, interaction, NA, right$edges$id[i], FALSE, TRUE)
                    edges = rbind(edges, new_row)
                }
            }
        }
    }
    
    #---EDGEATTRIBUTES--------------------------------------------------------------
    ## Create result dataframe
    edgeAttributes <- data.frame(matrix(ncol = 10, nrow = 0))
    x <- c("propertyOf", "name", "belongsToLeft", "belongsToRight", "dataTypeLeft", "dataTypeRight", "isListLeft", "isListRight", "valueLeft", "valueRight")
    colnames(edgeAttributes) <- x
    
    ## Check if there are only edgeAttributes in the left network
    if ((length(left$edgeAttributes$propertyOf) > 0) && (length(right$edgeAttributes$propertyOf) == 0)) {
        ## Initialize the dataframe
        edgeAttributes = data.frame(
            propertyOf = left$edgeAttributes$propertyOf,
            name = left$edgeAttributes$name,
            belongsToLeft = rep(TRUE, length(left$edgeAttributes$propertyOf)),
            belongsToRight = rep(FALSE, length(left$edgeAttributes$propertyOf)),
            dataTypeLeft = left$edgeAttributes$dataType,
            dataTypeRight = rep(NA, length(left$edgeAttributes$propertyOf)),
            isListLeft = left$edgeAttributes$isList,
            isListRight = rep(NA, length(left$edgeAttributes$propertyOf)),
            valueLeft = I(left$edgeAttributes$value),
            valueRight = I(rep(NA, length(left$edgeAttributes$propertyOf)))
        )
        ## Filter from edges the rows that have a value for oldIdLeft
        edges_oldIdLeft = edges[!is.na(edges$oldIdLeft),]
        ## Update propertyOf
        for (i in c(1:nrow(edgeAttributes))) {
            row = edgeAttributes[i,]
            if (row$belongsToLeft == "TRUE") {
                edgeAttributes[i,]$propertyOf = edges_oldIdLeft[edges_oldIdLeft$oldIdLeft == row$propertyOf,]$id
            }
        }
    } 
    ## Check if there are only edgeAttributes in the right network
    else if ((length(left$edgeAttributes$propertyOf) == 0) && (length(right$edgeAttributes$propertyOf) > 0)) {
        ## Initialize the dataframe
        edgeAttributes = data.frame(
            propertyOf = right$edgeAttributes$propertyOf,
            name = right$edgeAttributes$name,
            belongsToLeft = rep(FALSE, length(right$edgeAttributes$propertyOf)),
            belongsToRight = rep(TRUE, length(right$edgeAttributes$propertyOf)),
            dataTypeLeft = rep(NA, length(right$edgeAttributes$propertyOf)),
            dataTypeRight = right$edgeAttributes$dataType,
            isListLeft = rep(NA, length(right$edgeAttributes$propertyOf)),
            isListRight = right$edgeAttributes$isList,
            valueLeft = rep(NA, length(right$edgeAttributes$propertyOf)),
            valueRight = I(right$edgeAttributes$value)
        )
        ## Filter from edges the rows that have a value for oldIdRight
        edges_oldIdRight = edges[!is.na(edges$oldIdRight),]
        ## Update propertyOf
        for (i in c(1:nrow(edgeAttributes))) {
            row = edgeAttributes[i,]
            if (row$belongsToRight == "TRUE") {
                edgeAttributes[i,]$propertyOf = edges_oldIdRight[edges_oldIdRight$oldIdRight == row$propertyOf,]$id
            }
        }
    } 
    ## Check if there are edge Attributes in both networks
    else if ((length(left$edgeAttributes$propertyOf) > 0) && (length(right$edgeAttributes$propertyOf) > 0)) {
        ## Initialize the dataframe
        edgeAttributes = data.frame(
            propertyOf = left$edgeAttributes$propertyOf,
            name = left$edgeAttributes$name,
            belongsToLeft = rep(TRUE, length(left$edgeAttributes$propertyOf)),
            belongsToRight = rep(FALSE, length(left$edgeAttributes$propertyOf)),
            dataTypeLeft = left$edgeAttributes$dataType,
            dataTypeRight = rep(NA, length(left$edgeAttributes$propertyOf)),
            isListLeft = left$edgeAttributes$isList,
            isListRight = rep(NA, length(left$edgeAttributes$propertyOf)),
            valueLeft = I(left$edgeAttributes$value),
            valueRight = I(rep(NA, length(left$edgeAttributes$propertyOf)))
        )
        ## Filter from edges the rows that have a value for oldIdLeft
        edges_oldIdLeft = edges[!is.na(edges$oldIdLeft),]
        ## Update propertyOf
        for (i in c(1:nrow(edgeAttributes))) {
            row = edgeAttributes[i,]
            if (row$belongsToLeft == "TRUE") {
                edgeAttributes[i,]$propertyOf = 
                    edges_oldIdLeft[edges_oldIdLeft$oldIdLeft == row$propertyOf,]$id
            }
        }
        ## Filter from edges the rows that have a value for oldIdRight
        edges_oldIdRight = edges[!is.na(edges$oldIdRight),]
        ## Iterate through the edgeAttributes of the right network
        for (i in c(1: length(right$edgeAttributes$propertyOf))) {
            edgeAttributeFound = FALSE
            ## Iterate through the edgeAttributes-dataframe
            for (j in c(1: length(edgeAttributes$propertyOf))) {
                ## If the edgeAttribute already exists in the edgeAttributes-dataframe, add the values to this row
                if ((edges_oldIdRight[edges_oldIdRight$oldIdRight == right$edgeAttributes$propertyOf[i],]$id == 
                     edges[edges$id == edgeAttributes$propertyOf[j],]$id) &&
                    (right$edgeAttributes$name[i] == edgeAttributes$name[j])) {
                    edgeAttributeFound = TRUE
                    edgeAttributes$dataTypeRight[j] = right$edgeAttributes$dataType[i]
                    edgeAttributes$isListRight[j] = right$edgeAttributes$isList[i]
                    edgeAttributes$valueRight[j] = I(right$edgeAttributes$value[i])
                    edgeAttributes$belongsToRight[j] = TRUE
                }
            }
            ## If the edgeAttributes does not exist in edgeAttributes, a new row is added
            if (!edgeAttributeFound) {
                ## Get new id of propertyOf
                new_id = edges[which(edges$oldIdRight == right$edgeAttributes$propertyOf[i]),]$id
                ## Add new row
                new_row = c(new_id, right$edgeAttributes$name[i], FALSE, TRUE, NA, 
                            right$edgeAttributes$dataType[i], NA, 
                            right$edgeAttributes$isList[i], NA, list(right$edgeAttributes$value[i]))                    
                edgeAttributes = rbind(edgeAttributes, new_row)
            }
        }
    }
    ## convert all booleans to strings
    edgeAttributes$belongsToLeft <- as.character(edgeAttributes$belongsToLeft)
    edgeAttributes$belongsToRight <- as.character(edgeAttributes$belongsToRight)
    edgeAttributes$isListLeft <- as.character(edgeAttributes$isListLeft)
    edgeAttributes$isListRight <- as.character(edgeAttributes$isListRight)
    ## all values are strings or NA
    edgeAttributes$valueLeft <- as.vector(edgeAttributes$valueLeft,'character')
    edgeAttributes$valueLeft[edgeAttributes$valueLeft == "NA"] <- NA
    edgeAttributes$valueRight <- as.vector(edgeAttributes$valueRight,'character')
    edgeAttributes$valueRight[edgeAttributes$valueRight == "NA"] <- NA
    #---NETWORKATTRIBUTES-----------------------------------------------------------
    ## Create result dataframe
    networkAttributes <- data.frame(matrix(ncol = 9, nrow = 0))
    x <- c("name", "belongsToLeft", "belongsToRight", "dataTypeLeft", "dataTypeRight", "isListLeft", "isListRight", "valueLeft", "valueRight")
    colnames(networkAttributes) <- x
    ## Check if there are only networkAttributes in the left network
    if ((length(left$networkAttributes$name) > 0) && (length(right$networkAttributes$name) == 0)) {
        ## Initialize the dataframe
        networkAttributes = data.frame(
            name = left$networkAttributes$name,
            belongsToLeft = rep(TRUE, length(left$networkAttributes$name)),
            belongsToRight = rep(FALSE, length(left$networkAttributes$name)),
            dataTypeLeft = left$networkAttributes$dataType,
            dataTypeRight = rep(NA, length(left$networkAttributes$name)),
            isListLeft = left$networkAttributes$isList,
            isListRight = rep(NA, length(left$networkAttributes$name)),
            valueLeft = sapply(left$networkAttributes$value, `[[`, 1),
            valueRight = rep(NA, length(left$networkAttributes$name))
        )
    } 
    ## Check if there are only networkAttributes in the right network
    else if ((length(left$networkAttributes$name) == 0) && (length(right$networkAttributes$name) > 0)) {
        ## Initialize the dataframe
        networkAttributes = data.frame(
            name = right$networkAttributes$name,
            belongsToLeft = rep(FALSE, length(right$networkAttributes$name)),
            belongsToRight = rep(TRUE, length(right$networkAttributes$name)),
            dataTypeLeft = rep(NA, length(right$networkAttributes$name)),
            dataTypeRight = right$networkAttributes$dataType,
            isListLeft = rep(NA, length(right$networkAttributes$name)),
            isListRight = right$networkAttributes$isList,
            valueLeft = rep(NA, length(right$networkAttributes$name)),
            valueRight = sapply(right$networkAttributes$value, `[[`, 1)
        )
    } 
    ## Check if there are networkAttributes in both networks
    else if (length(left$networkAttributes$name) > 0 && length(right$networkAttributes$name) > 0) {
        ## Initialize the dataframe
        networkAttributes = data.frame(
            name = left$networkAttributes$name,
            belongsToLeft = rep(TRUE, length(left$networkAttributes$name)),
            belongsToRight = rep(FALSE, length(left$networkAttributes$name)),
            dataTypeLeft = left$networkAttributes$dataType,
            dataTypeRight = rep(NA, length(left$networkAttributes$name)),
            isListLeft = left$networkAttributes$isList,
            isListRight = rep(NA, length(left$networkAttributes$name)),
            valueLeft = unlist(left$networkAttributes$value),
            valueRight = rep(NA, length(left$networkAttributes$name))
        )
        ## Iterate through the networkAttributes of the right network
        for (i in 1:nrow(right$networkAttributes)) {
            networkAttributeFound = FALSE
            ## Iterate through the networkAttributes-dataframe
            for (j in 1:nrow(networkAttributes)) {
                ## If the networkAttribute already exists in networkAttributes-dataframe, add the values to this row
                if (right$networkAttributes$name[i] == networkAttributes$name[j]) {
                    networkAttributeFound = TRUE
                    networkAttributes$belongsToRight[j] = TRUE
                    networkAttributes$dataTypeRight[j] = right$networkAttributes$dataType[i]
                    networkAttributes$isListRight[j] = right$networkAttributes$isList[i]
                    networkAttributes$valueRight[j] = right$networkAttributes$value[i]
                }
            }
            ## Add new row
            if (!networkAttributeFound) {
                new_row = c(right$networkAttributes$name[i], FALSE, TRUE, NA, 
                            right$nodeAttributes$dataType[i], NA, right$nodeAttributes$isList[i], 
                            NA, list(right$networkAttributes$value[i]))
                networkAttributes = rbind(networkAttributes, new_row)
            }
        }
    }
    ## convert all booleans to strings
    networkAttributes$belongsToLeft <- as.character(networkAttributes$belongsToLeft)
    networkAttributes$belongsToRight <- as.character(networkAttributes$belongsToRight)
    networkAttributes$isListLeft <- as.character(networkAttributes$isListLeft)
    networkAttributes$isListRight <- as.character(networkAttributes$isListRight)
    ## all values are strings or NA
    networkAttributes$valueLeft <- as.vector(networkAttributes$valueLeft,'character')
    networkAttributes$valueLeft[networkAttributes$valueLeft == "NA"] <- NA
    networkAttributes$valueRight <- as.vector(networkAttributes$valueRight,'character')
    networkAttributes$valueRight[networkAttributes$valueRight == "NA"] <- NA
    
    #---CREATE RESULT---------------------------------------------------------------
    ## Create list
    netDiff = list("matchByName" = matchByName, "nodes" = nodes, "nodeAttributes" = nodeAttributes, "edges" = edges, 
                   "edgeAttributes" = edgeAttributes, "networkAttributes" = networkAttributes)
    class(netDiff) = c(class(netDiff), "NetworkDifferencesAspect")
    resultRCX <- updateNetworkDifferences(resultRCX, netDiff)
    ## Return result
    return(resultRCX)
}

#' Title
#'
#' @param rcx [RCX object] to which the [networkDifferences] aspect is added
#' @param netDif [networkDifferences] aspect
#'
#' @return [RCX object]
#' @export
updateNetworkDifferences = function(rcx, networkDifferences) {
    ## Check the class of the given networkDifferences aspect
    if (class(networkDifferences)[2] != "NetworkDifferencesAspect") {
        stop('aspect must be from the type networkDifferencesAspect')
    }
    rcx$networkDifferences <- networkDifferences
    return(rcx)
}
#' Node-centered \code{\link{RCX-object}} for the differences of two RCX-objects
#' 
#' Creation of a node-centered \code{\link{RCX-object}} with the information of a *networkDifferences*-aspect to visualize 
#' the differences of two RCX-objects.
#' 
#' @details 
#' A \code{\link{RCX-object}} is created with nodes for the node names / node represents (depending on *includeNamesAndRepresents*), 
#' nodes for the names of the nodeAttributes (if *startLayerAttributes* greater than *startLayerLeftRight*), nodes for the values of the nodeAttributes 
#' (if *startLayerValues* is greater than *startLayerAttributes*). The following inequation must be satisfied: 0 < *startLayerBoth* < *startLayerLeftRight* < *startLayerAttributes* < *startLayerValues*.
#' 
#' The networkAttributes are ignored as they are not considered to very important.
#' 
#' Node shape in the visualization: Node name: round, node represent: triangle, name of nodeAttribute: hexagon, value of nodeAttribute: parallelogram.
#' 
#' Color of the network-elements: gray: belongs to both networks, light blue: belongs only to the left network, orange: belongs only to the right network.
#' 
#' If there are edges between two nodes in the left or right RCX-objects, colored edges are defined in the created RCX-object, too, and are labeled with the interaction of the edge.
#' If *includeNamesAndRepresents* is `TRUE`, edges between the nodes for the node and node represent are defined.
#' If nodes for the names of the nodeAttributes are included, edges between these nodes and the node they belong to are defined.
#' If nodes for the values of the nodeAttributes are included, edges between these nodes and the nodes for the names of the nodeAttributes are defined.
#' 
#' @param aspect networkDifferences-aspect; information about the differences of two \code{\link{RCX-object}}
#' @param includeNamesAndRepresents logical (optional, default value `FALSE`); if set to `TRUE` nodes for node names and node represents are created
#' @param dX integer (optional, default value 70); determines the width of the created circles
#' @param dY integer (optional, default value 70); determines the height of the created circles
#' @param startLayerBoth integer (optional, default value 5); determines the layer at which the circles for the nodes that 
#' belong to both RCX-objects start
#' @param startLayerLeftRight integer (optional, default value 10); determines the layer at which the circles for the nodes that belong only 
#' to one RCX-object start
#' @param startLayerAttributes integer (optional, default value 0); if greater than *startLayerLeftRight*, it determines the layer at which 
#' the circles for the names of the nodesAttributes start 
#' @param startLayerValues integer (optional, default value 0); if greater than *startLayerAttributes*, it determines the layer at which 
#' the circle for the values of the nodesAttribute start
#'   
#' @return \code{\link{RCX-object}}
#' 
#' @name exportDifferencesToNodeNetwork
#' @export
exportDifferencesToNodeNetwork = function(aspect, includeNamesAndRepresents=FALSE, dX=70, dY=70, startLayerBoth=5, 
                                          startLayerLeftRight=10, startLayerAttributes=0, startLayerValues=0) {
    ## Check the class of the given networkDifferences aspect
    if (class(aspect)[2] != "NetworkDifferencesAspect") {
        stop('aspect must be from the type networkDifferencesAspect')
    }
    ## Stop the execution of the function is the layer-parameter are not set correctly
    if ((startLayerBoth<=0) || (startLayerLeftRight<=0)) {
        stop('startLayerBoth and startLayerLeftRight must be greater than 0')
    }
    if ((startLayerAttributes<0) || (startLayerValues<0)) {
        stop('startLayerAttributes and startLayerValues must be 0 or positive')
    }
    if (startLayerBoth>startLayerLeftRight) {
        stop('startLayerLeftRight must be greater than startLayerBoth')
    }
    if ((startLayerAttributes>0) && (startLayerAttributes<startLayerLeftRight)) {
        stop('If startLayerAttributes is greater than 0, it must be greater than startLayerLeftRight, too.')
    }
    if ((startLayerAttributes==0) && (startLayerValues>0)) {
        stop('If startLayerValues is greater than 0, then startLayerAttributes must be greater than 0, too')
    }
    if ((startLayerAttributes>startLayerValues) && (startLayerValues!=0)) {
        stop('startLayerValues must be greater than startLayerAttributes')
    } 
    
    ## Create the nodes for the nodes
    nodeDf = as.data.frame(aspect$nodes)
    matchByName = TRUE
    if (aspect$matchByName == "FALSE") {
        matchByName = FALSE
    }
    rcx <- .diffAddNodes(NULL, nodeDf, matchByName, includeNamesAndRepresents)
    
    ## Add edges to network
    offsetEdges = length(rcx$edges$id)
    edgesDf = as.data.frame(aspect$edges)
    ## Check if edges exist in the network
    if (length(edgesDf$id)>0) {
        ## create edges
        edges <- createEdges(
            source = as.integer(edgesDf$source),
            target = as.integer(edgesDf$target),
            interaction = edgesDf$interaction
        )
        rcx <- RCX::updateEdges(rcx, edges)
        ## Values stores if an edge belongsTo the left, right or both networks
        values = c()
        for (i in 1:nrow(edgesDf)) {
            row = edgesDf[i,]
            if ((row$belongsToLeft == "TRUE") && (row$belongsToRight == "TRUE")) {
                values = append(values, "Both")
            } else if(row$belongsToLeft == "TRUE") {
                values = append(values, "Left")
            } else if(row$belongsToRight == "TRUE") {
                values = append(values, "Right")
            }
        }
        ## Create edgeAttributes belongsTo to color if an edge belongsTo the left, right or both networks
        edgeAttributesBelongsTo = RCX::createEdgeAttributes(
            propertyOf = c(offsetEdges: (offsetEdges + length(edgesDf$source) -1)),
            name = rep("belongsTo", length(edgesDf$source)),
            value = values
        )
        rcx <- RCX::updateEdgeAttributes(rcx, edgeAttributesBelongsTo)
    }

    ## NodeAttributes  
    nodeAttrDf = as.data.frame(aspect$nodeAttributes)
    ## Check if nodeAttributes should be included and if nodeAttributes exist
    if ((startLayerAttributes>startLayerLeftRight) && length(nodeAttrDf$propertyOf)>0 && 
        (startLayerValues==0 || startLayerValues>startLayerAttributes)) {
        ## include nodeAttributes with a helper function
        rcx <- .diffAddNodeAttributes(rcx, nodeAttrDf, startLayerValues)
    }
    
    ## Visualization    
    rcx <- .diffAddVisualization(rcx)
    
    ## Layout
    rcx <- RCX::updateCartesianLayout(rcx, .diffSortedLayout(rcx, dX, dY, startLayerBoth, startLayerLeftRight, startLayerAttributes, startLayerValues))
    return(rcx)
}

#' Edge-centered \code{\link{RCX-object}} for the differences of two RCX-objects
#' 
#' Creation of an edge-centered RCX-object with the information of a *networkDifferences*-aspect to visualize 
#' the differences of two RCX-objects.
#' rcxNodeNetwork
#' @details 
#' A \code{\link{RCX-object}} is created with nodes for the edge interaction, nodes for the names of the edgeAttributes 
#' (if *startLayerAttributes* greater than *startLayerLeftRight*), nodes for the values of the edgeAttributes (if *startLayerValues* is greater than *startLayerAttributes*). 
#' The following inequation must be satisfied: 0 < *startLayerBoth* < *startLayerLeftRight* < *startLayerAttributes* < *startLayerValues*.
#'   
#' The networkAttributes are ignored as they are not considered to very important.
#' 
#' Node shape in the visualization: Edge: rectangle, name of edgeAttribute: rectangle with round corner, value of edgeAttribute: diamond.
#' 
#' Color of the network-elements: gray: belongs to both networks, light blue: belongs only to the left network, orange: belongs only to the right network.
#' 
#' If in the left or right RCX-object two edges have a node in common, colored edges are defined in the created RCX-object, 
#' and the edges are labeled with the node names / node represent (depending on *matchByName*).
#' If nodes for the names of the edgeAttributes are included, edges between these nodes and the nodes for the edge they belong to are defined.
#' If nodes for the values of the edgeAttributes are included, edges between these nodes and the nodes for the names of the edgeAttributes are defined.
#' 
#' @param aspect networkDifferences-aspect; information about the differences of two \code{\link{RCX-object}}
#' @param dX integer (optional, default value 70); determines the width of the created circles
#' @param dY integer (optional, default value 70); determines the height of the created circles
#' @param startLayerBoth integer (optional, default value 5); determines the layer at which the circles for the edges that belong to both RCX-object start
#' @param startLayerLeftRight integer (optional, default value 10); determines the layer at which the circles for the nodes that belong only to one RCX-object start
#' @param startLayerAttributes integer (optional, default value 0); if greater than *startLayerLeftRight*, it determines the layer at which 
#' the circles for the names of the nodesAttributes start 
#' @param startLayerValues integer (optional, default value 0); if greater than *startLayerAttributes*, it determines the layer at which 
#' the circle for the values of the nodesAttribute start
#' 
#' @return \code{\link{RCX-object}}
#' 
#' @name exportDifferencesToEdgeNetwork
#' @export
exportDifferencesToEdgeNetwork <- function(aspect=NULL, dX=70, dY=70, startLayerBoth=5, startLayerLeftRight=10, 
                                           startLayerAttributes=0, startLayerValues=0) {
    ## Check the class of the given networkDifferences aspect
    if (class(aspect)[2] != "NetworkDifferencesAspect") {
        stop('aspect must be from the type networkDifferencesAspect')
    }
    ## Stop the execution of the function is the layer-parameter are not set correctly
    if ((startLayerBoth<=0) || (startLayerLeftRight<=0)) {
        stop('startLayerBoth and startLayerLeftRight must be greater than 0')
    }
    if ((startLayerAttributes<0) || (startLayerValues<0)) {
        stop('startLayerAttributes and startLayerValues must be 0 or positive')
    }
    if (startLayerBoth>startLayerLeftRight) {
        stop('startLayerLeftRight must be greater than startLayerBoth')
    }
    if ((startLayerAttributes>0) && (startLayerAttributes<startLayerLeftRight)) {
        stop('If startLayerAttributes is greater than 0, it must be greater than startLayerLeftRight, too.')
    }
    if ((startLayerAttributes==0) && (startLayerValues>0)) {
        stop('If startLayerValues is greater than 0, then startLayerAttributes must be greater than 0, too')
    }
    if ((startLayerAttributes>startLayerValues) && (startLayerValues!=0)) {
        stop('startLayerValues must be greater than startLayerAttributes')
    }  
    
    ## Nodes for the edges are created
    matchByName = TRUE
    if (aspect$matchByName == "FALSE") {
        matchByName = FALSE
    }
    offsetNodes = 0
    ## Dataframe for nodes and edges
    nodeDf = as.data.frame(aspect$nodes)
    edgeDf = as.data.frame(aspect$edges)
    ## helper function to create the nodes for the edges
    rcx <- .diffAddEdges(NULL, edgeDf)
    
    ## Add edges that represent nodes
    ## Values stores if the node (representing the edge) belongs to the left or right network
    values = c()
    ## Iterate through the edge-dataframe and check which edges have a node in common
    for (i in 1:nrow(edgeDf)) {
        for (j in (i+1):nrow(edgeDf)) {
            ## Break condition
            if (j>nrow(edgeDf)) {
                break
            }
            ## Get two edges to check if they have a node in common
            row1 = edgeDf[i,]
            row2 = edgeDf[j,]
            ## Check if the source of the edge in row1 is a node of the edge in row2
            if ((as.integer(row1$source)==as.integer(row2$source)) || as.integer(row1$source)==as.integer(row2$target)) {
                node = as.integer(row1$source)
                rowNode = nodeDf[nodeDf$id==node,]
                ## Set the interaction depending on the matchByName-boolean
                if (aspect[1]=="TRUE") {
                    rcx = updateEdges(rcx, createEdges(source = as.integer(row1$id), target = as.integer(row2$id), interaction = rowNode$name))
                } else {
                    rcx = updateEdges(rcx, createEdges(source = as.integer(row1$id), target = as.integer(row2$id), interaction = rowNode$represent))
                }
                ## Add to values if the edge exists in right, left or both networks
                if ((rowNode$belongsToLeft=="TRUE") && (rowNode$belongsToRight=="TRUE")) {
                    values = append(values, "Both")
                } else if (rowNode$belongsToLeft == "TRUE") {
                    values = append(values, "Left")
                } else if (rowNode$belongsToRight == "TRUE") {
                    values = append(values, "Right")
                }
                ## Check if the target of the edge in row1 is a node of the edge in row2
            } else if ((as.integer(row1$target)==as.integer(row2$source)) || (as.integer(row1$target)==as.integer(row2$target))) {
                ## Get the node both edges have in common
                node = as.integer(row1$target)
                rowNode = nodeDf[nodeDf$id==node,]
                ## Set the interaction depending on the matchByName-boolean
                if (aspect[1]=="TRUE") {
                    rcx = updateEdges(rcx, createEdges(source = as.integer(row1$id), target = as.integer(row2$id), interaction = rowNode$name))
                } else {
                    rcx = updateEdges(rcx, createEdges(source = as.integer(row1$id), target = as.integer(row2$id), interaction = rowNode$represent))
                }
                ## Add to values if the node exists in both / left / right network
                if ((rowNode$belongsToLeft=="TRUE") && (rowNode$belongsToRight=="TRUE")) {
                    values = append(values, "Both")
                } else if (rowNode$belongsToLeft=="TRUE") {
                    values = append(values, "Left")
                } else if (rowNode$belongsToRight=="TRUE") {
                    values = append(values, "Right")
                }
            }
        }
    }
    
    ## Set the edgeAttributes to create a color mapping
    edgeAttributesBelongsTo = createEdgeAttributes(
        propertyOf = c(0:(length(values)-1)),
        name = rep("belongsTo", length(values)),
        value = values
    )
    rcx <- updateEdgeAttributes(rcx, edgeAttributesBelongsTo)
    
    ## Add EdgeAttributes if they should be included
    edgeAttrDf = as.data.frame(aspect$edgeAttributes)
    if ((startLayerAttributes>0) && (length(edgeDf$id)>0)) {
        rcx <- .diffAddEdgeAttributes(rcx, edgeAttrDf, startLayerValues = startLayerValues)
    }
    
    ## Add visualization
    rcx <- .diffAddVisualization(rcx)
    
    ## Layout
    rcx <- updateCartesianLayout(rcx, .diffSortedLayout(rcx, dX, dY, startLayerBoth, startLayerLeftRight, startLayerAttributes, startLayerValues))
    return(rcx)
}

#' Node- and edge-centered RCX-object for the differences of two RCX-objects
#' 
#' Creation of a node-centered RCX-object with the information of a *networkDifferences*-aspect to visualize 
#' the differences of two RCX-objects.
#' 
#' @details 
#' A \code{\link{RCX-object}} is created with nodes for the node names / represents (depending on *includeNamesAndRepresents*), 
#' nodes for the edges, nodes for the names of the node- and edgeAttributes (if *startLayerAttributes* greater than *startLayerLeftRight*), nodes for the values of the 
#' node- and edgeAttributes (if *startLayerValues* is greater than *startLayerAttributes*). 
#' 
#' The networkAttributes are ignored as they are not considered to very important.
#' 
#' Node shape in the visualization: Node name: round, node represent: triangle, edge: rectangle, name of nodeAttribute: hexagon, 
#' value of nodeAttribute: parallelogram, name of edgeAttribute: rectangle with round corner, value of edgeAttribute: diamond
#' 
#' Color of the network-elements: light blue: only belongs to the left network, gray: belongs to both networks, orange: belongs only to the right network
#' 
#' If there are edges between two nodes in the left or right RCX-objects, edges between the node for the edge and the nodes that 
#' represent the source / target node are defined.
#' If *includeNamesAndRepresents* is `TRUE`, edges between the nodes for the node and node represent are defined.
#' If nodes for the names of the node- and edgeAttributes are included, edges between these nodes and the node they belong to are defined.
#' If nodes for the values of the node- and edgeAttributes are included, edges between these nodes and the nodes for the names of the 
#' node- and edgeAttributes are defined.
#' 
#' @param aspect networkDifferences-aspect; information about the differences of two RCX-objects
#' @param includeNamesAndRepresents logical (optional, default value `FALSE`); if set to `TRUE`, nodes for node names and 
#' node represents are created
#' @param dX integer (optional, default value 70); determines the width of the created circles
#' @param dY integer (optional, default value 70); determines the height of the created circles
#' @param startLayerBoth integer (optional, default value 5); determines the layer at which the circles for the nodes that 
#' belong to both RCX-objects start
#' @param startLayerLeftRight integer (optional, default value 10); determines the layer at which the circles for the nodes that belong only 
#' to one RCX-object start
#' @param startLayerAttributes integer (optional, default value 0); if greater than *startLayerLeftRight*, it determines the layer at which 
#' the circles for the names of the nodesAttributes start 
#' @param startLayerValues integer (optional, default value 0); if greater than *startLayerAttributes*, it determines the layer at which 
#' the circle for the values of the nodesAttribute start
#'
#' @return \code{\link{RCX-object}}
#' 
#' @name exportDifferencesToNodeEdgeNetwork
#' 
#' @export
exportDifferencesToNodeEdgeNetwork <- function(aspect, includeNamesAndRepresents=FALSE, dX=70, dY=70, startLayerBoth=5, 
                                               startLayerLeftRight=10, startLayerAttributes=0, startLayerValues=0) {
    ## Check the class of the given networkDifferences aspect
    if (class(aspect)[2] != "NetworkDifferencesAspect") {
        stop('aspect must be from the type NetworkDifferencesAspect')
    }
    ## Stop the execution of the function is the layer-parameter are not set correctly
    if ((startLayerBoth<=0) || (startLayerLeftRight<=0)) {
        stop('startLayerBoth and startLayerLeftRight must be greater than 0')
    }
    if ((startLayerAttributes<0) || (startLayerValues<0)) {
        stop('startLayerAttributes and startLayerValues must be 0 or positive')
    }
    if (startLayerBoth>startLayerLeftRight) {
        stop('startLayerLeftRight must be greater than startLayerBoth')
    }
    if ((startLayerAttributes>0) && (startLayerAttributes<startLayerLeftRight)) {
        stop('If startLayerAttributes is greater than 0, it must be greater than startLayerLeftRight, too.')
    }
    if ((startLayerAttributes==0) && (startLayerValues>0)) {
        stop('If startLayerValues is greater than 0, then startLayerAttributes 
             must be greater than 0, too')
    }
    if ((startLayerAttributes>startLayerValues) && (startLayerValues!=0)) {
        stop('startLayerValues must be greater than startLayerAttributes')
    } 
    
    ## Create nodes for the nodes
    nodeDf = as.data.frame(aspect$nodes)
    matchByName = TRUE
    if (aspect$matchByName == "FALSE") {
        matchByName = FALSE
    }
    rcx <- .diffAddNodes(NULL, nodeDf, matchByName, includeNamesAndRepresents)
    ## Save the number of nodes, it is needed later for the edgeAttributes
    numberOfNodes = length(rcx$nodes$id)
    
    ## Create nodes for the edges
    offsetEdges = length(rcx$nodes$id)
    edgeDf = as.data.frame(aspect$edges)
    
    ## Check if edges exist
    if (dim(edgeDf)[1] > 0) {
        ## add nodes for the edges
        rcx <- .diffAddEdges(rcx, edgeDf)
        ## Connect the nodes for the nodes and edges
        for (i in c(1:nrow(edgeDf))) {
            row = edgeDf[i,]
            rcx <- updateEdges(rcx, createEdges(source = c(as.integer(row$source), as.integer(row$target)),
                                                target = c(as.integer(row$id) + offsetEdges, as.integer(row$id) + offsetEdges)))
        }
    }
    
    ## Create nodes for the nodeAttributes
    nodeAttrDf = as.data.frame(aspect$nodeAttributes)
    ## Include the nodes for the nodeAttributes if they should be included
    if ((startLayerAttributes > 0) && (dim(nodeAttrDf)[1] > 0)) {
        rcx <- .diffAddNodeAttributes(rcx, nodeAttrDf, startLayerValues)
    }
    
    ## Create the nodes for the edgeAttributes
    edgeAttrDf = as.data.frame(aspect$edgeAttributes)
    if ((startLayerAttributes > 0) && (dim(edgeAttrDf)[1] > 0)) {
        rcx <- .diffAddEdgeAttributes(rcx, edgeAttrDf, numberOfNodes, startLayerValues)
    }
    
    ## Visualization      
    rcx <- .diffAddVisualization(rcx)
    
    ## Layout
    rcx <- updateCartesianLayout(rcx, .diffSortedLayout(rcx, dX, dY, startLayerBoth, startLayerLeftRight, startLayerAttributes, startLayerValues))
    
    return(rcx)
}
#---HELPER FUNCTIONS TO CREATE RCX-NETWORKS-------------------------------------

#' Helper-function to add nodes to a \code{\link{RCX-object}
#' 
#' Add nodes for nodes names / represents to an existing \code{\link{RCX-object}} that visualizes the differences of two RCX-objects.
#' 
#' @param rcx \code{\link{RCX-object}}; the new created nodes are added to this \code{\link{RCX-object}}
#' @param nodeDf dataframe; contains the information for the added nodes
#' @param matchByName logical (optional, default value `TRUE`); if set to `TRUE`, two nodes are equal when their names are equal, 
#' if set to `FALSE`, two nodes are equal when their represents are equal
#' @param includeNamesAndRepresents logical (optional, default value `FALSE`); if set to `TRUE`, nodes for node names and 
#' node represents are created
#'
#' @return \code{\link{RCX-object}
.diffAddNodes <-function(rcx=NULL, nodeDf=NULL, matchByName=TRUE, includeNamesAndRepresents=FALSE) {
    offsetNodes = 0
    ## Nodes for the names or represents of the nodes depending on the matchByName-boolean are added
    nodeNames = rep(NA, length(nodeDf$id))
    if (matchByName) {
        nodeNames = nodeDf$name
    } else {
        nodeNames = nodeDf$represent
    }
    
    ## Add nodes to the network
    nodes <- RCX::createNodes(
        name = c(nodeNames)
    )
    
    ## Check if a new rcx network has to be created
    if (is.null(rcx)) {
        rcx <- RCX::createRCX(nodes = nodes)
    } else {
        rcx <- RCX::updateNodes(rcx, nodes)
    }
    
    ## Values stores if a node belongs to the left, right or both networks
    values = c()
    for (i in 1:nrow(nodeDf)) {
        row = nodeDf[i,]
        if ((row$belongsToLeft == "TRUE") && (row$belongsToRight == "TRUE")) {
            values = append(values, "Both")
        } else if(row$belongsToLeft == "TRUE") {
            values = append(values, "Left")
        } else if(row$belongsToRight == "TRUE") {
            values = append(values, "Right")
        }
    }
    ## Add the nodeAttribute belongsTo for the color of the node
    nodeAttributesBelongsTo <- RCX::createNodeAttributes(
        propertyOf = nodes$id,
        name = rep("belongsTo", length(nodes$id)),
        value = values
    )
    rcx <- RCX::updateNodeAttributes(rcx, nodeAttributesBelongsTo)
    
    ## Add the nodeAttribute type for the shape of the node
    if (matchByName) {
        nodeAttributesType <- RCX::createNodeAttributes(
            propertyOf = nodes$id,
            name = rep("shape", length(nodes$id)),
            value = rep("NodeName", length(nodes$id))
        )
        rcx <- RCX::updateNodeAttributes(rcx, nodeAttributesType)
        
        ## Add nodeAttribute  size to draw the nodes for the node names bigger
        nodeAttributesType <- RCX::createNodeAttributes(
            propertyOf = nodes$id,
            name = rep("size", length(nodes$id)),
            value = rep("large", length(nodes$id))
        )
        rcx <- RCX::updateNodeAttributes(rcx, nodeAttributesType)
    } 
    ## MatchByRepresent is set
    else {
        ## add nodeAttribute type for the shape of the node
        nodeAttributesType <- RCX::createNodeAttributes(
            propertyOf = nodes$id,
            name = rep("shape", length(nodes$id)),
            value = rep("NodeRepresent", length(nodes$id))
        )
        rcx <- RCX::updateNodeAttributes(rcx, nodeAttributesType)
        
        ## add nodeAttribute size to draw the nodes bigger
        nodeAttributesType <- RCX::createNodeAttributes(
            propertyOf = nodes$id,
            name = rep("size", length(nodes$id)),
            value = rep("large", length(nodes$id))
        )
        rcx <- RCX::updateNodeAttributes(rcx, nodeAttributesType)
    }
    
    ## Check if node names / node represent should be included, too
    if (includeNamesAndRepresents) {
        for (i in 1:nrow(nodeDf)) {
            offset = length(rcx$nodes$id)
            row = nodeDf[i,]
            ## MatchByName is set
            if (matchByName) {
                ## Check if the represent belongs to the left, right or both networks and create edges to the node with the node name they belong to
                if (row$belongsToLeft=="TRUE" && row$belongsToRight=="TRUE" && !is.na(row$representLeft) && !is.na(row$representRight)) { 
                    if (row$representLeft == row$representRight) {
                        rcx <- RCX::updateNodes(rcx, createNodes(name = row$representLeft))
                        rcx <- RCX::updateNodeAttributes(rcx, createNodeAttributes(propertyOf = offset, name = "belongsTo", value = "Both"))                        
                        rcx <- RCX::updateNodeAttributes(rcx, createNodeAttributes(propertyOf = offset, name = "shape", value = "NodeRepresent"))
                        edges <- RCX::createEdges(source = offset, target = as.integer(row$id))
                        rcx <- RCX::updateEdges(rcx, edges)
                    } 
                    else { 
                        rcx <- RCX::updateNodes(rcx, createNodes(name = c(row$representLeft, row$representRight)))
                        rcx <- RCX::updateNodeAttributes(rcx, createNodeAttributes(propertyOf = c(offset, offset + 1), name = rep("belongsTo", 2), value = c("Left", "Right")))
                        rcx <- RCX::updateNodeAttributes(rcx, createNodeAttributes(propertyOf = c(offset, offset + 1), name = rep("shape", 2), value = rep("NodeRepresent", 2)))
                        edges <- RCX::createEdges(source = c(offset, offset + 1), target = c(as.integer(row$id), as.integer(row$id)))
                        rcx <- RCX::updateEdges(rcx, edges)
                    }
                } 
                else if (row$belongsToLeft=="TRUE" && !is.na(row$representLeft)) { 
                    rcx <- RCX::updateNodes(rcx, createNodes(name = row$representLeft))
                    rcx <- RCX::updateNodeAttributes(rcx, createNodeAttributes(propertyOf = offset, name = "belongsTo", value = "Left"))
                    rcx <- RCX::updateNodeAttributes(rcx, createNodeAttributes(propertyOf = offset, name = "shape", value = "NodeRepresent"))
                    edges <- RCX::createEdges(source = as.integer(row$id), target = offset)
                    rcx <- RCX::updateEdges(rcx, edges)
                } 
                else if (row$belongsToRight=="TRUE" && !is.na(row$representRight)) { 
                    rcx <- RCX::updateNodes(rcx, createNodes(name = row$representRight))
                    rcx <- RCX::updateNodeAttributes(rcx, createNodeAttributes(propertyOf = offset, name = "belongsTo", value = "Right"))
                    rcx <- RCX::updateNodeAttributes(rcx, createNodeAttributes(propertyOf = offset, name = "shape", value = "NodeRepresent"))
                    edges <- RCX::createEdges(source = as.integer(row$id), target = offset)
                    rcx <- RCX::updateEdges(rcx, edges)
                }
            } 
            ## MatchByRepresent is set
            else { 
                ## Check if the node name belongs to the left, right or both networks and create edges to the node with the node represent they belong to
                if (row$belongsToLeft=="TRUE" && row$belongsToRight=="TRUE" && !is.na(row$nameLeft) && !is.na(row$nameRight)) { 
                    if (row$nameLeft==row$nameRight) {
                        rcx <- RCX::updateNodes(rcx, createNodes(name = row$nameLeft))
                        rcx <- RCX::updateNodeAttributes(rcx, createNodeAttributes(propertyOf = offset, name = "belongsTo", value = "Both"))                        
                        rcx <- RCX::updateNodeAttributes(rcx, createNodeAttributes(propertyOf = offset, name = "shape", value = "NodeName"))
                        edges <- RCX::createEdges(source = offset, target = as.integer(row$id))
                        rcx <- RCX::updateEdges(rcx, edges)
                    } 
                    else { 
                        rcx <- RCX::updateNodes(rcx, createNodes(name = c(row$nameLeft, row$nameRight)))
                        rcx <- RCX::updateNodeAttributes(rcx, createNodeAttributes(propertyOf = c(offset, offset + 1), name = rep("belongsTo", 2), value = c("Left", "Right")))
                        rcx <- RCX::updateNodeAttributes(rcx, createNodeAttributes(propertyOf = c(offset, offset + 1), name = rep("shape", 2), value = rep("NodeName", 2)))
                        edges <- RCX::createEdges(source = c(offset, offset + 1), target = c(as.integer(row$id), as.integer(row$id)))
                        rcx <- RCX::updateEdges(rcx, edges)
                    }
                } 
                else if (row$belongsToLeft=="TRUE" && !is.na(row$nameLeft)) { 
                    rcx <- RCX::updateNodes(rcx, createNodes(name = row$nameLeft))
                    rcx <- RCX::updateNodeAttributes(rcx, createNodeAttributes(propertyOf = offset, name = "belongsTo", value = "Left"))
                    rcx <- RCX::updateNodeAttributes(rcx, createNodeAttributes(propertyOf = offset, name = "shape", value = "NodeName"))
                    edges <- RCX::createEdges(source = as.integer(row$id), target = offset)
                    rcx <- RCX::updateEdges(rcx, edges)
                } 
                else if (row$belongsToRight=="TRUE" && !is.na(row$nameRight)) {
                    rcx <- RCX::updateNodes(rcx, createNodes(name = row$nameRight))
                    rcx <- RCX::updateNodeAttributes(rcx, createNodeAttributes(propertyOf = offset, name = "belongsTo", value = "Right"))
                    rcx <- RCX::updateNodeAttributes(rcx, createNodeAttributes(propertyOf = offset, name = "shape", value = "NodeName"))
                    edges <- RCX::createEdges(source = as.integer(row$id), target = offset)
                    rcx <- RCX::updateEdges(rcx, edges)
                }
            }
        }
    }
    return(rcx)
}

#' Helper-function to add nodes for the nodeAttributes to a \code{\link{RCX-object}}
#' 
#' Add nodes for nodeAttributes to an existing \code{\link{RCX-object}} that visualizes the differences of two RCX-objects.
#' 
#' @param rcx \code{\link{RCX-object}}; the new created nodes are added to this \code{\link{RCX-object}}
#' @param nodeAttrDf dataframe; contains the information for the added nodes for the names and values of nodeAttributes
#' @param startLayerValues integer (optional, default value 0); if greater than 0, nodes for the values of the nodeAttributes are included
#'
#' @return \code{\link{RCX-object}
.diffAddNodeAttributes <- function(rcx, nodeAttrDf = NULL, startLayerValues=0) {
    ## Define offset
    offsetNodeAttributes = length(rcx$nodes$name)
    ## Add names of nodeAttributes to network
    nodes <- createNodes(
        name = nodeAttrDf$name
    )
    rcx <- updateNodes(rcx, nodes)
    ## Create edges from the nodeAttribute to the node it belongs to
    edges <- createEdges(source = c(offsetNodeAttributes:(offsetNodeAttributes+length(nodeAttrDf$propertyOf)-1)),
                         target = as.integer(nodeAttrDf$propertyOf))
    rcx <- updateEdges(rcx, edges)
    
    ## Store to which network the nodeAttributes belong to with the nodeAttribute called 'belongsTo'
    values = c()
    for (i in 1:nrow(nodeAttrDf)) {
        row = nodeAttrDf[i,]
        if ((row$belongsToLeft == "TRUE") && (row$belongsToRight == "TRUE")) {
            values = append(values, "Both")
        } else if(row$belongsToLeft == "TRUE") {
            values = append(values, "Left")
        } else if(row$belongsToRight == "TRUE") {
            values = append(values, "Right")
        }
    }
    nodeAttrAttributesBelongsTo <- createNodeAttributes(
        propertyOf = c(offsetNodeAttributes: (offsetNodeAttributes + length(nodeAttrDf$propertyOf) - 1)),
        name = rep("belongsTo", length(nodeAttrDf$propertyOf)),
        value = values
    )
    rcx <- updateNodeAttributes(rcx, nodeAttrAttributesBelongsTo)
    
    ## Store that the created nodes represent nodeAttributes
    nodeAttrAttributesType <- createNodeAttributes(
        propertyOf = c(offsetNodeAttributes: (offsetNodeAttributes + length(nodeAttrDf$propertyOf) - 1)),
        name = rep("shape", length(nodeAttrDf$propertyOf)),
        value =  rep("NodeAttribute", length(nodeAttrDf$propertyOf))
    )
    rcx <- updateNodeAttributes(rcx, nodeAttrAttributesType)
    
    ## Nodes for the values of the nodeAttributes
    if (startLayerValues > 0) {
        ## Store for each node to which network it belongs to and create edges to the nodes with the names for the nodeAttributes
        for (i in 1:nrow(nodeAttrDf)) {
            row = nodeAttrDf[i,]
            if ((row$belongsToLeft == "TRUE") && (row$belongsToRight == "TRUE")) { 
                if (identical(toString(row$valueLeft), toString(row$valueRight))) { 
                    rcx <- .addAttributes(rcx, offset = offsetNodeAttributes + i, nodeName = row$valueLeft, belongsTo = "Both", shape = "NodeAttributeValue", type = "noSharedValue")
                } else {
                    rcx <- .addAttributes(rcx, offset = offsetNodeAttributes + i, nodeName = row$valueLeft, belongsTo = "Left", shape = "NodeAttributeValue", type = "sharedValue")
                    rcx <- .addAttributes(rcx, offset = offsetNodeAttributes + i, nodeName = row$valueRight, belongsTo = "Right", shape = "NodeAttributeValue", type = "sharedValue")
                }
            } else if(row$belongsToLeft == "TRUE") {
                rcx <- .addAttributes(rcx, offset = offsetNodeAttributes + i, nodeName = row$valueLeft, belongsTo = "Left", shape = "NodeAttributeValue", type = "noSharedValue")
            } else if(row$belongsToRight == "TRUE") {
                rcx <- .addAttributes(rcx, offset = offsetNodeAttributes + i, nodeName = row$valueRight, belongsTo = "Right", shape = "NodeAttributeValue", type = "noSharedValue")
            }
        }
    }
    return(rcx)
}

#' Helper-function to add nodes for the edges to a \code{\link{RCX-object}}
#' 
#' Add nodes representing edges to an existing \code{\link{RCX-object}} that visualizes the differences of two RCX-objects.
#' 
#' @param rcx \code{\link{RCX-object}}; the new created nodes representing edges are added to this \code{\link{RCX-object}}
#' @param edgeDf dataframe; contains the information for the added nodes for the edges
#' 
#' @return \code{\link{RCX-object}}
.diffAddEdges <- function(rcx=NULL, edgeDf=NULL) {
    ## Define an offset
    offsetEdges = length(rcx$nodes$name)
    
    ## Add nodes for the edges to the network
    edgeNames = rep(edgeDf$interaction)
    nodes <- createNodes(name = c(edgeNames))
    
    ## Check if a new rcx network has to be created
    if (is.null(rcx)) {
        rcx <- createRCX(nodes = nodes)
    } else {
        rcx <- updateNodes(rcx, nodes)
    }
    
    ## Store to which networks the created nodes belong to
    values = c()
    for (i in 1:nrow(edgeDf)) {
        row = edgeDf[i,]
        if ((row$belongsToLeft == "TRUE") && (row$belongsToRight == "TRUE")) {
            values = append(values, "Both")
        } else if(row$belongsToLeft == "TRUE") {
            values = append(values, "Left")
        } else if(row$belongsToRight == "TRUE") {
            values = append(values, "Right")
        }
    }
    nodeAttributesBelongsTo <- createNodeAttributes(
        propertyOf = c(offsetEdges:(offsetEdges+length(edgeDf$id)-1)),
        name = rep("belongsTo", length(nodes$id)),
        value = values
    )
    rcx <- updateNodeAttributes(rcx, nodeAttributesBelongsTo)
    
    ## Add nodeAttribute 'type' to define the shape of the node
    nodeAttributesType = createNodeAttributes(propertyOf = c(offsetEdges:(offsetEdges+length(edgeDf$id)-1)),
                                              name = rep("shape", length(nodes$id)), value = rep("Edge", length(nodes$id))
    )
    rcx <- updateNodeAttributes(rcx, nodeAttributesType)
    
    ## Add nodeAttribute 'size' to draw the nodes for the edges larger
    nodeAttributesType <- createNodeAttributes(propertyOf = c(offsetEdges:(offsetEdges+length(edgeDf$id)-1)),
                                               name = rep("size", length(nodes$id)), value = rep("large", length(nodes$id)))
    rcx <- updateNodeAttributes(rcx, nodeAttributesType)
    return (rcx)
}

#' Helper-function to add nodes for the edgeAttributes to a \code{\link{RCX-object}}
#' 
#' Add nodes for edgeAttributes to an existing \code{\link{RCX-object}} that visualizes the differences of two RCX-objects.
#' 
#' @param rcx \code{\link{RCX-object}}; the new created nodes are added to this \code{\link{RCX-object}}
#' @param nodeAttrDf dataframe; contains the information for the added nodes for the names and values of edgeAttributes
#' @param numberOfNodes integer (optional, default value 0); parameter to know at which id the nodes for the edges start (needed for the function *rcxNodeEdgeNetwork*)
#' @param startLayerValues integer (optional, default value 0); if greater than 0, nodes for the values of the edgeAttributes are included
#'
#' @return \code{\link{RCX-object}}
.diffAddEdgeAttributes <- function(rcx, edgeAttrDf=NULL, numberOfNodes=0, startLayerValues=0) {
    ## Define an offset
    offsetEdgeAttributes = length(rcx$nodes$id)
    
    ## Add name of the edgeAttributes to network
    edgeAttributes <- RCX::createNodes(
        name = edgeAttrDf$name
    )
    rcx <- RCX::updateNodes(rcx, edgeAttributes)
    
    ## Store to which network the edgeAttribute belongs to
    values = c()
    for (i in 1:nrow(edgeAttrDf)) {
        row = edgeAttrDf[i,]
        if ((row$belongsToLeft == "TRUE") && (row$belongsToRight == "TRUE")) {
            values = append(values, "Both")
        } else if(row$belongsToLeft == "TRUE") {
            values = append(values, "Left")
        } else if(row$belongsToRight == "TRUE") {
            values = append(values, "Right")
        }
    }
    edgeAttrAttributesBelongsTo <- RCX::createNodeAttributes(propertyOf = c(offsetEdgeAttributes:(offsetEdgeAttributes+length(edgeAttrDf$propertyOf)-1)),
                                                        name = rep("belongsTo", length(edgeAttrDf$propertyOf)), value = values)
    rcx <- RCX::updateNodeAttributes(rcx, edgeAttrAttributesBelongsTo)
    
    ## NodeAttribute 'type' stores that the created nodes represent edgeAttributes
    edgeAttrAttributesType <- RCX::createNodeAttributes(propertyOf = c(offsetEdgeAttributes:(offsetEdgeAttributes+length(edgeAttrDf$propertyOf)-1)),
                                                   name = rep("shape", length(edgeAttrDf$propertyOf)), value =  rep("EdgeAttribute", length(edgeAttrDf$propertyOf))
    )
    rcx <- RCX::updateNodeAttributes(rcx, edgeAttrAttributesType)
    
    ## Create edges from the edgeAttribute to the node it belongs to
    edges <- RCX::createEdges(source = c(offsetEdgeAttributes:(offsetEdgeAttributes+length(edgeAttrDf$propertyOf)-1)),
                         target = as.integer(edgeAttrDf$propertyOf)+rep(numberOfNodes, length(edgeAttrDf$propertyOf))
    )
    rcx <- RCX::updateEdges(rcx, edges)
    
    ## Create the nodes with the values for the edgeAttributes
    if (startLayerValues > 0) {
        ## Store for each node to which network it belongs to and create an edge to the node with the name of the edgeAttribute
        for (i in 1:nrow(edgeAttrDf)) {
            row = edgeAttrDf[i,]
            if ((row$belongsToLeft == "TRUE") && (row$belongsToRight == "TRUE")) { 
                if (identical(toString(row$valueLeft), toString(row$valueRight))) { 
                    rcx <- .addAttributes(rcx, offset = offsetEdgeAttributes + i, nodeName = row$valueLeft, belongsTo = "Both", shape = "EdgeAttributeValue", type = "noSharedValue")
                } else { 
                    rcx <- .addAttributes(rcx, offset = offsetEdgeAttributes + i, nodeName = row$valueLeft, belongsTo = "Left", shape = "EdgeAttributeValue", type = "sharedValue")
                    rcx <- .addAttributes(rcx, offset = offsetEdgeAttributes + i, nodeName = row$valueRight, belongsTo = "Right", shape = "EdgeAttributeValue", type = "sharedValue")
                }
            } else if(row$belongsToLeft == "TRUE") { 
                rcx <- .addAttributes(rcx, offset = offsetEdgeAttributes + i, nodeName = row$valueLeft, belongsTo = "Left", shape = "EdgeAttributeValue", type = "noSharedValue")
            } else if(row$belongsToRight == "TRUE") { 
                rcx <- .addAttributes(rcx, offset = offsetEdgeAttributes + i, nodeName = row$valueRight, belongsTo = "Right", shape = "EdgeAttributeValue", type = "noSharedValue")
            }
        }
    }
    return(rcx)
}

.addAttributes <- function(rcx, offset, nodeName, belongsTo, shape, type) {
    rcx <- RCX::updateNodes(rcx, createNodes(name = nodeName))
    rcx <- RCX::updateNodeAttributes(rcx, createNodeAttributes(propertyOf = rep(length(rcx$nodes$name) - 1, 3), name = c("belongsTo", "shape", "type"), value = c(belongsTo, shape, type)))                     
    rcx <- RCX::updateEdges(rcx, createEdges(source = offset - 1, target = length(rcx$nodes$name) - 1))
    return(rcx)
}

#' Helper-function to define the visualization for the \code{\link{RCX-object}}
#' 
#' Add layout to an existing \code{\link{RCX-object}} to visualize the differences of two RCX-objects.
#' 
#' @details Node shape in the visualization: Node name: round, node represent: triangle, edge: rectangle, name of nodeAttribute: hexagon, 
#' value of nodeAttribute: parallelogram, name of edgeAttribute: rectangle with round corner, value of edgeAttribute: diamond
#' Color of the network-elements: gray: belongs to both networks, light blue: belongs only to the left network, orange: belongs only to the right network
#' 
#' @param rcx \code{\link{RCX-object}}; the new created nodes are added to this \code{\link{RCX-object}}
#' 
#' @return \code{\link{RCX-object}}

.diffAddVisualization <- function(rcx) {
    ## Set the network properties
    cyVisualPropertyPropertiesNetwork <- createCyVisualPropertyProperties(
        name = c(
            "NETWORK_BACKGROUND_PAINT",
            "NETWORK_EDGE_SELECTION",
            "NETWORK_NODE_SELECTION"
        ),
        value = c(
            "#FFFFFF",
            "true",
            "true"
        )
    )
    cyVisualPropertyNetwork <- createCyVisualProperty(
        properties = cyVisualPropertyPropertiesNetwork
    )
    
    ## Set the node properties
    cyVisualPropertyPropertiesNodes <- createCyVisualPropertyProperties(
        name = c(
            "NODE_BORDER_PAINT",
            "NODE_BORDER_STROKE",
            "NODE_BORDER_TRANSPARENCY",
            "NODE_BORDER_WIDTH",
            "NODE_DEPTH",
            "NODE_FILL_COLOR",
            "NODE_HEIGHT",
            "NODE_LABEL_COLOR",
            "NODE_LABEL_FONT_FACE",
            "NODE_LABEL_FONT_SIZE",
            "NODE_LABEL_POSITION",
            "NODE_LABEL_TRANSPARENCY",
            "NODE_LABEL_WIDTH",
            "NODE_PAINT",
            "NODE_SELECTED",
            "NODE_SELECTED_PAINT",
            "NODE_SHAPE",
            "NODE_SIZE",
            "NODE_TRANSPARENCY",
            "NODE_VISIBLE",
            "NODE_WIDTH"
        ),
        value = c(
            "#CCCCCC",
            "SOLID",
            "255",
            "0.0",
            "0.0",
            "#D0D0D0",
            "40.0",
            "#000000",
            "SansSerif.plain,plain,12",
            "14",
            "C,C,c,0.00,0.00",
            "255",
            "200.0",
            "#1E90FF",
            "false",
            "#FFFF00",
            "ROUND",
            "35.0",
            "255",
            "true",
            "40.0"
        )
    )
    ## Set the node dependencies
    cyVisualPropertyDependenciesNodes <- createCyVisualPropertyDependencies(
        name = c(
            "nodeCustomGraphicsSizeSync",
            "nodeSizeLocked"
        ),
        value = c(
            "true",
            "false"
        )
    )
    ## Set the node mapping (visualization of the nodeAttributes)
    cyVisualPropertyMappingNodes <- createCyVisualPropertyMappings(
        name=c(
            "NODE_FILL_COLOR",
            "NODE_LABEL",
            "NODE_SHAPE",
            "NODE_HEIGHT",
            "NODE_WIDTH"
        ),
        type = c(
            "DISCRETE",
            "PASSTHROUGH",
            "DISCRETE",
            "DISCRETE",
            "DISCRETE"
        ),
        definition = c(
            paste0("COL=belongsTo,T=string,",
                   "K=0=Left,V=0=#AACCFF,",
                   "K=1=Right,V=1=#FFDD99,",
                   "K=2=Both,V=2=#BBBBBB"),
            paste0("COL=name,T=string"),
            paste0("COL=shape,T=string,",
                   "K=0=NodeName,V=0=ROUND,",
                   "K=1=NodeRepresent,V=1=TRIANGLE,",
                   "K=2=NodeAttribute,V=2=HEXAGON,",
                   "K=3=EdgeAttribute,V=3=ROUND_RECTANGLE,",
                   "K=4=EdgeAttributeValue,V=4=DIAMOND,",
                   "K=5=NodeAttributeValue,V=5=PARALLELOGRAM,",
                   "K=6=Edge,V=6=RECTANGLE"),
            paste0("COL=size,T=string,",
                   "K=0=large,V=0=55.0"),
            paste0("COL=size,T=string,",
                   "K=0=large,V=0=55.0")
        )
    )
    ## Set the edge properties
    cyVisualPropertyPropertiesEdges <- createCyVisualPropertyProperties(
        name = c(
            "EDGE_CURVED",
            "EDGE_LINE_TYPE",
            "EDGE_UNSELECTED_PAINT",
            "EDGE_SELECTED",
            "EDGE_SELECTED_PAINT",
            "EDGE_SOURCE_ARROW_SELECTED_PAINT",
            "EDGE_SOURCE_ARROW_SHAPE",
            "EDGE_SOURCE_ARROW_SIZE",
            "EDGE_SOURCE_ARROW_UNSELECTED_PAINT",
            "EDGE_STROKE_SELECTED_PAINT",
            "EDGE_STROKE_UNSELECTED_PAINT",
            "EDGE_TARGET_ARROW_SELECTED_PAINT",
            "EDGE_TARGET_ARROW_SHAPE",
            "EDGE_TARGET_ARROW_SIZE",
            "EDGE_TARGET_ARROW_UNSELECTED_PAINT",
            "EDGE_TRANSPARENCY",
            "EDGE_VISIBLE"
        ),
        value = c(
            "true",
            "SOLID",
            "#000000",
            "false",
            "#FFFF00",
            "#FFFF00",
            "NONE",
            "6.0",
            "#000000",
            "#FF0000",
            "#848484",
            "#FFFF00",
            "NONE",
            "6.0",
            "#000000",
            "255",
            "true"
        )
    )
    ## Set the edge dependencies
    cyVisualPropertyDependenciesEdges <- createCyVisualPropertyDependencies(
        name = c(
            "arrowColorMatchesEdge"
        ),
        value = c(
            "true"
        )
    )
    ## Set the edge mappings (visualization of the edgeAttributes)
    cyVisualPropertyMappingEdges <- createCyVisualPropertyMappings(
        name = c(
            "EDGE_UNSELECTED_PAINT",
            "EDGE_LABEL"
        ),
        type = c(
            "DISCRETE",
            "PASSTHROUGH"
        ),
        definition = c(
            paste0("COL=belongsTo,T=string,",
                   "K=0=Left,V=0=#AACCFF,",
                   "K=1=Right,V=1=#FFDD99,",
                   "K=2=Both,V=2=#BBBBBB"),
            paste0("COL=interaction,T=string"))
    )
    ## Create the visual properties
    cyVisualPropertyNodes <- createCyVisualProperty(
        properties = cyVisualPropertyPropertiesNodes,
        mappings = cyVisualPropertyMappingNodes,
        dependencies = cyVisualPropertyDependenciesNodes
    )
    
    cyVisualPropertyEdges <- createCyVisualProperty(
        properties=cyVisualPropertyPropertiesEdges,
        mappings = cyVisualPropertyMappingEdges,
        dependencies = cyVisualPropertyDependenciesEdges
    )
    
    cyVisualProperties <- createCyVisualProperties(
        network = cyVisualPropertyNetwork,
        defaultNodes = cyVisualPropertyNodes,
        defaultEdges = cyVisualPropertyEdges
    )
    
    rcx <- updateCyVisualProperties(rcx, cyVisualProperties)
    return(rcx)
}

#' Helper-function to define to node positions for the \code{\link{RCX-object}}
#' 
#' Calculates the position for the nodes of the \code{\link{RCX-object}} to visualize the differences of two RCX-objects.
#' 
#' @details The layout of the \code{\link{RCX-object}} consists of concentric circles. The layers for the nodes / edges that exist in both network
#' are defined through the parameter *startLayerBoth*. The layers for the nodes / edges that exist only in one network are defined through the parameter
#' *startLayerLeftRight*. If *startLayerAttributes* is greater than *startLayerLeftRight*, the layers for the names of the node- / edgeAttributes 
#' start at *startLayerAttributes*. If *startLayerValues* is greater than *startLayerAttributes*, the layers for the values of the node- / edgeAttributes 
#' start at *startLayerValues*.
#'
#' @param rcx \code{\link{RCX-object}}; the defined node positions are added to this \code{\link{RCX-object}}
#' @param dX integer (optional, default value 70); determines the width of the created circles
#' @param dY integer (optional, default value 70); determines the height of the created circles
#' @param startLayerBoth integer (optional, default value 5); determines the layer at which the circles for the nodes that 
#' belong to both RCX-objects start
#' @param startLayerLeftRight integer (optional, default value 10); determines the layer at which the circles for the nodes that belong only 
#' to one RCX-object start
#' @param startLayerAttributes integer (optional, default value 0); if greater than *startLayerLeftRight*, it determines the layer at which 
#' the circles for the names of the nodesAttributes start 
#' @param startLayerValues integer (optional, default value 0); if greater than *startLayerAttributes*, it determines the layer at which 
#' the circle for the values of the nodesAttribute start
.diffSortedLayout <- function(rcx, dX=70, dY=70, startLayerBoth=5, startLayerLeftRight=10, startLayerAttributes=0, startLayerValues=0) {
    xs = c()
    ys = c()
    ## Create inner circle for the nodes for node names / node represents / edges that belong to both networks
    nodesBoth = intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Both",]$propertyOf, 
                          rcx$nodeAttributes[rcx$nodeAttributes$value=="NodeName",]$propertyOf)
    nodesBoth = append(nodesBoth, intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Both",]$propertyOf, 
                                            rcx$nodeAttributes[rcx$nodeAttributes$value=="NodeRepresent",]$propertyOf))
    nodesBoth = append(nodesBoth, intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Both",]$propertyOf, 
                                            rcx$nodeAttributes[rcx$nodeAttributes$value=="Edge",]$propertyOf))
    ## Check if there are nodes that exist in both networks and create the circles
    if (length(nodesBoth)>0) {
        res = split(nodesBoth, cut(seq_along(nodesBoth), 4, labels=FALSE))
        
        nodesBothQ1 = unlist(res[1])
        nodesBothQ2 = unlist(res[2])
        nodesBothQ3 = unlist(res[3])
        nodesBothQ4 = unlist(res[4])
        
        coordXY = .diffQuadrantLayout(nodesBothQ1, dX, dY, startLayerBoth, 1)
        xs = append(xs, coordXY$xs)
        ys = append(ys, coordXY$ys)
        
        coordXY = .diffQuadrantLayout(nodesBothQ2, dX, dY, startLayerBoth, 2)
        xs = append(xs, coordXY$xs)
        ys = append(ys, coordXY$ys)
        
        coordXY = .diffQuadrantLayout(nodesBothQ3, dX, dY, startLayerBoth, 3)
        xs = append(xs, coordXY$xs)
        ys = append(ys, coordXY$ys)
        
        coordXY = .diffQuadrantLayout(nodesBothQ4, dX, dY, startLayerBoth, 4)
        xs = append(xs, coordXY$xs)
        ys = append(ys, coordXY$ys)
    }
    
    ## Create right half with nodes  for the node name / node represent / edge that belong to the right network
    nodesRight = intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Right",]$propertyOf, 
                           rcx$nodeAttributes[rcx$nodeAttributes$value=="NodeName",]$propertyOf)
    nodesRight = append(nodesRight, intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Right",]$propertyOf, 
                                              rcx$nodeAttributes[rcx$nodeAttributes$value=="NodeRepresent",]$propertyOf))
    nodesRight = append(nodesRight, intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Right",]$propertyOf, 
                                              rcx$nodeAttributes[rcx$nodeAttributes$value=="Edge",]$propertyOf))
    
    ## Check if there are nodes that belong only to the right network and fill the right half with them
    if(length(nodesRight)>0) {
        res = split(nodesRight, cut(seq_along(nodesRight), 2, labels=FALSE))
        
        nodesRightQ1 = unlist(res[1])
        nodesRightQ4 = unlist(res[2])
        
        coordXY = .diffQuadrantLayout(nodesRightQ1, dX, dY, startLayerLeftRight, 1)
        xs = append(xs, coordXY$xs)
        ys = append(ys, coordXY$ys)
        
        coordXY = .diffQuadrantLayout(nodesRightQ4, dX, dY, startLayerLeftRight, 4)
        xs = append(xs, coordXY$xs)
        ys = append(ys, coordXY$ys)
        
        nodes = append(nodesBoth, nodesRight)
    }
    
    ## Check if there are nodes that belong only to the left network and fill the left half with them
    nodesLeft = intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Left",]$propertyOf, 
                          rcx$nodeAttributes[rcx$nodeAttributes$value=="NodeName",]$propertyOf)
    nodesLeft = append(nodesLeft, intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Left",]$propertyOf, 
                                            rcx$nodeAttributes[rcx$nodeAttributes$value=="NodeRepresent",]$propertyOf))
    nodesLeft = append(nodesLeft, intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Left",]$propertyOf, 
                                            rcx$nodeAttributes[rcx$nodeAttributes$value=="Edge",]$propertyOf))
    ## Check if there are nodes that belong only to the left network
    if (length(nodesLeft)>0) {
        ## Fill quadrant 2 and 3 with the nodes
        res = split(nodesLeft, cut(seq_along(nodesLeft), 2, labels=FALSE))
        
        nodesLeftQ2 = unlist(res[1])
        nodesLeftQ3 = unlist(res[2])
        
        coordXY = .diffQuadrantLayout(nodesLeftQ2, dX, dY, startLayerLeftRight, 2)
        xs = append(xs, coordXY$xs)
        ys = append(ys, coordXY$ys)
        
        coordXY = .diffQuadrantLayout(nodesLeftQ3, dX, dY, startLayerLeftRight, 3)
        xs = append(xs, coordXY$xs)
        ys = append(ys, coordXY$ys)
        
        nodes = append(nodes, nodesLeft)
    }
    
    ## Check if startLayerAttributes is greater than startLayerLeftRight
    if (startLayerAttributes > startLayerLeftRight) {
        ## Create sectors for the attributes that belong to both networks
        nodesBothAttributes = intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Both",]$propertyOf, 
                                        rcx$nodeAttributes[rcx$nodeAttributes$value=="NodeAttribute",]$propertyOf)
        nodesBothAttributes = append(nodesBothAttributes, intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Both",]$propertyOf, 
                                                                    rcx$nodeAttributes[rcx$nodeAttributes$value=="EdgeAttribute",]$propertyOf))
        ## Check if there are attributes that belong to both networks
        if (length(nodesBothAttributes)>0) {
            ## Fill the quadrant 3 and 4 with the attributes
            res = split(nodesBothAttributes, cut(seq_along(nodesBothAttributes), 2, labels=FALSE))
            
            nodesBothAttributesQ3 = unlist(res[1])
            nodesBothAttributesQ4 = unlist(res[2])
            
            coordXY = .diffQuadrantLayout(nodesBothAttributesQ3, dX, dY, startLayerAttributes, 3)
            xs = append(xs, coordXY$xs)
            ys = append(ys, coordXY$ys)
            
            coordXY = .diffQuadrantLayout(nodesBothAttributesQ4, dX, dY,startLayerAttributes, 4)
            xs = append(xs, coordXY$xs)
            ys = append(ys, coordXY$ys)
            
            nodes = append(nodes, nodesBothAttributes)
            
            ## Add the attributes from the right network
            nodesRightAttributes = intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Right",]$propertyOf, 
                                             rcx$nodeAttributes[rcx$nodeAttributes$value=="NodeAttribute",]$propertyOf)
            nodesRightAttributes = append(nodesRightAttributes, intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Right",]$propertyOf, 
                                                                          rcx$nodeAttributes[rcx$nodeAttributes$value=="EdgeAttribute",]$propertyOf))
            ## Fill the quadrant 1 with the attributes that exist only in the right network
            coordXY = .diffQuadrantLayout(nodesRightAttributes, dX, dY, startLayerAttributes, 1)
            xs = append(xs, coordXY$xs)
            ys = append(ys, coordXY$ys)
            
            nodes = append(nodes, nodesRightAttributes)
            
            ## Add the attributes from the left network
            nodesLeftAttributes = intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Left",]$propertyOf, 
                                            rcx$nodeAttributes[rcx$nodeAttributes$value=="NodeAttribute",]$propertyOf)
            nodesLeftAttributes = append(nodesLeftAttributes, intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Left",]$propertyOf, 
                                                                        rcx$nodeAttributes[rcx$nodeAttributes$value=="EdgeAttribute",]$propertyOf))
            
            ## Fill the quadrant 2 with the attributes that exist only in the left network
            coordXY = .diffQuadrantLayout(nodesLeftAttributes, dX, dY, startLayerAttributes, 2)
            xs = append(xs, coordXY$xs)
            ys = append(ys, coordXY$ys)
            
            nodes = append(nodes, nodesLeftAttributes)
        } 
        ## If there are no attributes that exist in both network the attributes from the right network are in the right half and the attributes from the left network are in the left half
        else { 
            ## Add the attributes from the right network
            nodesRightAttributes = intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Right",]$propertyOf, 
                                             rcx$nodeAttributes[rcx$nodeAttributes$value=="NodeAttribute",]$propertyOf)
            nodesRightAttributes = append(nodesRightAttributes, intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Right",]$propertyOf, 
                                                                          rcx$nodeAttributes[rcx$nodeAttributes$value=="EdgeAttribute",]$propertyOf))
            ## Check if there are attributes from the right network
            if (length(nodesRightAttributes)>0) {
                ## Fill quadrant 1 and 4 with the attributes from the right network
                res = split(nodesRightAttributes, cut(seq_along(nodesRightAttributes), 2, labels=FALSE))
                
                nodesRightAttributesQ1 = unlist(res[1])
                nodesRightAttributesQ4 = unlist(res[2])
                
                coordXY = .diffQuadrantLayout(nodesRightAttributesQ1, dX, dY, startLayerAttributes, 1)
                xs = append(xs, coordXY$xs)
                ys = append(ys, coordXY$ys)
                
                coordXY = .diffQuadrantLayout(nodesRightAttributesQ4, dX, dY, startLayerAttributes, 4)
                xs = append(xs, coordXY$xs)
                ys = append(ys, coordXY$ys)
                
                nodes = append(nodes, nodesRightAttributes)
            }
            
            ## Add the attributes from the left network
            nodesLeftAttributes = intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Left",]$propertyOf, 
                                            rcx$nodeAttributes[rcx$nodeAttributes$value=="NodeAttribute",]$propertyOf)
            nodesLeftAttributes = append(nodesLeftAttributes, intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Left",]$propertyOf, 
                                                                        rcx$nodeAttributes[rcx$nodeAttributes$value=="EdgeAttribute",]$propertyOf))
            
            if (length(nodesLeftAttributes)>0) {
                ## Fill quadrant 2 and 3 with the attributes from the left network
                res = split(nodesLeftAttributes, cut(seq_along(nodesLeftAttributes), 2, labels=FALSE))
                
                nodesLeftAttributesQ2 = unlist(res[1])
                nodesLeftAttributesQ3 = unlist(res[2])
                
                coordXY = .diffQuadrantLayout(nodesLeftAttributesQ2, dX, dY, startLayerAttributes, 2)
                xs = append(xs, coordXY$xs)
                ys = append(ys, coordXY$ys)
                
                coordXY = .diffQuadrantLayout(nodesLeftAttributesQ3, dX, dY, startLayerAttributes, 3)
                xs = append(xs, coordXY$xs)
                ys = append(ys, coordXY$ys)
                
                nodes = append(nodes, nodesLeftAttributes)
            }
        }
    }
    
    if ((startLayerValues>startLayerAttributes) && (startLayerAttributes!=0)) {
        ## Create sector of gray nodes for attribute values
        nodesBothValues = intersect(rcx$nodeAttributes[rcx$nodeAttributes$value == "Both",]$propertyOf, 
                                    rcx$nodeAttributes[rcx$nodeAttributes$value == "NodeAttributeValue",]$propertyOf)
        nodesBothValues = append(nodesBothValues, intersect(rcx$nodeAttributes[rcx$nodeAttributes$value == "Both",]$propertyOf, 
                                                            rcx$nodeAttributes[rcx$nodeAttributes$value == "EdgeAttributeValue",]$propertyOf))
        ## Check if there are values that exist in both networks
        if (length(nodesBothValues)>0) {
            ## Fill quadrant 3 and 4 with the values that belong to a shared attribute
            res = split(nodesBothValues, cut(seq_along(nodesBothValues), 2, labels=FALSE))
            
            nodesBothValuesQ3 = unlist(res[1])
            nodesBothValuesQ4 = unlist(res[2])
            
            nodesBothValuesQ3 = append(nodesBothValuesQ3, intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Left",]$propertyOf, 
                                                                    rcx$nodeAttributes[rcx$nodeAttributes$value=="sharedValue",]$propertyOf))
            nodesBothValuesQ4 = append(nodesBothValuesQ4, intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Right",]$propertyOf, 
                                                                    rcx$nodeAttributes[rcx$nodeAttributes$value=="sharedValue",]$propertyOf))
            
            coordXY = .diffQuadrantLayout(nodesBothValuesQ3, dX, dY, startLayerValues, 3)
            xs = append(xs, coordXY$xs)
            ys = append(ys, coordXY$ys)
            
            coordXY = .diffQuadrantLayout(nodesBothValuesQ4, dX, dY, startLayerValues, 4)
            xs = append(xs, coordXY$xs)
            ys = append(ys, coordXY$ys)
            
            nodes = append(nodes, nodesBothValuesQ3)
            nodes = append(nodes, nodesBothValuesQ4)
            
            ## Add the attributes from the right network
            nodesRightValues = intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Right",]$propertyOf, 
                                         rcx$nodeAttributes[rcx$nodeAttributes$value=="noSharedValue",]$propertyOf)
            coordXY = .diffQuadrantLayout(nodesRightValues, dX, dY, startLayerValues, 1)
            xs = append(xs, coordXY$xs)
            ys = append(ys, coordXY$ys)
            
            nodes = append(nodes, nodesRightValues)
            
            ## Add the attributes from the left network
            nodesLeftValues = intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Left",]$propertyOf, 
                                        rcx$nodeAttributes[rcx$nodeAttributes$value=="noSharedValue",]$propertyOf)
            coordXY = .diffQuadrantLayout(nodesLeftValues, dX, dY, startLayerValues, 2)
            xs = append(xs, coordXY$xs)
            ys = append(ys, coordXY$ys)
            
            nodes = append(nodes, nodesLeftValues)
        } 
        ## There are no values that exist in both networks
        else { 
            ## Fill quadrant 4 with the right values of a shared attribute 
            nodesRightValuesShared <- intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Right",]$propertyOf, 
                                                rcx$nodeAttributes[rcx$nodeAttributes$value=="sharedValue",]$propertyOf)
            
            coordXY = .diffQuadrantLayout(nodesRightValuesShared, dX, dY, startLayerValues, 4)
            xs = append(xs, coordXY$xs)
            ys = append(ys, coordXY$ys)
            
            nodes = append(nodes, nodesRightValuesShared)
            ## Fill quadrant 1 with the values of attributes that exist only in the right network
            nodesRightValues <- intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Right",]$propertyOf, 
                                          rcx$nodeAttributes[rcx$nodeAttributes$value=="noSharedValue",]$propertyOf)
            
            coordXY = .diffQuadrantLayout(nodesRightValues, dX, dY, startLayerValues, 1)
            xs = append(xs, coordXY$xs)
            ys = append(ys, coordXY$ys)
            
            nodes = append(nodes, nodesRightValues)
            
            ## Fill quadrant 3 with the left values of a shared attribute 
            nodesLeftValuesShared <- intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Left",]$propertyOf, 
                                               rcx$nodeAttributes[rcx$nodeAttributes$value=="sharedValue",]$propertyOf)
            
            coordXY = .diffQuadrantLayout(nodesLeftValuesShared, dX, dY, startLayerValues, 3)
            xs = append(xs, coordXY$xs)
            ys = append(ys, coordXY$ys)
            
            nodes = append(nodes, nodesLeftValuesShared)
            
            ## Fill quadrant 2 with the values of attributes that exist only in the left network
            nodesLeftValues <- intersect(rcx$nodeAttributes[rcx$nodeAttributes$value=="Left",]$propertyOf, 
                                         rcx$nodeAttributes[rcx$nodeAttributes$value=="noSharedValue",]$propertyOf)
            
            coordXY = .diffQuadrantLayout(nodesLeftValues, dX, dY, startLayerValues, 2)
            xs = append(xs, coordXY$xs)
            ys = append(ys, coordXY$ys)
            
            nodes = append(nodes, nodesLeftValues)
        }
        
    }
    ## return cartesianLayout
    return(createCartesianLayout(nodes, xs, ys))
}

#' Helper-function to calculate the positions of the nodes
#' 
#' Calculates the position for the given nodes starting at a defined layer for a defined quadrant.
#'
#' @param nodes integer list; contains the nodes ids to which the x- and y-coordinates are assigned
#' @param dX integer (optional, default value 70); determines the width of the created circles
#' @param dY integer (optional, default value 70); determines the height of the created circles
#' @param startLayer integer (optional, default values 0); determines the layer at which the nodes start
#' @param sector integer (optional, default value 1); determines the sector in which the nodes are located. 
#' If the sector is greater or equal 4, a modulo 4 operation is performed to map the result to 0, 1, 2 or 3.
.diffQuadrantLayout <- function(nodes, dX=70, dY=70, startLayer=0, sector=1) {
    layer <- startLayer
    nodesInLayer <- 0
    counter <- 0
    remaining <- length(nodes) -
        counter
    sector <- sector %% 4
    
    xs <- c()
    ys <- c()
    
    maxNodesInLayer <- .diffGetMaxInLayers(layer)
    
    for (n in nodes) {
        ## distribute all nodes evenly in a circle
        if (remaining < maxNodesInLayer)
            fracts <- (90/remaining) else fracts <- (90/maxNodesInLayer)
            ## calc x and y position
            x <- sin((pi/180) * fracts * nodesInLayer) *
                dX * layer
            y <- cos((pi/180) * fracts * nodesInLayer) *
                dY * layer
            ## If the sector is unequal to 1, the calculated coordinates need to be changed
            if (sector == 2) {
                if (x == 0) {
                    x <- -y
                    y <- 0
                } else {
                    x <- -x
                }
            } else if (sector == 3) {
                x = -x
                y = -y
            } else if (sector == 0) {
                if (x == 0) {
                    x <- y
                    y <- 0
                } else {
                    y <- -y
                }
            }
            
            xs <- append(xs, x)
            ys <- append(ys, y)
            
            nodesInLayer <- nodesInLayer + 1
            counter <- counter + 1
            
            ## if one layer is full
            if (nodesInLayer == maxNodesInLayer) {
                remaining <- length(nodes) -
                    counter
                nodesInLayer <- 0
                layer <- layer + 1
                
                maxNodesInLayer <- .diffGetMaxInLayers(layer)
                maxNodesInNextLayer <- .diffGetMaxInLayers(layer + 1)
                ## for the outer two circles, distribute more evenly
                if (remaining > maxNodesInLayer & (remaining < maxNodesInLayer + maxNodesInNextLayer)) {
                    ## keep the fraction between the two circles
                    maxNodesInLayer <- min(
                        floor(
                            remaining * (maxNodesInLayer/maxNodesInLayer +
                                             maxNodesInNextLayer)
                        ),
                        maxNodesInLayer
                    )
                }
            }
    }
    return(list("xs" = xs,"ys" = ys))
}

#' Helper function for *.diffQuadrantLayout*
.diffGetMaxInLayers <- function(layer) {
    if (layer == 0)
        res <- 1 else if (layer == 1)
            res <- 1 else if (layer == 2)
                res <- 3 else res <- 2 * (layer - 1) - (4 * floor(log(layer, 8)))
                return(res)
}