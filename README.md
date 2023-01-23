# The NetworkDifferences-Aspect

*The networkDifferences-aspect in a nutshell:* This vignette explains
the NetworkDifferences aspect in detail but this section summarizes the
main ideas:

-   The NetworkDifferences aspect tracks the differences of two networks
    represented as RCX-objects. The `compareNetworks`-function returns
    an RCX-object whereby the nodes-, nodeAttributes-, edges-, and
    edgeAttributes-aspects are a combination of the two given
    RCX-objects `left` and `right`. This RCX-object has the
    NetworkDifferences aspect, too, which is a list containing five
    dataframes to monitor the differences regarding the nodes,
    nodeAttributes, edges, edgeAttributes, and networkAttributes.

-   The RCX-object including the NetworkDifferences aspect can be
    converted to the json-based data structure CX and back by using the
    `toCX`- and `processCX`-functions provided by the RCX package.

-   The NetworkDifferences aspect can be converted to RCX-objects that
    visualize the differences of the two given networks with focus on
    their topology. The user can select if the RCX-object should be
    node-centered, edge-centered, or a combination and if the attributes
    and their values should be included. The conversion to an RCX object
    allows to store, share, and visualize the NetworkDifferences aspect.

------------------------------------------------------------------------

The NetworkDifferences aspect allows the tracking and visualization of
the differences of two RCX-objects. The first part of this vignette
explains in detail how this aspect works and at the end we take a closer
look at how this functionality can be used for a real-life example. Many
biological entities like proteins and genes are represented as
biological networks with nodes and edges and comparing these networks
can help to answer questions in medical research e. g. the real-life
example illustrates how the NetworkDifferences aspect can be used to
visualize the differences regarding genes, gene expression and other
aspects of two breast cancer patients.

The NetworkDifferences aspect website is available at
<https://github.com/frankkramer-lab/RCX-NetworkDifferences>  
This package is an extension of the RCX package by Florian Auer
(Bioconductor:
<https://bioconductor.org/packages/release/bioc/html/RCX.html>, Github:
<https://github.com/frankkramer-lab/RCX>). The json-based data structure
CX is often used to store biological networks and the RCX package adapts
the CX format to standard R data formats to create, modify, load,
export, and visualize networks.

Two RCX-objects `left` and `right` are created and function as examples
later.

``` r
left <- RCX::createRCX(
    nodes = RCX::createNodes(
        id = 0:2, name = c("A", "B", "C"),
        represents = c("r1", "r2", "r3")
    ),
    edges = RCX::createEdges(
        source = c(0, 1, 2),
        target = c(1, 2, 0),
        interaction = c("E1", "E2", "E3")
    ),
    nodeAttributes = RCX::createNodeAttributes(
        propertyOf = c(0, 1),
        name = rep("type", 2),
        value = list("w", c("x", "y"))
    ),
    edgeAttributes = RCX::createEdgeAttributes(
        propertyOf = c(0, 1),
        name = rep("type", 2),
        value = c("k", "l")
    ),
    networkAttributes = RCX::createNetworkAttributes(
        name = c("name", "author"),
        value = c("left network", "Donald Duck")
    )
)
```

    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect"

``` r
right <- RCX::createRCX(
    nodes = RCX::createNodes(
        name = c("A", "B", "X"),
        represents = c("r1", "r4", "r5")
    ),
    edges = RCX::createEdges(
        source = c(0, 1, 2),
        target = c(1, 2, 0),
        interaction = c("E1", "E2", "E3")
    ),
    nodeAttributes = RCX::createNodeAttributes(
        propertyOf = c(0, 1),
        name = c("type", "type"),
        value = list("z", c("x", "y"))
    ),
    edgeAttributes = RCX::createEdgeAttributes(
        propertyOf = c(0, 1),
        name = rep("type", 2),
        value = list("n", c("l", "m"))
    ),
    networkAttributes = RCX::createNetworkAttributes(
        name = c("name", "description"),
        value = c("right network", "sample network")
    )
)
```

    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect"

## The compareNetworks-function

The `compareNetworks`-function is provided to track the differences
regarding the `nodes`, `nodeAttributes`, `edges`, `edgeAttributes`, and
`networkAttributes` and has three parameters: the two RCX-objects `left`
and `right`, and the boolean `matchByName`. The names `left` and `right`
are based on the join-operation. If `matchByName` is `TRUE`, two nodes
are equal when their names are equal; if `matchByName` is `FALSE`, two
nodes are equal when their represents are equal. To illustrate the
difference between `matchByName` set to `TRUE` respectively `FALSE`, we
define two RCX-objects called `rcxMatchByNameTRUE` and
`rcxMatchByNameFALSE`.

``` r
rcxMatchByNameTRUE <- compareNetworks(left, right, matchByName = TRUE)
```

    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect"

``` r
rcxMatchByNameFALSE <- compareNetworks(left, right, matchByName = FALSE)
```

    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect"

The function returns an RCX-object whereby the `nodes`,
`nodeAttributes`, `edges`, and `edgeAttributes` of the right network are
appended to the corresponding aspects of the left network. The
`networkAttributes` are ignored as it is not possible to append the
`networkAttributes` of the right network to the `networkAttributes` of
the left network if two `networkAttributes` have the same name. An
additional aspect called the NetworkDifferences aspect is added to the
RCX-object. It is a list with the `matchByName`-boolean and five
dataframes to track the differences of `nodes`, `nodeAttributes`,
`edges`, `edgeAttributes`, and `networkAttributes` of the two
RCX-objects.

The structure of the returned RCX object is:

    |---nodes: left nodes, right nodes
    |---nodeAttributes: left nodeAttributes, right nodeAttributes
    |---edges: left edges, right edges
    |---edgeAttributes: left edgeAttributes, right edgeAttributes
    |---networkDifferences
    |   |---matchByName: logical, if TRUE two nodes are equal when their names are equal, 
                        if FALSE two nodes are equal when their represents are equal
    |   |---nodes: differences of the nodes (columns depend on matchByName: id, name/nameLeft,                                      representLeft/nameRight, representRight/represent, oldIdLeft, oldIdRight, belongsToLeft,                        belongsToRight)
    |   |---nodeAttributes: differences of the nodeAttributes (columns: propertyOf, name, belongsToLeft,                                    belongsToRight, dataTypeLeft, dataTypeRight, isListLeft, isListRight, valueLeft,                                valueRight)
    |   |---edges: differences of the edges (columns: id, source, target, interaction, oldIdLeft, oldIdRight,                       belongsToLeft, belongsToRight)
    |   |---edgeAttributes: differences of the edgeAttributes (columns: propertyOf, name, belongsToLeft,                                    belongsToRight, dataTypeLeft, dataTypeRight, isListLeft, isListRight, valueLeft,                                valueRight)
    |   |---networkAttributes: differences of the networkAttributes (columns: name, belongsToLeft, belongsToRight,                              dataTypeLeft, dataTypeRight, isListLeft, isListRight, valueLeft, valueRight)

The structure of the NetworkDifferences aspect is visible after a
conversion to JSON.

``` r
RCX::toCX(rcxMatchByNameTRUE, pretty = TRUE)
```

    ## [
    ##     {
    ##         "numberVerification": [
    ##             {
    ##                 "longNumber": 2147483647
    ##             }
    ##         ]
    ##     },
    ##     {
    ##         "metaData": [
    ##             {
    ##                 "name": "nodes",
    ##                 "version": "1.0",
    ##                 "idCounter": 5,
    ##                 "elementCount": 6,
    ##                 "consistencyGroup": 1
    ##             },
    ##             {
    ##                 "name": "edges",
    ##                 "version": "1.0",
    ##                 "idCounter": 5,
    ##                 "elementCount": 6,
    ##                 "consistencyGroup": 1
    ##             },
    ##             {
    ##                 "name": "nodeAttributes",
    ##                 "version": "1.0",
    ##                 "elementCount": 4,
    ##                 "consistencyGroup": 1
    ##             },
    ##             {
    ##                 "name": "edgeAttributes",
    ##                 "version": "1.0",
    ##                 "elementCount": 4,
    ##                 "consistencyGroup": 1
    ##             }
    ##         ]
    ##     },
    ##     {
    ##         "nodes": [
    ##             {
    ##                 "@id": 0,
    ##                 "n": "A",
    ##                 "r": "r1",
    ##                 "oldId": 0
    ##             },
    ##             {
    ##                 "@id": 1,
    ##                 "n": "B",
    ##                 "r": "r2",
    ##                 "oldId": 1
    ##             },
    ##             {
    ##                 "@id": 2,
    ##                 "n": "C",
    ##                 "r": "r3",
    ##                 "oldId": 2
    ##             },
    ##             {
    ##                 "@id": 3,
    ##                 "n": "A",
    ##                 "r": "r1",
    ##                 "oldId": 0
    ##             },
    ##             {
    ##                 "@id": 4,
    ##                 "n": "B",
    ##                 "r": "r4",
    ##                 "oldId": 1
    ##             },
    ##             {
    ##                 "@id": 5,
    ##                 "n": "X",
    ##                 "r": "r5",
    ##                 "oldId": 2
    ##             }
    ##         ]
    ##     },
    ##     {
    ##         "edges": [
    ##             {
    ##                 "@id": 0,
    ##                 "s": 0,
    ##                 "t": 1,
    ##                 "i": "E1",
    ##                 "oldId": 0
    ##             },
    ##             {
    ##                 "@id": 1,
    ##                 "s": 1,
    ##                 "t": 2,
    ##                 "i": "E2",
    ##                 "oldId": 1
    ##             },
    ##             {
    ##                 "@id": 2,
    ##                 "s": 2,
    ##                 "t": 0,
    ##                 "i": "E3",
    ##                 "oldId": 2
    ##             },
    ##             {
    ##                 "@id": 3,
    ##                 "s": 3,
    ##                 "t": 4,
    ##                 "i": "E1",
    ##                 "oldId": 0
    ##             },
    ##             {
    ##                 "@id": 4,
    ##                 "s": 4,
    ##                 "t": 5,
    ##                 "i": "E2",
    ##                 "oldId": 1
    ##             },
    ##             {
    ##                 "@id": 5,
    ##                 "s": 5,
    ##                 "t": 3,
    ##                 "i": "E3",
    ##                 "oldId": 2
    ##             }
    ##         ]
    ##     },
    ##     {
    ##         "nodeAttributes": [
    ##             {
    ##                 "po": 0,
    ##                 "n": "type",
    ##                 "v": "w",
    ##                 "d": "string"
    ##             },
    ##             {
    ##                 "po": 1,
    ##                 "n": "type",
    ##                 "v": [
    ##                     "x",
    ##                     "y"
    ##                 ],
    ##                 "d": "list_of_string"
    ##             },
    ##             {
    ##                 "po": 3,
    ##                 "n": "type",
    ##                 "v": "z",
    ##                 "d": "string"
    ##             },
    ##             {
    ##                 "po": 4,
    ##                 "n": "type",
    ##                 "v": [
    ##                     "x",
    ##                     "y"
    ##                 ],
    ##                 "d": "list_of_string"
    ##             }
    ##         ]
    ##     },
    ##     {
    ##         "edgeAttributes": [
    ##             {
    ##                 "po": 0,
    ##                 "n": "type",
    ##                 "v": "k",
    ##                 "d": "string"
    ##             },
    ##             {
    ##                 "po": 1,
    ##                 "n": "type",
    ##                 "v": "l",
    ##                 "d": "string"
    ##             },
    ##             {
    ##                 "po": 3,
    ##                 "n": "type",
    ##                 "v": "n",
    ##                 "d": "string"
    ##             },
    ##             {
    ##                 "po": 4,
    ##                 "n": "type",
    ##                 "v": [
    ##                     "l",
    ##                     "m"
    ##                 ],
    ##                 "d": "list_of_string"
    ##             }
    ##         ]
    ##     },
    ##     {
    ##         "NetworkDifferencesAspect": [
    ##             {
    ##                 "matchByName": "true"
    ##             },
    ##             {
    ##                 "nodes": [
    ##                     {
    ##                         "@id": "0",
    ##                         "n": "A",
    ##                         "rl": "r1",
    ##                         "rr": "r1",
    ##                         "oil": "0",
    ##                         "oir": "0",
    ##                         "btl": "TRUE",
    ##                         "btr": "TRUE"
    ##                     },
    ##                     {
    ##                         "@id": "1",
    ##                         "n": "B",
    ##                         "rl": "r2",
    ##                         "rr": "r4",
    ##                         "oil": "1",
    ##                         "oir": "1",
    ##                         "btl": "TRUE",
    ##                         "btr": "TRUE"
    ##                     },
    ##                     {
    ##                         "@id": "2",
    ##                         "n": "C",
    ##                         "rl": "r3",
    ##                         "oil": "2",
    ##                         "btl": "TRUE",
    ##                         "btr": "FALSE"
    ##                     },
    ##                     {
    ##                         "@id": "3",
    ##                         "n": "X",
    ##                         "rr": "r5",
    ##                         "oir": "2",
    ##                         "btl": "FALSE",
    ##                         "btr": "TRUE"
    ##                     }
    ##                 ]
    ##             },
    ##             {
    ##                 "nodeAttributes": [
    ##                     {
    ##                         "po": "0",
    ##                         "n": "type",
    ##                         "btl": "TRUE",
    ##                         "btr": "TRUE",
    ##                         "dtl": "string",
    ##                         "dtr": "string",
    ##                         "ill": "FALSE",
    ##                         "ilr": "FALSE",
    ##                         "vl": "w",
    ##                         "vr": "z"
    ##                     },
    ##                     {
    ##                         "po": "1",
    ##                         "n": "type",
    ##                         "btl": "TRUE",
    ##                         "btr": "TRUE",
    ##                         "dtl": "string",
    ##                         "dtr": "string",
    ##                         "ill": "TRUE",
    ##                         "ilr": "TRUE",
    ##                         "vl": "c(\"x\", \"y\")",
    ##                         "vr": "c(\"x\", \"y\")"
    ##                     }
    ##                 ]
    ##             },
    ##             {
    ##                 "edges": [
    ##                     {
    ##                         "@id": "0",
    ##                         "s": "0",
    ##                         "t": "1",
    ##                         "i": "E1",
    ##                         "oil": "0",
    ##                         "oir": "0",
    ##                         "btl": "TRUE",
    ##                         "btr": "TRUE"
    ##                     },
    ##                     {
    ##                         "@id": "1",
    ##                         "s": "1",
    ##                         "t": "2",
    ##                         "i": "E2",
    ##                         "oil": "1",
    ##                         "btl": "TRUE",
    ##                         "btr": "FALSE"
    ##                     },
    ##                     {
    ##                         "@id": "2",
    ##                         "s": "2",
    ##                         "t": "0",
    ##                         "i": "E3",
    ##                         "oil": "2",
    ##                         "btl": "TRUE",
    ##                         "btr": "FALSE"
    ##                     },
    ##                     {
    ##                         "@id": "3",
    ##                         "s": "1",
    ##                         "t": "3",
    ##                         "i": "E2",
    ##                         "oir": "1",
    ##                         "btl": "FALSE",
    ##                         "btr": "TRUE"
    ##                     },
    ##                     {
    ##                         "@id": "4",
    ##                         "s": "3",
    ##                         "t": "0",
    ##                         "i": "E3",
    ##                         "oir": "2",
    ##                         "btl": "FALSE",
    ##                         "btr": "TRUE"
    ##                     }
    ##                 ]
    ##             },
    ##             {
    ##                 "edgeAttributes": [
    ##                     {
    ##                         "po": "0",
    ##                         "n": "type",
    ##                         "btl": "TRUE",
    ##                         "btr": "TRUE",
    ##                         "dtl": "string",
    ##                         "dtr": "string",
    ##                         "ill": "FALSE",
    ##                         "ilr": "FALSE",
    ##                         "vl": "k",
    ##                         "vr": "n"
    ##                     },
    ##                     {
    ##                         "po": "1",
    ##                         "n": "type",
    ##                         "btl": "TRUE",
    ##                         "btr": "FALSE",
    ##                         "dtl": "string",
    ##                         "ill": "FALSE",
    ##                         "vl": "l"
    ##                     },
    ##                     {
    ##                         "po": "3",
    ##                         "n": "type",
    ##                         "btl": "FALSE",
    ##                         "btr": "TRUE",
    ##                         "dtr": "string",
    ##                         "ilr": "TRUE",
    ##                         "vr": "c(\"l\", \"m\")"
    ##                     }
    ##                 ]
    ##             },
    ##             {
    ##                 "networkAttributes": [
    ##                     {
    ##                         "n": "name",
    ##                         "btl": "TRUE",
    ##                         "btr": "TRUE",
    ##                         "dtl": "string",
    ##                         "dtr": "string",
    ##                         "ill": "FALSE",
    ##                         "ilr": "FALSE",
    ##                         "vl": "left network",
    ##                         "vr": "right network"
    ##                     },
    ##                     {
    ##                         "n": "author",
    ##                         "btl": "TRUE",
    ##                         "btr": "FALSE",
    ##                         "dtl": "string",
    ##                         "ill": "FALSE",
    ##                         "vl": "Donald Duck"
    ##                     },
    ##                     {
    ##                         "n": "description",
    ##                         "btl": "FALSE",
    ##                         "btr": "TRUE",
    ##                         "dtr": "string",
    ##                         "ilr": "TRUE",
    ##                         "vr": "sample network"
    ##                     }
    ##                 ]
    ##             }
    ##         ]
    ##     },
    ##     {
    ##         "status": [
    ##             {
    ##                 "error": "",
    ##                 "success": true
    ##             }
    ##         ]
    ##     }
    ## ]
    ## 

### The combined RCX network

The combined network adds the aspects of the right network to the left
network. For the `nodes` it is:

``` r
rcxMatchByNameTRUE$nodes
```

    ## Nodes:

The `nodeAttributes` have updated values for `propertyOf` for
`nodeAttributes` originating from the right network.

``` r
rcxMatchByNameTRUE$nodeAttributes
```

    ## Node attributes:

The dataframe for the `edges` contains updated values for `source` and
`target` for `edges` originating from the right network.

``` r
rcxMatchByNameTRUE$edges
```

    ## Edges:

The last aspect are the `edgeAttributes`, again with updated values for
`propertyOf` for the `edgeAttributes` originating from the right
network.

``` r
rcxMatchByNameTRUE$edgeAttributes
```

    ## Edge attributes:

### The NetworkDifferences aspect

The NetworkDifferences-aspect contains the information regarding the
differences of `nodes`, `nodeAttributes`, `edges`, `edgeAttributes`, and
`networkÀttributes`.

**The nodes-dataframe**

The `nodes`-dataframe tracks the differences of the `nodes` in eight
columns. The names of the columns depend on the `matchByName`-boolean.
If `matchByName` is `TRUE` the names of the columns are: `id`, `name`,
`representLeft`, `representRight`, `oldIdLeft`, `oldIdRight`,
`belongsToLeft`, and `belongsToRight`. If `matchByName` is `FALSE` the
names of the columns are: `id`, `name`, `representLeft`,
`representRight`, `oldIdLeft`, `oldIdRight`, `belongsToLeft`, and
`belongsToRight`.

*Example:* The left network has three nodes called A, B, and C with the
represents r1, r2, and r3.

``` r
left$nodes
```

    ## Nodes:

The right network has three nodes called A, B, and X with the represents
r1, r4, and r5.

``` r
right$nodes
```

    ## Nodes:

If `matchByName` is `TRUE`, the created `nodes`-dataframe of the
NetworkDifferences aspect is:

``` r
rcxMatchByNameTRUE$networkDifferences$nodes
```

If `matchByName` is `FALSE`, the created `nodes`-dataframe is:

``` r
rcxMatchByNameFALSE$networkDifferences$nodes
```

**The nodeAttributes-dataframe**

The `nodeAttributes`-dataframe tracks the differences of the
`nodeAttributes` in ten columns (`propertyOf`, `name`, `belongsToLeft`,
`belongsToRight`, `dataTypeLeft`, `dataTypeRight`, `isListLeft`,
`isListRight`, `valueLeft`, and `valueRight`). Two `nodeAttributes` are
equal if their `names` are equal and if they belong to the same node
(defined through `propertyOf`).

*Example:* The nodes from section 1.2.1 have `nodeAttributes`: In both
RCX-objects, the nodes with the id 0 and 1 have the attribute ‘type’.

``` r
left$nodeAttributes
```

    ## Node attributes:

``` r
right$nodeAttributes
```

    ## Node attributes:

If `matchByName` is `TRUE`, the `nodeAttributes`-dataframe of the
NetworkDifferences aspect is:

``` r
rcxMatchByNameTRUE$networkDifferences$nodeAttributes
```

If `matchByName` is `FALSE`, the `nodeAttributes`-dataframe is:

``` r
rcxMatchByNameFALSE$networkDifferences$nodeAttributes
```

**The edge-dataframe**

The `edges`-dataframe tracks the differences of the `edges` in eight
columns (`id`, `source`, `target`, `interaction`, `oldIdLeft`,
`oldIdRight`, `belongsToLeft`, and `belongsToRight`). Two `edges` are
equal if their `source` and `target` are equal (the `edges` are
undirected so `source` and `target` can be switched) and if the
`interaction` is equal or `NA` in both cases.

*Example:* Both RCX-objects from section 1.2.1 and 1.2.2 have three
edges which have the `interaction` ‘E1’, ‘E2’, and ‘E3’.

``` r
left$edges
```

    ## Edges:

``` r
right$edges
```

    ## Edges:

If `matchByName` is set to `TRUE`, the `edges`-dataframe of the
NetworkDifferences aspect is:

``` r
rcxMatchByNameTRUE$networkDifferences$edges
```

If `matchByName` is set to `FALSE`, the `edges`-dataframe is:

``` r
rcxMatchByNameFALSE$networkDifferences$edges
```

**The edgeAttributes-dataframe**

The `edgeAttributes`-dataframe tracks the differences of the
`edgeAttributes` in ten columns (`propertyOf`, `name`, `belongsToLeft`,
`belongsToRight`, `dataTypeLeft`, `dataTypeRight`, `isListLeft`,
`isListRight`, `valueLeft`, and `valueRight`). Two `edgeAttributes` are
equal if their `names` are equal and if they belong to the same edge
(defined through `propertyOf`).

*Example:* The edges from section 1.2.3 have edgeAttributes: In both
RCX-objects, the edges with the id 0 and 1 have the attribute ‘type’.

``` r
left$edgeAttributes
```

    ## Edge attributes:

``` r
right$edgeAttributes
```

    ## Edge attributes:

If `matchByName` is `TRUE`, the `edgeAttributes`-dataframe of the
NetworkDifferences aspect is:

``` r
rcxMatchByNameTRUE$networkDifferences$edgeAttributes
```

If `matchByName` is `FALSE`, the `edgeAttributes`-dataframe is:

``` r
rcxMatchByNameFALSE$networkDifferences$edgeAttributes
```

**The networkAttributes-dataframe**

The `networkAttributes`-dataframes tracks the differences of the
`networkAttributes` in nine columns (`name`, `belongsToLeft`,
`belongsToRight`, `dataTypeLeft`, `dataTypeRight`, `isListLeft`,
`isListRight`, `valueLeft`, and `valueRight`). Two `networkAttributes`
are equal if their `names` are equal.

*Example:* The left and right RCX-objects have networkAttributes: the
left RCX-object has the name ‘left network’ and the author ‘Donald
Duck’.

``` r
left$networkAttributes
```

    ## Network attributes:

The right RCX-object has the name ‘right network’ and the description
‘sample network’.

``` r
right$networkAttributes
```

    ## Network attributes:

The `networkAttributes`-dataframe of the NetworkDifferences aspect is:

``` r
rcxMatchByNameTRUE$networkDifferences$networkAttributes
```

## The JSON-Conversion

### Convert to CX

The RCX-objects including the NetworkDifferences aspect can be converted
into the json-based CX format and back in order to share the object. To
convert the RCX-object into CX, the `toCX` function from the RCX package
is used.

``` r
json <- RCX::toCX(rcxMatchByNameTRUE, verbose = TRUE, pretty = TRUE)
```

    ## Processing standard aspects: RCX$metaData:
    ## Convert meta-data to JSON...done!
    ## Processing standard aspects: RCX$nodes:
    ## Convert nodes to JSON...done!
    ## Processing standard aspects: RCX$edges:
    ## Convert edges to JSON...done!
    ## Processing standard aspects: RCX$nodeAttributes:
    ## Convert node attributes to JSON...done!
    ## Processing standard aspects: RCX$edgeAttributes:
    ## Convert edge attributes to JSON...done!
    ## Processing non-standard aspects: RCX$networkDifferences:
    ## Convert NetworkDifferences to JSON...done!
    ## Done with RCX!

``` r
json
```

    ## [
    ##     {
    ##         "numberVerification": [
    ##             {
    ##                 "longNumber": 2147483647
    ##             }
    ##         ]
    ##     },
    ##     {
    ##         "metaData": [
    ##             {
    ##                 "name": "nodes",
    ##                 "version": "1.0",
    ##                 "idCounter": 5,
    ##                 "elementCount": 6,
    ##                 "consistencyGroup": 1
    ##             },
    ##             {
    ##                 "name": "edges",
    ##                 "version": "1.0",
    ##                 "idCounter": 5,
    ##                 "elementCount": 6,
    ##                 "consistencyGroup": 1
    ##             },
    ##             {
    ##                 "name": "nodeAttributes",
    ##                 "version": "1.0",
    ##                 "elementCount": 4,
    ##                 "consistencyGroup": 1
    ##             },
    ##             {
    ##                 "name": "edgeAttributes",
    ##                 "version": "1.0",
    ##                 "elementCount": 4,
    ##                 "consistencyGroup": 1
    ##             }
    ##         ]
    ##     },
    ##     {
    ##         "nodes": [
    ##             {
    ##                 "@id": 0,
    ##                 "n": "A",
    ##                 "r": "r1",
    ##                 "oldId": 0
    ##             },
    ##             {
    ##                 "@id": 1,
    ##                 "n": "B",
    ##                 "r": "r2",
    ##                 "oldId": 1
    ##             },
    ##             {
    ##                 "@id": 2,
    ##                 "n": "C",
    ##                 "r": "r3",
    ##                 "oldId": 2
    ##             },
    ##             {
    ##                 "@id": 3,
    ##                 "n": "A",
    ##                 "r": "r1",
    ##                 "oldId": 0
    ##             },
    ##             {
    ##                 "@id": 4,
    ##                 "n": "B",
    ##                 "r": "r4",
    ##                 "oldId": 1
    ##             },
    ##             {
    ##                 "@id": 5,
    ##                 "n": "X",
    ##                 "r": "r5",
    ##                 "oldId": 2
    ##             }
    ##         ]
    ##     },
    ##     {
    ##         "edges": [
    ##             {
    ##                 "@id": 0,
    ##                 "s": 0,
    ##                 "t": 1,
    ##                 "i": "E1",
    ##                 "oldId": 0
    ##             },
    ##             {
    ##                 "@id": 1,
    ##                 "s": 1,
    ##                 "t": 2,
    ##                 "i": "E2",
    ##                 "oldId": 1
    ##             },
    ##             {
    ##                 "@id": 2,
    ##                 "s": 2,
    ##                 "t": 0,
    ##                 "i": "E3",
    ##                 "oldId": 2
    ##             },
    ##             {
    ##                 "@id": 3,
    ##                 "s": 3,
    ##                 "t": 4,
    ##                 "i": "E1",
    ##                 "oldId": 0
    ##             },
    ##             {
    ##                 "@id": 4,
    ##                 "s": 4,
    ##                 "t": 5,
    ##                 "i": "E2",
    ##                 "oldId": 1
    ##             },
    ##             {
    ##                 "@id": 5,
    ##                 "s": 5,
    ##                 "t": 3,
    ##                 "i": "E3",
    ##                 "oldId": 2
    ##             }
    ##         ]
    ##     },
    ##     {
    ##         "nodeAttributes": [
    ##             {
    ##                 "po": 0,
    ##                 "n": "type",
    ##                 "v": "w",
    ##                 "d": "string"
    ##             },
    ##             {
    ##                 "po": 1,
    ##                 "n": "type",
    ##                 "v": [
    ##                     "x",
    ##                     "y"
    ##                 ],
    ##                 "d": "list_of_string"
    ##             },
    ##             {
    ##                 "po": 3,
    ##                 "n": "type",
    ##                 "v": "z",
    ##                 "d": "string"
    ##             },
    ##             {
    ##                 "po": 4,
    ##                 "n": "type",
    ##                 "v": [
    ##                     "x",
    ##                     "y"
    ##                 ],
    ##                 "d": "list_of_string"
    ##             }
    ##         ]
    ##     },
    ##     {
    ##         "edgeAttributes": [
    ##             {
    ##                 "po": 0,
    ##                 "n": "type",
    ##                 "v": "k",
    ##                 "d": "string"
    ##             },
    ##             {
    ##                 "po": 1,
    ##                 "n": "type",
    ##                 "v": "l",
    ##                 "d": "string"
    ##             },
    ##             {
    ##                 "po": 3,
    ##                 "n": "type",
    ##                 "v": "n",
    ##                 "d": "string"
    ##             },
    ##             {
    ##                 "po": 4,
    ##                 "n": "type",
    ##                 "v": [
    ##                     "l",
    ##                     "m"
    ##                 ],
    ##                 "d": "list_of_string"
    ##             }
    ##         ]
    ##     },
    ##     {
    ##         "NetworkDifferencesAspect": [
    ##             {
    ##                 "matchByName": "true"
    ##             },
    ##             {
    ##                 "nodes": [
    ##                     {
    ##                         "@id": "0",
    ##                         "n": "A",
    ##                         "rl": "r1",
    ##                         "rr": "r1",
    ##                         "oil": "0",
    ##                         "oir": "0",
    ##                         "btl": "TRUE",
    ##                         "btr": "TRUE"
    ##                     },
    ##                     {
    ##                         "@id": "1",
    ##                         "n": "B",
    ##                         "rl": "r2",
    ##                         "rr": "r4",
    ##                         "oil": "1",
    ##                         "oir": "1",
    ##                         "btl": "TRUE",
    ##                         "btr": "TRUE"
    ##                     },
    ##                     {
    ##                         "@id": "2",
    ##                         "n": "C",
    ##                         "rl": "r3",
    ##                         "oil": "2",
    ##                         "btl": "TRUE",
    ##                         "btr": "FALSE"
    ##                     },
    ##                     {
    ##                         "@id": "3",
    ##                         "n": "X",
    ##                         "rr": "r5",
    ##                         "oir": "2",
    ##                         "btl": "FALSE",
    ##                         "btr": "TRUE"
    ##                     }
    ##                 ]
    ##             },
    ##             {
    ##                 "nodeAttributes": [
    ##                     {
    ##                         "po": "0",
    ##                         "n": "type",
    ##                         "btl": "TRUE",
    ##                         "btr": "TRUE",
    ##                         "dtl": "string",
    ##                         "dtr": "string",
    ##                         "ill": "FALSE",
    ##                         "ilr": "FALSE",
    ##                         "vl": "w",
    ##                         "vr": "z"
    ##                     },
    ##                     {
    ##                         "po": "1",
    ##                         "n": "type",
    ##                         "btl": "TRUE",
    ##                         "btr": "TRUE",
    ##                         "dtl": "string",
    ##                         "dtr": "string",
    ##                         "ill": "TRUE",
    ##                         "ilr": "TRUE",
    ##                         "vl": "c(\"x\", \"y\")",
    ##                         "vr": "c(\"x\", \"y\")"
    ##                     }
    ##                 ]
    ##             },
    ##             {
    ##                 "edges": [
    ##                     {
    ##                         "@id": "0",
    ##                         "s": "0",
    ##                         "t": "1",
    ##                         "i": "E1",
    ##                         "oil": "0",
    ##                         "oir": "0",
    ##                         "btl": "TRUE",
    ##                         "btr": "TRUE"
    ##                     },
    ##                     {
    ##                         "@id": "1",
    ##                         "s": "1",
    ##                         "t": "2",
    ##                         "i": "E2",
    ##                         "oil": "1",
    ##                         "btl": "TRUE",
    ##                         "btr": "FALSE"
    ##                     },
    ##                     {
    ##                         "@id": "2",
    ##                         "s": "2",
    ##                         "t": "0",
    ##                         "i": "E3",
    ##                         "oil": "2",
    ##                         "btl": "TRUE",
    ##                         "btr": "FALSE"
    ##                     },
    ##                     {
    ##                         "@id": "3",
    ##                         "s": "1",
    ##                         "t": "3",
    ##                         "i": "E2",
    ##                         "oir": "1",
    ##                         "btl": "FALSE",
    ##                         "btr": "TRUE"
    ##                     },
    ##                     {
    ##                         "@id": "4",
    ##                         "s": "3",
    ##                         "t": "0",
    ##                         "i": "E3",
    ##                         "oir": "2",
    ##                         "btl": "FALSE",
    ##                         "btr": "TRUE"
    ##                     }
    ##                 ]
    ##             },
    ##             {
    ##                 "edgeAttributes": [
    ##                     {
    ##                         "po": "0",
    ##                         "n": "type",
    ##                         "btl": "TRUE",
    ##                         "btr": "TRUE",
    ##                         "dtl": "string",
    ##                         "dtr": "string",
    ##                         "ill": "FALSE",
    ##                         "ilr": "FALSE",
    ##                         "vl": "k",
    ##                         "vr": "n"
    ##                     },
    ##                     {
    ##                         "po": "1",
    ##                         "n": "type",
    ##                         "btl": "TRUE",
    ##                         "btr": "FALSE",
    ##                         "dtl": "string",
    ##                         "ill": "FALSE",
    ##                         "vl": "l"
    ##                     },
    ##                     {
    ##                         "po": "3",
    ##                         "n": "type",
    ##                         "btl": "FALSE",
    ##                         "btr": "TRUE",
    ##                         "dtr": "string",
    ##                         "ilr": "TRUE",
    ##                         "vr": "c(\"l\", \"m\")"
    ##                     }
    ##                 ]
    ##             },
    ##             {
    ##                 "networkAttributes": [
    ##                     {
    ##                         "n": "name",
    ##                         "btl": "TRUE",
    ##                         "btr": "TRUE",
    ##                         "dtl": "string",
    ##                         "dtr": "string",
    ##                         "ill": "FALSE",
    ##                         "ilr": "FALSE",
    ##                         "vl": "left network",
    ##                         "vr": "right network"
    ##                     },
    ##                     {
    ##                         "n": "author",
    ##                         "btl": "TRUE",
    ##                         "btr": "FALSE",
    ##                         "dtl": "string",
    ##                         "ill": "FALSE",
    ##                         "vl": "Donald Duck"
    ##                     },
    ##                     {
    ##                         "n": "description",
    ##                         "btl": "FALSE",
    ##                         "btr": "TRUE",
    ##                         "dtr": "string",
    ##                         "ilr": "TRUE",
    ##                         "vr": "sample network"
    ##                     }
    ##                 ]
    ##             }
    ##         ]
    ##     },
    ##     {
    ##         "status": [
    ##             {
    ##                 "error": "",
    ##                 "success": true
    ##             }
    ##         ]
    ##     }
    ## ]
    ## 

### Import to CX

The re-conversion is the responsibility of the function `processCX` but
before the json-string has to be parsed. The RCX-object is printed and
it is identical to the original RCX object.

``` r
jsonParsed <- RCX:::parseJSON(json)
rcx <- RCX:::processCX(jsonParsed, verbose = TRUE)
```

    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## Parsing nodes...create aspect...done!
    ## Create RCX from parsed nodes...$aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## done!
    ## Parsing edges...create aspect...done!
    ## Add aspect "edges" to RCX...$aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## done!
    ## Parsing node attributes...create aspect...done!
    ## Add aspect "nodeAttributes" to RCX...$aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## done!
    ## Parsing edge attributes...create aspect...done!
    ## Add aspect "edgeAttributes" to RCX...$aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## done!
    ## Parsing meta-data...done!
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## Ignore "numberVerification" aspect, not necessary in RCX!
    ## Can't process aspect "numberVerification", so skip it...done!
    ## Parsing networkDifferences...create aspect...done!
    ## Add aspect "NetworkDifferencesAspect" to RCX...done!
    ## Ignore "status" aspect, not necessary in RCX!
    ## Can't process aspect "status", so skip it...done!

``` r
rcx
```

    ## [[metaData]] = Meta-data:
    ## 
    ## [[nodes]] = Nodes:
    ## 
    ## [[edges]] = Edges:
    ## 
    ## [[nodeAttributes]] = Node attributes:
    ## 
    ## [[edgeAttributes]] = Edge attributes:
    ## 
    ## [[networkDifferences]] = Network differences:
    ## MatchByName:
    ## TRUE
    ## Nodes:
    ## NodeAttributes:
    ## Edges:
    ## EdgeAttributes:
    ## NetworkAttributes:

## The Conversion of the Networkdifferences aspect to RCX-objects

The NetworkDifferences aspect can be converted to RCX-objects in order
to visualize the differences of the RCX-objects `left` and `right`.
There are three options: node-centered, edge-centered and a combined
version. The user can decide if the names and the values of the `node-`
or `edgeAttributes` should be included. The `networkAttributes` are not
visualized as they are not considered to be important.

The elements that exist in both RCX-objects are colored gray, the
elements that exist only in the left RCX-object are colored in light
blue and the elements that exist only in the right RCX-object are
orange. The shapes for the nodes are:

| RCX Element         | Shape                        |
|---------------------|------------------------------|
| node names          | round                        |
| node represents     | triangle                     |
| edge                | rectangle                    |
| nodeAttributes name | hexagon                      |
| nodeAttribute value | parallelogram                |
| edgeAttribute name  | rectangle with round corners |
| edgeAttribute value | diamond                      |

### Node-centered RCX-objects

With the node-centered RCX-objects the user can visualize the
differences of the two given RCX-objects regarding the `nodes` and, if
wished, the names and values of the `nodeAttributes`. The
`exportDifferencesToNodeNetwork`-function has the
`includeNamesAndRepresents`-parameter; if this parameter is set to
`FALSE`, either the `represents` or the `names` are visualized
(depending on `matchByName`); if `includeNamesAndRepresents` is set to
`TRUE`, both `names` and `represents` are visualized.

A cartesian layout is assigned to the RCX-object that structures the
nodes in up to four layers: the innermost layer is for the nodes that
belong to both networks, the next layer for the nodes that belongs
either to the left or right RCX-object, the third layer (optional) is
for the names of the nodeAttributes and the fourth layer (optional) is
for the values of the nodeAttributes.

The position of the circles can be changed with several parameters:

-   `startLayerBoth` has the default value 5 and determines the position
    at which the circles for the nodes that belong to both RCX-objects
    start

-   `startLayerLeftRight` has the default value 10 and determines the
    position at which the circles for the nodes that belong only to one
    RCX-objects start (it must be greater than `startLayerLeftRight`).
    The nodes that belong to the left network are in the left half and
    the nodes of the right network are located in the right half.

-   `startLayerAttributes` has the default value 0 and if this parameter
    is greater than `startLayerLeftRight`, it determines the position at
    which the circles for the names of the nodeAttributes start. The
    nodeAttributes that belong to both networks are located in the upper
    half of the circles, the nodeAttributes that belong to the left
    respectively right network are located in the lower left/right
    quadrant.

-   `startLayerValues` has the default value 0 and if this parameter is
    greater than `startLayerAttributes`, it determines the position at
    which the circles for the values of the nodeAttributes start. The
    values of the nodeAttributes that belong to both networks are
    located in the upper half (there can be one gray node if the values
    are equal in both networks or two nodes (blue and orange) if the
    values are different), the values of nodeAttributes that belongs
    only to one network are located in the lower left/right sector.

The following figure shows the the differences of the RCX-objects from
the section 1.2 with `matchByName` set to `TRUE`.

``` r
nodeNetwork <- exportDifferencesToNodeNetwork(
    rcxMatchByNameTRUE$networkDifferences, includeNamesAndRepresents = FALSE,
    startLayerBoth = 1, startLayerLeftRight = 2, startLayerAttributes = 3,
    startLayerValues = 4
)
```

    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect"

``` r
visualize(nodeNetwork)
```

<img src="The_networkDifferences_Aspect/nodes_matchByName.png"
style="width:100.0%"
alt="Node-centered RCX-object with matchByName TRUE" /> The next figure
shows the result if `matchByName` is set to `FALSE`.

``` r
nodeNetwork <- exportDifferencesToNodeNetwork(
    rcxMatchByNameFALSE$networkDifferences, includeNamesAndRepresents = FALSE,
    startLayerBoth = 1, startLayerLeftRight = 2, startLayerAttributes = 3,
    startLayerValues = 4
)
```

    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect"

``` r
visualize(nodeNetwork)
```

<img src="The_networkDifferences_Aspect/nodes_matchByRepresent.png"
style="width:100.0%"
alt="Node-centered RCX-object with matchByName FALSE" /> The last figure
shows the results if `matchByName` and `includeNamesAndRepresents`are
`TRUE`.

``` r
nodeNetwork <- exportDifferencesToNodeNetwork(
    rcxMatchByNameTRUE$networkDifferences, includeNamesAndRepresents = TRUE,
    startLayerBoth = 1, startLayerLeftRight = 2, startLayerAttributes = 3,
    startLayerValues = 4
)
```

    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx 
    ##                      "RCX" 
    ##                   metaData 
    ##           "MetaDataAspect" 
    ##                      nodes 
    ##              "NodesAspect" 
    ##                      edges 
    ##              "EdgesAspect" 
    ##             nodeAttributes 
    ##     "NodeAttributesAspect" 
    ##             edgeAttributes 
    ##     "EdgeAttributesAspect" 
    ##          networkAttributes 
    ##  "NetworkAttributesAspect" 
    ##            cartesianLayout 
    ##    "CartesianLayoutAspect" 
    ##                   cyGroups 
    ##           "CyGroupsAspect" 
    ##         cyVisualProperties 
    ## "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes 
    ## "CyHiddenAttributesAspect" 
    ##         cyNetworkRelations 
    ## "CyNetworkRelationsAspect" 
    ##              cySubNetworks 
    ##      "CySubNetworksAspect" 
    ##              cyTableColumn 
    ##      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect"

``` r
visualize(nodeNetwork)
```

<figure>
<img src="The_networkDifferences_Aspect/nodes_matchByNameRepresent.png"
style="width:100.0%"
alt="Node-centered RCX-object with matchByName TRUE and includeNamesAndRepresents TRUE" />
<figcaption aria-hidden="true">Node-centered RCX-object with matchByName
TRUE and includeNamesAndRepresents TRUE</figcaption>
</figure>

### Edge-centered RCX-objects

With the edge-centered RCX-objects the user can visualize the
differences of the two given RCX-objects regarding the `edges` and, if
wished, the names and values of the `edgeAttributes`. Like before, there
are the parameters `startLayerBoth`, `startLayerLeftRight`,
`startLayerAttributes`, and `startLayerValues` to define the position of
the nodes representing the `edges` and the names and values of the
`edgeAttributes` (for more details see section 2.1).

The following figure shows the edge-centered RCX-object if `matchByName`
is `TRUE`.

``` r
edgeNetwork <- exportDifferencesToEdgeNetwork(
    rcxMatchByNameTRUE$networkDifferences, startLayerBoth = 1,
    startLayerLeftRight = 2, startLayerAttributes = 3, startLayerValues = 4
)
```

    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect"

``` r
visualize(edgeNetwork)
```

<img src="The_networkDifferences_Aspect/edges_matchByName.png"
style="width:100.0%"
alt="Edge-centered RCX-object with matchByName TRUE" /> The next figure
shows the result if `matchByName` is `FALSE`.

``` r
edgeNetwork <- exportDifferencesToEdgeNetwork(
    rcxMatchByNameFALSE$networkDifferences, startLayerBoth = 1,
    startLayerLeftRight = 2, startLayerAttributes = 3, startLayerValues = 4
)
```

    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect"

``` r
visualize(edgeNetwork)
```

<figure>
<img src="The_networkDifferences_Aspect/edges_matchByRepresent.png"
style="width:100.0%"
alt="Edge-centered RCX-object with matchByName FALSE" />
<figcaption aria-hidden="true">Edge-centered RCX-object with matchByName
FALSE</figcaption>
</figure>

### Node- and edge-centered RCX-objects

The last option are the creation of RCX-Objects that show the
differences regarding the `nodes`, the `edges`, and the `node-` and
`edgeAttributes`. The parameters are the same as for the node-centered
option (section 2.1).

The following figure shows the node- and edge-centered RCX-object for
the RCX-objects from section 1 with `node-` and `edgeAttributes`
(`matchByName` is `TRUE`).

``` r
nodeEdgeNetwork <- exportDifferencesToNodeEdgeNetwork(
    rcxMatchByNameTRUE$networkDifferences, startLayerBoth = 1,
    startLayerLeftRight = 2, startLayerAttributes = 3, startLayerValues = 4
)
```

    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect"

``` r
visualize(nodeEdgeNetwork)
```

<img src="The_networkDifferences_Aspect/nodesEdges_attributes.png"
style="width:100.0%"
alt="Node- and edge-centered RCX-object with matchByName TRUE and the visualization of the node- and edgeAtrributes" />
The last figure shows the RCX-objects but without the `node-` and
`edgeAttributes`.

``` r
nodeEdgeNetwork <- exportDifferencesToNodeEdgeNetwork(
    rcxMatchByNameTRUE$networkDifferences, startLayerBoth = 1,
    startLayerLeftRight = 2, startLayerAttributes = 0, startLayerValues = 0
)
```

    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect"

``` r
visualize(nodeEdgeNetwork)
```

<figure>
<img src="The_networkDifferences_Aspect/nodesEdges.png"
style="width:100.0%"
alt="Node- and edge-centered RCX-object with matchByName TRUE without the visualization of the node- and edgeAttributes" />
<figcaption aria-hidden="true">Node- and edge-centered RCX-object with
matchByName TRUE without the visualization of the node- and
edgeAttributes</figcaption>
</figure>

# Real-life example

The example from section 1 illustrates how the differences of the two
RCX-objects are tracked and visualized but it is kept very simple. This
section shows how the NetworkDifferences aspect can be applied to a real
life example whereby the two RCX objects represent breast cancer
patients.

## Extract the subnetworks

The two RCX-objects can be extracted from the “Combined patient-specific
breast cancer subnetworks” (UUID a420aaee-4be9-11ec-b3be-0ac135e8bacf on
NDEx) and they show the networks of two breast cancer patients. These
networks have nodes that represent genes, edges between the nodes, and
nodeAttributes for the gene expression, gene expression level, and
relevance score whereby the patient id is part of the name of the
nodeAttributes. On the basis of the names of the nodeAttributes the
nodes for a given patient id can be extracted. Then the edges and the
nodeAttributes for the patient id are filtered and in the end, the
patient id is removed from the name of the nodeAttributes.

The patient with the ID GSM615195 and the patient with the ID GSM615184
are selected for this example whereby the patient GSM615195 has
developed metastasis within the first five years after the cancer
diagnosis and patient GSM615184 remained metastasis-free. We filter the
nodeAttributes and only focus on the gene expression level (values are
‘high’, ‘normal’, and ‘low’). Visualizing the differences of two
patients can help to determine the reasons for the
metastasis-development.

``` r
library(ndexr)
```

    ## Registered S3 method overwritten by 'ndexr':
    ##   method    from
    ##   print.RCX RCX

``` r
uuid <- "a420aaee-4be9-11ec-b3be-0ac135e8bacf"
ndex_con <- ndex_connect()
rcx <- ndex_get_network(ndex_con, uuid)
```

    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect"

``` r
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
```

    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect"

``` r
rcxGSM615184 <- getSubnetwork("GSM615184", rcx, filterNodeAttributes = "GE_Level")
```

    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect"

First, we take a look at the RCX-object of the patient GSM615195.

``` r
summary(rcxGSM615195)
```

    ## $nodes
    ##      id           name          
    ##  Total: 112   Length:112        
    ##  Min. :   0   Class :character  
    ##  Max. :2920   Mode  :character  
    ## 
    ## $metaData
    ##      name             version            idCounter      elementCount  
    ##  Length:3           Length:3           Min.   : 2920   Min.   :112.0  
    ##  Class :character   Class :character   1st Qu.: 4699   1st Qu.:112.0  
    ##  Mode  :character   Mode  :character   Median : 6478   Median :112.0  
    ##                                        Mean   : 6478   Mean   :130.3  
    ##                                        3rd Qu.: 8256   3rd Qu.:139.5  
    ##                                        Max.   :10035   Max.   :167.0  
    ##                                        NA's   :1                      
    ##  consistencyGroup
    ##  Min.   :1       
    ##  1st Qu.:1       
    ##  Median :1       
    ##  Mean   :1       
    ##  3rd Qu.:1       
    ##  Max.   :1       
    ##                  
    ## 
    ## $edges
    ##      id               source            target    
    ##  Total:  167   Total     : 167   Total     : 167  
    ##  Min. :    0   Unique ids:  83   Unique ids:  69  
    ##  Max. :10035   Min.      :   0   Min.      :   2  
    ##                Max.      :1118   Max.      :2920  
    ## 
    ## $nodeAttributes
    ##       propertyOf       name              value    
    ##  Total     : 112   Length:112         String:112  
    ##  Unique ids: 112   Unique:1                       
    ##  Min.      :   0   Class :character               
    ##  Max.      :2920

Now, we check out the patient GSM615184 .

``` r
summary(rcxGSM615184)
```

    ## $nodes
    ##      id           name          
    ##  Total: 110   Length:110        
    ##  Min. :   0   Class :character  
    ##  Max. :3714   Mode  :character  
    ## 
    ## $metaData
    ##      name             version            idCounter      elementCount  
    ##  Length:3           Length:3           Min.   : 3714   Min.   :110.0  
    ##  Class :character   Class :character   1st Qu.: 6547   1st Qu.:110.0  
    ##  Mode  :character   Mode  :character   Median : 9380   Median :110.0  
    ##                                        Mean   : 9380   Mean   :124.7  
    ##                                        3rd Qu.:12214   3rd Qu.:132.0  
    ##                                        Max.   :15047   Max.   :154.0  
    ##                                        NA's   :1                      
    ##  consistencyGroup
    ##  Min.   :1       
    ##  1st Qu.:1       
    ##  Median :1       
    ##  Mean   :1       
    ##  3rd Qu.:1       
    ##  Max.   :1       
    ##                  
    ## 
    ## $edges
    ##      id               source            target    
    ##  Total:  154   Total     : 154   Total     : 154  
    ##  Min. :    0   Unique ids:  70   Unique ids:  74  
    ##  Max. :15047   Min.      :   0   Min.      :   2  
    ##                Max.      :1854   Max.      :3714  
    ## 
    ## $nodeAttributes
    ##       propertyOf       name              value    
    ##  Total     : 110   Length:110         String:110  
    ##  Unique ids: 110   Unique:1                       
    ##  Min.      :   0   Class :character               
    ##  Max.      :3714

## Visualize the differences of the nodes

Now the visualization of the differences regarding only the nodes is
created.

``` r
netDif <- compareNetworks(rcxGSM615195, rcxGSM615184, TRUE)
```

    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect"

``` r
nodesNetwork <- exportDifferencesToNodeNetwork(netDif$networkDifferences)
```

    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect"

``` r
visualize(nodesNetwork)
```

<img src="The_networkDifferences_Aspect/nodesNetwork.png"
style="width:100.0%"
alt="Node-centered RCX-object to visualize the differences regarding the nodes of the patients GSM615195 and GSM615184" />
We can see that about half of the genes that are shown in this network
exist in both networks. These differences might be the reason for the
differences in the development of metastasis.

## Visualize the differences regarding the nodeAttributes

Next, we include the names and the values of the nodeAttributes
‘GE-Level’ and see a detailed visualization of the differences of the
two RCX-objects. We can see that about half of the nodeAttributes belong
to nodes that exist in both networks and about 50% of them have
different values. These differences in the gene expression may lead to
the differences in the development of metastasis.

``` r
nodesAttributesValuesNetwork <- exportDifferencesToNodeNetwork(
    netDif$networkDifferences, startLayerAttributes = 15,
    startLayerValues = 20
)
```

    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect" 
    ## 
    ## 
    ## $aspectClasses
    ##                        rcx                   metaData 
    ##                      "RCX"           "MetaDataAspect" 
    ##                      nodes                      edges 
    ##              "NodesAspect"              "EdgesAspect" 
    ##             nodeAttributes             edgeAttributes 
    ##     "NodeAttributesAspect"     "EdgeAttributesAspect" 
    ##          networkAttributes            cartesianLayout 
    ##  "NetworkAttributesAspect"    "CartesianLayoutAspect" 
    ##                   cyGroups         cyVisualProperties 
    ##           "CyGroupsAspect" "CyVisualPropertiesAspect" 
    ##         cyHiddenAttributes         cyNetworkRelations 
    ## "CyHiddenAttributesAspect" "CyNetworkRelationsAspect" 
    ##              cySubNetworks              cyTableColumn 
    ##      "CySubNetworksAspect"      "CyTableColumnAspect" 
    ## 
    ## $extensions
    ## $extensions$RCXNetworkDifferences
    ##         networkDifferences 
    ## "NetworkDifferencesAspect"

``` r
visualize(nodesAttributesValuesNetwork)
```

<figure>
<img src="The_networkDifferences_Aspect/nodesGELevel.png"
style="width:100.0%"
alt="Node-centered RCX-object to visualize the differences regarding the nodes of the patients GSM615195 and GSM615184" />
<figcaption aria-hidden="true">Node-centered RCX-object to visualize the
differences regarding the nodes of the patients GSM615195 and
GSM615184</figcaption>
</figure>

# Session info

``` r
sessionInfo()
```

    ## R version 4.2.2 Patched (2022-11-10 r83330)
    ## Platform: x86_64-pc-linux-gnu (64-bit)
    ## Running under: Linux Mint 20.3
    ## 
    ## Matrix products: default
    ## BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.9.0
    ## LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.9.0
    ## 
    ## locale:
    ##  [1] LC_CTYPE=de_DE.UTF-8       LC_NUMERIC=C              
    ##  [3] LC_TIME=de_DE.UTF-8        LC_COLLATE=de_DE.UTF-8    
    ##  [5] LC_MONETARY=de_DE.UTF-8    LC_MESSAGES=de_DE.UTF-8   
    ##  [7] LC_PAPER=de_DE.UTF-8       LC_NAME=C                 
    ##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
    ## [11] LC_MEASUREMENT=de_DE.UTF-8 LC_IDENTIFICATION=C       
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] stringr_1.5.0               ndexr_1.20.1               
    ## [3] RCXNetworkDifferences_1.0.0 RCX_1.2.1                  
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.9          rstudioapi_0.14     knitr_1.41         
    ##  [4] magrittr_2.0.3      R6_2.5.1            rlang_1.0.6        
    ##  [7] fastmap_1.1.0       httr_1.4.4          plyr_1.8.8         
    ## [10] tools_4.2.2         xfun_0.36           cli_3.6.0          
    ## [13] htmltools_0.5.4     yaml_2.3.6          digest_0.6.31      
    ## [16] lifecycle_1.0.3     BiocManager_1.30.19 formatR_1.13       
    ## [19] vctrs_0.5.1         rsconnect_0.8.29    curl_5.0.0         
    ## [22] glue_1.6.2          evaluate_0.19       rmarkdown_2.19     
    ## [25] stringi_1.7.12      compiler_4.2.2      BiocStyle_2.26.0   
    ## [28] jsonlite_1.8.4
