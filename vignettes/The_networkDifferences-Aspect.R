## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(tidy.opts=list(width.cutoff=55,
                                     args.newline = TRUE,
                                     arrow = TRUE),
                      tidy=TRUE)

## ----library, echo=FALSE, message=FALSE, include = TRUE, eval=TRUE------------
library(RCXNetworkDifferences)

## ----left right---------------------------------------------------------------
left <- createRCX(
    nodes = createNodes(id=0:2, name=c("A","B","C"), represents=c("r1","r2","r3")),
    edges = createEdges(source = c(0, 1, 2), target = c(1, 2, 0), interaction = c("E1", "E2", "E3")),
    nodeAttributes = createNodeAttributes(propertyOf = c(0, 1), name = rep("type", 2), value = list("w", c("x", "y"))),
    edgeAttributes = createEdgeAttributes(propertyOf = c(0, 1), name = rep("type", 2), value = c("k", "l")),
    networkAttributes = createNetworkAttributes(name = c("name", "author"), value = c("left network", "Donald Duck"))
)

right <- createRCX(
    nodes = createNodes(name = c("A", "B", "X"), represents = c ("r1", "r4", "r5")),
    edges = createEdges(source = c(0, 1, 2), target = c(1, 2, 0), interaction = c("E1", "E2", "E3")),
    nodeAttributes = createNodeAttributes(propertyOf = c(0, 1), name = c("type", "type"),value = list("z", c("x", "y"))),
    edgeAttributes = createEdgeAttributes(propertyOf = c(0, 1), name = rep("type", 2), value = list("n" , c("l", "m"))),
    networkAttributes = createNetworkAttributes(name = c("name", "description"), value = c("right network", "sample network"))
)

## ----compareNetworks----------------------------------------------------------
rcxMatchByNameTRUE <- compareNetworks(left, right, matchByName = TRUE)
rcxMatchByNameFALSE <- compareNetworks(left, right, matchByName = FALSE)

## ----json---------------------------------------------------------------------
toCX(rcxMatchByNameTRUE, pretty = TRUE)

## ----nodes--------------------------------------------------------------------
rcxMatchByNameTRUE$nodes

## ----nodeAttributes-----------------------------------------------------------
rcxMatchByNameTRUE$nodeAttributes

## ----edges--------------------------------------------------------------------
rcxMatchByNameTRUE$edges

## ----edgeAttributes-----------------------------------------------------------
rcxMatchByNameTRUE$edgeAttributes

## ----left nodes---------------------------------------------------------------
left$nodes

## ----right nodes--------------------------------------------------------------
right$nodes

## ----mbnTRUE nodes------------------------------------------------------------
rcxMatchByNameTRUE$networkDifferences$nodes

## ----mbnFALSE nodes-----------------------------------------------------------
rcxMatchByNameFALSE$networkDifferences$nodes

## ----left nodeAttributes------------------------------------------------------
left$nodeAttributes

## ----right nodeAttributes-----------------------------------------------------
right$nodeAttributes

## ----mbnTRUE nodeAttributes---------------------------------------------------
rcxMatchByNameTRUE$networkDifferences$nodeAttributes

## ----mbnFALSE nodeAttributes--------------------------------------------------
rcxMatchByNameFALSE$networkDifferences$nodeAttributes

## ----left edges---------------------------------------------------------------
left$edges

## ----right edges--------------------------------------------------------------
right$edges

## ----mbnTRUE edges------------------------------------------------------------
rcxMatchByNameTRUE$networkDifferences$edges

## ----mbnFALSE edges-----------------------------------------------------------
rcxMatchByNameFALSE$networkDifferences$edges

## ----left edgeAttributes------------------------------------------------------
left$edgeAttributes

## ----right edgeAttributes-----------------------------------------------------
right$edgeAttributes

## ----mbnTRUE edgeAttributes---------------------------------------------------
rcxMatchByNameTRUE$networkDifferences$edgeAttributes

## ----mbnFALSE edgeAttributes--------------------------------------------------
rcxMatchByNameFALSE$networkDifferences$edgeAttributes

## ----left networkAttributes---------------------------------------------------
left$networkAttributes

## ----right networkAttributes--------------------------------------------------
right$networkAttributes

## ----mbn networkAttributes----------------------------------------------------
rcxMatchByNameTRUE$networkDifferences$networkAttributes

## ----rcxToJSON----------------------------------------------------------------
json = toCX(rcxMatchByNameTRUE, verbose = TRUE, pretty = TRUE)
json

## ----JSONToRcx----------------------------------------------------------------
jsonParsed = parseJSON(json)
rcx = processCX(jsonParsed, verbose = TRUE)

## ----mbnTRUE_nodeNetwork------------------------------------------------------
nodeNetwork = exportDifferencesToNodeNetwork(rcxMatchByNameTRUE$networkDifferences, includeNamesAndRepresents = FALSE, startLayerBoth = 1, startLayerLeftRight = 2, startLayerAttributes = 3, startLayerValues = 4)

## ----mbnTRUE_nodeNetwork2, eval=FALSE-----------------------------------------
#  visualize(nodeNetwork)

## ----mbnFALSE_nodeNetwork-----------------------------------------------------
nodeNetwork = exportDifferencesToNodeNetwork(rcxMatchByNameFALSE$networkDifferences, includeNamesAndRepresents = FALSE, startLayerBoth = 1, startLayerLeftRight = 2, startLayerAttributes = 3, startLayerValues = 4)

## ----mbnFALSE_nodeNetwork2, eval=FALSE----------------------------------------
#  visualize(nodeNetwork)

## ----mbnTRUE_NodeNetworkRepr--------------------------------------------------
nodeNetwork = exportDifferencesToNodeNetwork(rcxMatchByNameTRUE$networkDifferences, includeNamesAndRepresents = TRUE, startLayerBoth = 1, startLayerLeftRight = 2, startLayerAttributes = 3, startLayerValues = 4)

## ----mbnTRUE_NodeNetworkRepr2, eval=FALSE-------------------------------------
#  visualize(nodeNetwork)

## ----mbnTRUE_edgeNetwork------------------------------------------------------
edgeNetwork = exportDifferencesToEdgeNetwork(rcxMatchByNameTRUE$networkDifferences, startLayerBoth = 1, startLayerLeftRight = 2, startLayerAttributes = 3, startLayerValues = 4)

## ----mbnTRUE_edgeNetwork2, eval=FALSE-----------------------------------------
#  visualize(edgeNetwork)

## ----mbnFALSE_edgeNetwork-----------------------------------------------------
edgeNetwork = exportDifferencesToEdgeNetwork(rcxMatchByNameFALSE$networkDifferences, startLayerBoth = 1, startLayerLeftRight = 2, startLayerAttributes = 3, startLayerValues = 4)

## ----mbnFALSE_edgeNetwork2, eval=FALSE----------------------------------------
#  visualize(edgeNetwork)

## ----mbnTRUE_nodeEdgeNetwork--------------------------------------------------
nodeEdgeNetwork = exportDifferencesToNodeEdgeNetwork(rcxMatchByNameTRUE$networkDifferences, startLayerBoth = 1, startLayerLeftRight = 2, startLayerAttributes = 3, startLayerValues = 4)

## ----mbnTRUE_nodeEdgeNetwork2, eval=FALSE-------------------------------------
#  visualize(nodeEdgeNetwork)

## ----mbnTRUE_nodeEdgeNetworkRepr----------------------------------------------
nodeEdgeNetwork = exportDifferencesToNodeEdgeNetwork(rcxMatchByNameTRUE$networkDifferences, startLayerBoth = 1, startLayerLeftRight = 2, startLayerAttributes = 0, startLayerValues = 0)

## ----mbnTRUE_nodeEdgeNetworkRepr2, eval=FALSE---------------------------------
#  visualize(nodeEdgeNetwork)

## ----loadNDeX-----------------------------------------------------------------
library(ndexr)
uuid = "a420aaee-4be9-11ec-b3be-0ac135e8bacf"
ndex_con = ndex_connect()
rcx = ndex_get_network(ndex_con, uuid)

## ----realLife subnetworks, tidy=FALSE-----------------------------------------
library(stringr)

getSubnetwork <- function(
        patientID = NULL,
        rcx = NULL,
        filterNodeAttributes = ""
) {
    nodes <- rcx$nodes
    edges <- rcx$edges
    nodeAttributes <- rcx$nodeAttributes[startsWith(rcx$nodeAttributes$name, patientID),]
    nodeID <- c()
    for (i in 1:nrow(nodeAttributes)) {
        row = nodeAttributes[i,]
        if (startsWith(row$name, patientID)) {
            propID = row$propertyOf
            if (!(propID %in% nodeID)) {
                nodeID = append(nodeID, propID)
            }
        }
    }
    nodes = subset(nodes, id %in% nodeID)
    nodeAttributes <- subset(nodeAttributes, propertyOf %in% nodeID)
    for (i in 1:nrow(nodeAttributes)) {
        nodeAttributes[i,]$name <- str_remove(nodeAttributes[i,]$name, paste(patientID, "_", sep = ""))
    }
    if (nchar(filterNodeAttributes) > 0) {
        nodeAttributes <- nodeAttributes[nodeAttributes$name == filterNodeAttributes,]
    }
    edgeID <- c()
    for (i in 1:nrow(rcx$edges)) {
        row = rcx$edges[i,]
        if (row$source %in% nodeID && row$target %in% nodeID) {
            edgeID = append(edgeID, row$id)
        }
    }
    edges = subset(edges, id %in% edgeID)
    rcx = createRCX(nodes = nodes, edges = edges)
    rcx = updateNodeAttributes(rcx, nodeAttributes)
    return(rcx)
}

rcxGSM615195 <- getSubnetwork("GSM615195", rcx, filterNodeAttributes = "GE_Level")

rcxGSM615184 <- getSubnetwork("GSM615184", rcx, filterNodeAttributes = "GE_Level")

## ----realLife rcxGSM615195----------------------------------------------------
summary(rcxGSM615195)

## ----realLife GSM615184-------------------------------------------------------
summary(rcxGSM615184)

## ----realLife_nodeNetwork-----------------------------------------------------
netDif = compareNetworks(rcxGSM615195, rcxGSM615184, TRUE)

nodesNetwork = exportDifferencesToNodeNetwork(netDif$networkDifferences)

## ----realLife_nodeNetwork2, eval=FALSE----------------------------------------
#  visualize(nodesNetwork)

## ----realLife_nodeAttributesNetwork-------------------------------------------
nodesAttributesValuesNetwork = exportDifferencesToNodeNetwork(netDif$networkDifferences, startLayerAttributes = 15, startLayerValues = 20)

## ----realLife_nodeAttributesNetwork2, eval=FALSE------------------------------
#  visualize(nodesAttributesValuesNetwork)

## ----sessionInfo--------------------------------------------------------------
sessionInfo()

## ----readme, eval=FALSE, include=FALSE----------------------------------------
#  rmarkdown::render("The_networkDifferences-Aspect.Rmd", rmarkdown::md_document(variant = "gfm", df_print = "kable"), output_file = "../README.md")

