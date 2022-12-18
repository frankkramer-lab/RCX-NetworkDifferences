# The NetworkDifferences-Aspect

The `NetworkDifferences` aspect allows the tracking and visualization of
the differences of two RCX-objects. The first part of this vignette
explains in detail how this aspect works. At the end we take a closer
look at a real life example. Many biological entities like proteins and
genes are represented as biological networks and comparing these
networks can help to answer questions in medical research. The example
illustrates how the `NetworkDifferences` aspect can be used to visualize
the differences regarding genes, gene expression and other aspects of
two breast cancer patients.

The `NetworkDifferences` aspect website is available at
<https://github.com/frankkramer-lab/RCX-NetworkDifferences>

The `NetworkDifferences` aspect tracks the differences regarding the
`nodes`, `nodeAttributes`, `edges`, `edgeAttributes`, and
`networkAttributes` of two RCX-objects. First, two RCX-objects `left`
and `right` are created that will be used as examples later.

``` r
left <- createRCX(
    nodes = createNodes(
        id = 0:2, name = c("A", "B", "C"),
        represents = c("r1", "r2", "r3")
    ),
    edges = createEdges(
        source = c(0, 1, 2),
        target = c(1, 2, 0),
        interaction = c("E1", "E2", "E3")
    )
)
left <- updateNodeAttributes(
    left, createNodeAttributes(
        propertyOf = c(0, 1),
        name = rep("type", 2),
        value = list("w", c("x", "y"))
    )
)
left <- updateEdgeAttributes(
    left, createEdgeAttributes(
        propertyOf = c(0, 1),
        name = rep("type", 2),
        value = c("k", "l")
    )
)
left <- updateNetworkAttributes(
    left, createNetworkAttributes(
        name = c("name", "author"),
        value = c("left network", "Donald Duck")
    )
)
```

``` r
right <- createRCX(
    nodes = createNodes(
        name = c("A", "B", "X"),
        represents = c("r1", "r4", "r5")
    ),
    edges = createEdges(
        source = c(0, 1, 2),
        target = c(1, 2, 0),
        interaction = c("E1", "E2", "E3")
    )
)
right <- updateNodeAttributes(
    right, createNodeAttributes(
        propertyOf = c(0, 1),
        name = c("type", "type"),
        value = list("z", c("x", "y"))
    )
)
right <- updateEdgeAttributes(
    right, createEdgeAttributes(
        propertyOf = c(0, 1),
        name = rep("type", 2),
        value = list("k", c("l", "m"))
    )
)
right <- updateNetworkAttributes(
    right, createNetworkAttributes(
        name = c("name", "description"),
        value = c("right network", "sample network")
    )
)
```

Now, we have two RCX-objects and with the `compareNetworks`-function we
can track their differences. To illustrate the difference between
`matchByName` set to `TRUE` respectively `FALSE`, we define two
RCX-objects called `rcxMatchByNameTRUE` and `rcxMatchByNameFALSE`.

``` r
rcxMatchByNameTRUE <- compareNetworks(left, right, matchByName = TRUE)
rcxMatchByNameFALSE <- compareNetworks(left, right, matchByName = FALSE)
```

## The compareNetworks-function

The `compareNetworks`-function is provided to track the differences
regarding the `nodes`, `nodeAttributes`, `edges`, `edgeAttributes`, and
`networkAttributes`. The function has three parameters: the two
RCX-objects `left` and `right`, and the boolean `matchByName`. The names
`left` and `right` are based on the join-operation. If `matchByName` is
`TRUE`, two nodes are equal when their names are equal; if `matchByName`
is `FALSE`, two nodes are equal when their represents are equal.

The function returns an RCX network whereby the `nodes`,
`nodeAttributes`, `edges`, and `edgeAttributes` of the right network are
appended to the corresponding aspects of the left network. The
`networkAttributes` are ignored as it is not possible to append the
`networkAttributes` of the right network to the `networkAttributes` of
the left network if the `networkAttributes` have the same name. An
additional aspect called the `NetworkDifferences` aspect is added to the
RCX network. It is a list with the `matchByName`-boolean and five
dataframes to track the differences of `nodes`, `nodeAttributes`,
`edges`, `edgeAttributes`, and `networkAttributes` of the two RCX
objects.

### The combined RCX network

The combined network adds the aspects of the right network to the left
network. This is independent from the `matchByName`-boolean. For the
`nodes` it looks like this:

``` r
rcxMatchByNameTRUE$nodes
```

    ## Nodes:

The dataframe for the `nodeAttributes` has updated values for
`propertyOf` for the `nodeAttributes` of the right network.

``` r
rcxMatchByNameTRUE$nodeAttributes
```

    ## Node attributes:

The dataframe for the `edges` contains updated values for `source` and
`target` for the `edges` of the right network.

``` r
rcxMatchByNameTRUE$edges
```

    ## Edges:

The last aspect are the `edgeAttributes`, again with updated values for
`propertyOf` for the `edgeAttributes` of the right network.

``` r
rcxMatchByNameTRUE$edgeAttributes
```

    ## Edge attributes:

### The networkDifferences-aspect

The `NetworkDifferences`-aspect contains the information regarding the
differences of the `nodes`, `nodeAttributes`, `edges`, `edgeAttributes`,
and `networkÀttributes`.

#### The nodes-dataframe

The `nodes`-dataframe tracks the differences of the `nodes` in eight
columns. The names of the columns depend on the `matchByName`-boolean.
If `matchByName` is `TRUE` the names of the columns are: `id`, `name`,
`representLeft`, `representRight`, `oldIdLeft`, `oldIdRight`,
`belongsToLeft`, and `belongsToRight`. If `matchByName` is `FALSE` the
names of the columns are: `id`, `name`, `representLeft`,
`representRight`, `oldIdLeft`, `oldIdRight`, `belongsToLeft`, and
`belongsToRight`.

Example: The left network has three nodes called A, B, and C with the
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

If `matchByName` is `TRUE`, the created `nodes`-dataframe is:

``` r
rcxMatchByNameTRUE$networkDifferences$nodes
```

If `matchByName` is `FALSE`, the created `nodes`-dataframe is:

``` r
rcxMatchByNameFALSE$networkDifferences$nodes
```

#### The nodeAttributes-dataframe

The `nodeAttributes`-dataframes tracks the differences of the
`nodeAttributes` in ten columns. The names of the columns are:
`propertyOf`, `name`, `belongsToLeft`, `belongsToRight`, `dataTypeLeft`,
`dataTypeRight`, `isListLeft`, `isListRight`, `valueLeft`, and
`valueRight`. Two `nodeAttributes` are equal if their `names` are equal
and if they belong to the same node (defined through `propertyOf`).

Example: The nodes from section 1.2.1 have `nodeAttributes`: In both
RCX-objects, the nodes with the id 0 and 1 have the attribute ‘type’.
Left network:

``` r
left$nodeAttributes
```

    ## Node attributes:

Right network:

``` r
right$nodeAttributes
```

    ## Node attributes:

If `matchByName` is `TRUE`, the `nodeAttributes`-dataframe is:

``` r
rcxMatchByNameTRUE$networkDifferences$nodeAttributes
```

If `matchByName` is `FALSE`, the `nodeAttributes`-dataframe is:

``` r
rcxMatchByNameFALSE$networkDifferences$nodeAttributes
```

#### The edge-dataframe

The `edges`-dataframe tracks the differences of the `edges` in eight
columns. The names of the columns are: `id`, `source`, `target`,
`interaction`, `oldIdLeft`, `oldIdRight`, `belongsToLeft`, and
`belongsToRight`. Two `edges` are equal if their `source` and `target`
are equal (the `edges` are undirected so the `source` and `target` can
be switched) and if the `interaction` is equal or `NA` in both cases.

Example: Both RCX-objects from section 1.2.1 and 1.2.2 have three edges
which have the `interactions` ‘E1’, ‘E2’, and ‘E3’. Left Network:

``` r
left$edges
```

    ## Edges:

Right network:

``` r
right$edges
```

    ## Edges:

If `matchByName` is set to `TRUE`, the `edges`-dataframe is:

``` r
rcxMatchByNameTRUE$networkDifferences$edges
```

If `matchByName` is set to `FALSE`, the `edges`-dataframe is:

``` r
rcxMatchByNameFALSE$networkDifferences$edges
```

#### The edgeAttributes-dataframe

The `edgeAttributes`-dataframe tracks the differences of the
`edgeAttributes` in ten columns. The names of the columns are:
`propertyOf`, `name`, `belongsToLeft`, `belongsToRight`, `dataTypeLeft`,
`dataTypeRight`, `isListLeft`, `isListRight`, `valueLeft` and
`valueRight`. Two `edgeAttributes` are equal if their `names` are equal
and if they belong to the same edge (defined through `propertyOf`).

Example: The edges from section 1.2.3 have edgeAttributes: In both
RCX-objects, the edges with the id 0 and 1 have the attribute ‘type’.
Left network:

``` r
left$edgeAttributes
```

    ## Edge attributes:

Right network:

``` r
right$edgeAttributes
```

    ## Edge attributes:

If `matchByName` is `TRUE`, the `edgeAttributes`-dataframe is:

``` r
rcxMatchByNameTRUE$networkDifferences$edgeAttributes
```

If `matchByName` is `FALSE`, the `edgeAttributes`-dataframe is:

``` r
rcxMatchByNameFALSE$networkDifferences$edgeAttributes
```

#### The networkAttributes-dataframe

The `networkAttributes`-dataframes tracks the differences of the
`networkAttributes` in nine columns. The names of the columns are:
`name`, `belongsToLeft`, `belongsToRight`, `dataTypeLeft`,
`dataTypeRight`, `isListLeft`, `isListRight`, `valueLeft`, and
`valueRight`. Two `networkAttributes` are equal if their `names` are
equal.

Example: The left and right RCX-objects have networkAttributes: the left
RCX-object has a name ‘left network’ and an author ‘Donald Duck’.

``` r
left$networkAttributes
```

    ## Network attributes:

The right RCX-object has a name, too, ‘right network’ and a description
‘sample network’.

``` r
right$networkAttributes
```

    ## Network attributes:

The `networkAttributes`-dataframe is:

``` r
rcxMatchByNameTRUE$networkDifferences$networkAttributes
```

## The JSON-Conversion

The aspect can be converted to JSON and back in order to share the
object. For the conversion to JSON the `rcxToJSON`-function is provided
and returns a string of the json-conversion.

``` r
json <- rcxToJson.NetworkDifferencesAspect(rcxMatchByNameTRUE, verbose = TRUE)
json
```

    ## [1] "[{\"nodes\":[{\"@id\":0,\"n\":\"A\",\"r\":\"r1\",\"oldId\":0},{\"@id\":1,\"n\":\"B\",\"r\":\"r2\",\"oldId\":1},{\"@id\":2,\"n\":\"C\",\"r\":\"r3\",\"oldId\":2},{\"@id\":3,\"n\":\"A\",\"r\":\"r1\",\"oldId\":0},{\"@id\":4,\"n\":\"B\",\"r\":\"r4\",\"oldId\":1},{\"@id\":5,\"n\":\"X\",\"r\":\"r5\",\"oldId\":2}]},{\"nodeAttributes\":[{\"po\":0,\"n\":\"type\",\"v\":\"w\",\"d\":\"string\"},{\"po\":1,\"n\":\"type\",\"v\":[\"x\",\"y\"],\"d\":\"list_of_string\"},{\"po\":3,\"n\":\"type\",\"v\":\"z\",\"d\":\"string\"},{\"po\":4,\"n\":\"type\",\"v\":[\"x\",\"y\"],\"d\":\"list_of_string\"}]},{\"edges\":[{\"@id\":0,\"s\":0,\"t\":1,\"i\":\"E1\",\"oldId\":0},{\"@id\":1,\"s\":1,\"t\":2,\"i\":\"E2\",\"oldId\":1},{\"@id\":2,\"s\":2,\"t\":0,\"i\":\"E3\",\"oldId\":2},{\"@id\":3,\"s\":3,\"t\":4,\"i\":\"E1\",\"oldId\":0},{\"@id\":4,\"s\":4,\"t\":5,\"i\":\"E2\",\"oldId\":1},{\"@id\":5,\"s\":5,\"t\":3,\"i\":\"E3\",\"oldId\":2}]},{\"edgeAttributes\":[{\"po\":0,\"n\":\"type\",\"v\":\"k\",\"d\":\"string\"},{\"po\":1,\"n\":\"type\",\"v\":\"l\",\"d\":\"string\"},{\"po\":3,\"n\":\"type\",\"v\":\"k\",\"d\":\"string\"},{\"po\":4,\"n\":\"type\",\"v\":[\"l\",\"m\"],\"d\":\"list_of_string\"}]},{\"networkDifferences\":[{\"matchByName\":\"true\"},{\"nodes\":[{\"@id\":\"0\",\"n\":\"A\",\"rl\":\"r1\",\"rr\":\"r1\",\"oil\":\"0\",\"oir\":\"0\",\"btl\":\"TRUE\",\"btr\":\"TRUE\"},{\"@id\":\"1\",\"n\":\"B\",\"rl\":\"r2\",\"rr\":\"r4\",\"oil\":\"1\",\"oir\":\"1\",\"btl\":\"TRUE\",\"btr\":\"TRUE\"},{\"@id\":\"2\",\"n\":\"C\",\"rl\":\"r3\",\"oil\":\"2\",\"btl\":\"TRUE\",\"btr\":\"FALSE\"},{\"@id\":\"3\",\"n\":\"X\",\"rr\":\"r5\",\"oir\":\"2\",\"btl\":\"FALSE\",\"btr\":\"TRUE\"}]},{\"nodeAttributes\":[{\"po\":\"0\",\"n\":\"type\",\"btl\":\"TRUE\",\"btr\":\"TRUE\",\"dtl\":\"string\",\"dtr\":\"string\",\"ill\":\"FALSE\",\"ilr\":\"FALSE\",\"vl\":\"w\",\"vr\":\"z\"},{\"po\":\"1\",\"n\":\"type\",\"btl\":\"TRUE\",\"btr\":\"TRUE\",\"dtl\":\"string\",\"dtr\":\"string\",\"ill\":\"TRUE\",\"ilr\":\"TRUE\",\"vl\":\"c(\\\"x\\\", \\\"y\\\")\",\"vr\":\"c(\\\"x\\\", \\\"y\\\")\"}]},{\"edges\":[{\"@id\":\"0\",\"s\":\"0\",\"t\":\"1\",\"i\":\"E1\",\"oil\":\"0\",\"oir\":\"0\",\"btl\":\"TRUE\",\"btr\":\"TRUE\"},{\"@id\":\"1\",\"s\":\"1\",\"t\":\"2\",\"i\":\"E2\",\"oil\":\"1\",\"btl\":\"TRUE\",\"btr\":\"FALSE\"},{\"@id\":\"2\",\"s\":\"2\",\"t\":\"0\",\"i\":\"E3\",\"oil\":\"2\",\"btl\":\"TRUE\",\"btr\":\"FALSE\"},{\"@id\":\"3\",\"s\":\"1\",\"t\":\"3\",\"i\":\"E2\",\"oir\":\"1\",\"btl\":\"FALSE\",\"btr\":\"TRUE\"},{\"@id\":\"4\",\"s\":\"3\",\"t\":\"0\",\"i\":\"E3\",\"oir\":\"2\",\"btl\":\"FALSE\",\"btr\":\"TRUE\"}]},{\"edgeAttributes\":[{\"po\":\"0\",\"n\":\"type\",\"btl\":\"TRUE\",\"btr\":\"TRUE\",\"dtl\":\"string\",\"dtr\":\"string\",\"ill\":\"FALSE\",\"ilr\":\"FALSE\",\"vl\":\"k\",\"vr\":\"k\"},{\"po\":\"1\",\"n\":\"type\",\"btl\":\"TRUE\",\"btr\":\"FALSE\",\"dtl\":\"string\",\"ill\":\"FALSE\",\"vl\":\"l\"},{\"po\":\"3\",\"n\":\"type\",\"btl\":\"FALSE\",\"btr\":\"TRUE\",\"dtr\":\"string\",\"ilr\":\"TRUE\",\"vr\":\"c(\\\"l\\\", \\\"m\\\")\"}]},{\"networkAttributes\":[{\"n\":\"name\",\"btl\":\"TRUE\",\"btr\":\"TRUE\",\"dtl\":\"string\",\"dtr\":\"string\",\"ill\":\"FALSE\",\"ilr\":\"FALSE\",\"vl\":\"left network\",\"vr\":\"right network\"},{\"n\":\"author\",\"btl\":\"TRUE\",\"btr\":\"FALSE\",\"dtl\":\"string\",\"ill\":\"FALSE\",\"vl\":\"Donald Duck\"},{\"n\":\"description\",\"btl\":\"FALSE\",\"btr\":\"TRUE\",\"dtr\":\"string\",\"ilr\":\"TRUE\",\"vr\":\"sample network\"}]}]},{\"status\":[{\"error\":\"\",\"success\":true}]}]"
    ## attr(,"class")
    ## [1] "CX"   "json"

The reconversion is the responsibility of the function `jsonToRCX`. The
json-string has to be parsed and this parsed string can be reconverted
to an RCX object with a `NetworkDifferences` aspect. This RCX object is
printed and is identical to the original RCX object.

``` r
jsonParsed <- RCX:::parseJSON(json)
jsonToRCX.networkDifferencesAspect(jsonParsed, verbose = TRUE)
```

    ## Parsing NetworkDifferences...Parsing nodes...create aspect...done!
    ## Parsing node attributes...create aspect...done!
    ## Parsing edges...create aspect...done!
    ## Parsing edge attributes...create aspect...done!
    ## Parsing networkDifferences...create aspect...done!

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

## The Conversion to RCX-objects

The `NetworkDifferences` aspect can be converted to RCX-objects in order
to visualize the differences of the two RCX-objects `left` and `right`.
There are three options: node-centered, edge-centered and a combined
version. The user can decide if the names and the values of the `node-`
or `edgeAttributes` should be included. The `networkAttributes` are not
visualized as they are not considered to be important.

The elements that exist in both RCX-objects are colored gray, the
elements that exist only in the left RCX-object are colored light blue
and the elements that exist only in the right RCX-object are orange.

The shapes for the nodes are: node names: round node represents:
triangle edge: rectangle nodeAttributes name: hexagon nodeAttribute
value: parallelogram edgeAttribute name: rectangle with round corners
edgeAttribute value: diamond.

## Node-centered RCX-objects

With the node-centered RCX-objects the user can visualize the
differences of the two given RCX-objects regarding the `nodes` and, if
wished, the names and values of the `nodeAttributes`. The
`exportDifferencesToNodeNetwork`-function has the
`includeNamesAndRepresents`-parameter; if this parameter is set to
`FALSE`, either the `represents` or the `names` are visualized
(depending on `matchByName`); if `includeNamesAndRepresents` is set to
`TRUE`, both `names` and `represents` are visualized.

The position of the circles can be changed with several parameters:

-   `startLayerBoth` has the default value 5 and determines the position
    at which the circles for the nodes that belong to both RCX-objects
    start

-   `startLayerLeftRight` has the default value 10 and determines the
    position at which the circles for the nodes that belong only to one
    RCX-objects start (it must be greater than `startLayerLeftRight`)

-   `startLayerAttributes` has the default value 0 and if this parameter
    is greater than `startLayerLeftRight`, it determines the position at
    which the circles for the names of the nodeAttributes start

-   `startLayerValues` has the default value 0 and if this parameter is
    greater than `startLayerAttributes`, it determines the position at
    which the circles for the values of the nodeAttributes start

The following figure shows the the differences of the RCX-objects from
the section 1.2 with `matchByName` is set to `TRUE`.

``` r
nodeNetwork <- exportDifferencesToNodeNetwork(
    rcxMatchByNameTRUE$networkDifferences, includeNamesAndRepresents = FALSE,
    startLayerBoth = 1, startLayerLeftRight = 2, startLayerAttributes = 3,
    startLayerValues = 4
)
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
visualize(nodeNetwork)
```

<figure>
<img src="The_networkDifferences_Aspect/nodes_matchByNameRepresent.png"
style="width:100.0%"
alt="Node-centered RCX-object with matchByName TRUE and includeNamesAndRepresents TRUE" />
<figcaption aria-hidden="true">Node-centered RCX-object with matchByName
TRUE and includeNamesAndRepresents TRUE</figcaption>
</figure>

## Edge-centered RCX-objects

With the edge-centered RCX-objects the user can visualize the
differences of the two given RCX-objects regarding the `edges` and, if
wished, the names and values of the `edgeAttributes`. Like before, there
are parameters `startLayerBoth`, `startLayerLeftRight`,
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
visualize(edgeNetwork)
```

<img src="The_networkDifferences_Aspect/edges_matchByRepresent.png"
style="width:100.0%"
alt="Edge-centered RCX-object with matchByName FALSE" /> \## Node- and
edge-centered RCX-objects The last option are the creation of
RCX-Objects that show the differences regarding the `nodes`, the
`edges`, and the `node-` and `edgeAttributes`. The parameters are the
same as for the node-centered option (section 2.1).

The following figure shows the node- and edge-centered RCX-object for
the RCX-objects from section 1 with `node-` and `edgeAttributes`
(`matchByName` is `TRUE`).

``` r
nodeEdgeNetwork <- exportDifferencesToNodeEdgeNetwork(
    rcxMatchByNameTRUE$networkDifferences, startLayerBoth = 1,
    startLayerLeftRight = 2, startLayerAttributes = 3, startLayerValues = 4
)
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

The example from section 2 illustrates how the differences of the two
RCX-objects are tracked. This section shows how this can be applied to a
real life example: the visualization of the differences of two RCX
objects representing two breast cancer patients. The two RCX-objects can
be extracted from the “Combined patient-specific breast cancer
subnetworks” (UUID a420aaee-4be9-11ec-b3be-0ac135e8bacf on NDEx) and
they show the networks of two breast cancer patients. These networks
have nodes that represent genes, edges between the nodes, and
nodeAttributes for the gene expression, gene expression level, and
relevance score whereby the patient id is part of the name of the
nodeAttributes. On the basis of the names of the nodeAttributes the
corresponding nodes and then the edges can be extracted. At the end, the
patient ids are removed from the name of the nodeAttributes. The patient
with the ID GSM615195 and the patient with the ID GSM615184 are selected
for this example whereby the patient GSM615195 has developed metastasis
within the first five years after the cancer diagnosis and patient
GSM615184 remained metastasis-free. Visualizing the differences of two
patients can help to determine the reasons for the
metastasis-development.

``` r
library(stringr)

rcx = readCX("/home/n/Augsburg/Bachelorarbeit/Combined patient-specific breast cancer subnetworks.cx")

getNetwork <- function(
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

rcxGSM615195 <- getNetwork("GSM615195", rcx)

rcxGSM615184 <- getNetwork("GSM615184", rcx)
```

First, extractions for the nodes, nodeAttributes, and edges for the
patient GSM615195 are shown.

``` r
head(rcxGSM615195$nodes)
```

    ## Nodes:

``` r
head(rcxGSM615195$nodeAttributes)
```

    ## Node attributes:

``` r
head(rcxGSM615195$edges)
```

    ## Edges:

Now, some extraction for the nodes, nodeAttributes, and edges for the
patient GSM615184 are shown.

``` r
head(rcxGSM615184$nodes)
```

    ## Nodes:

``` r
head(rcxGSM615184$nodeAttributes)
```

    ## Node attributes:

``` r
head(rcxGSM615184$edges)
```

    ## Edges:

Now the visualization of the differences of the two RCX-objects
regarding the nodes is created.

``` r
netDif <- compareNetworks(rcxGSM615195, rcxGSM615184, TRUE)

nodesNetwork <- exportDifferencesToNodeNetwork(netDif$networkDifferences)

visualize(nodesNetwork)
```

<img src="The_networkDifferences_Aspect/nodesNetwork.png"
style="width:100.0%"
alt="Node-centered RCX-object to visualize the differences regarding the nodes of the patients GSM615195 and GSM615184" />
We can see that about half of the genes that are shown in these networks
exist in both networks. These differences might be the reasons for the
differences in the development of metastasis. Next, we include the names
and the values of the `nodeAttributes` and see a detailed visualization
of the differences of the two RCX-objects.

``` r
nodesAttributesValuesNetwork <- exportDifferencesToNodeNetwork(
    netDif$networkDifferences, startLayerAttributes = 15,
    startLayerValues = 20
)

visualize(nodesAttributesValuesNetwork)
```

<img
src="The_networkDifferences_Aspect/nodesAttributesValuesNetwork.png"
style="width:100.0%"
alt="Node-centered RCX-object to visualize the differences regarding the nodes of the patients GSM615195 and GSM615184" />
This detailed visualization shows the differences of the nodeAttributes
and their values. Taking a closer look at their differences can lead to
more information about the difference metastasis-development.

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
    ##  [1] LC_CTYPE=de_DE.UTF-8       LC_NUMERIC=C               LC_TIME=de_DE.UTF-8        LC_COLLATE=de_DE.UTF-8    
    ##  [5] LC_MONETARY=de_DE.UTF-8    LC_MESSAGES=de_DE.UTF-8    LC_PAPER=de_DE.UTF-8       LC_NAME=C                 
    ##  [9] LC_ADDRESS=C               LC_TELEPHONE=C             LC_MEASUREMENT=de_DE.UTF-8 LC_IDENTIFICATION=C       
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] stringr_1.5.0               RCXNetworkDifferences_1.0.0 RCX_1.2.0                  
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.9      digest_0.6.30   plyr_1.8.8      jsonlite_1.8.4  lifecycle_1.0.3 formatR_1.12   
    ##  [7] magrittr_2.0.3  evaluate_0.18   rlang_1.0.6     stringi_1.7.8   cli_3.4.1       rstudioapi_0.14
    ## [13] vctrs_0.5.1     rmarkdown_2.18  tools_4.2.2     glue_1.6.2      xfun_0.35       yaml_2.3.6     
    ## [19] fastmap_1.1.0   compiler_4.2.2  htmltools_0.5.4 knitr_1.41
