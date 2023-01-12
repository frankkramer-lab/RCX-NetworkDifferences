# The NetworkDifferences-Aspect
The `NetworkDifferences` aspect allows the tracking and visualization of the differences of two RCX-objects. The first part of this vignette explains in detail how this aspect works and at the end we take a closer look at how this functionality can be used for a real-life example. Many biological entities like proteins and genes are represented as biological networks with nodes and edges and comparing these networks can help to answer questions in medical research e. g. the real-life example illustrates how the `NetworkDifferences` aspect can be used to visualize the differences regarding genes, gene expression and other aspects of two breast cancer patients. 

The `NetworkDifferences` aspect website is available at https://github.com/frankkramer-lab/RCX-NetworkDifferences  
The basis for this package is the RCX package by Florian Auer. The json-based datastructure CX is often used to store biological networks and the RCX package adapts the CX format to standard R data formats to create and modify, load, export, and visualize networks. 
```{r library, echo=FALSE, message=FALSE, include = FALSE}
library(RCX)
#library(RCXNetworkDifferences)
source('/home/n/R/RCX-NetworkDifferences/R/compareNetworks.R')
source('/home/n/R/RCX-NetworkDifferences/R/json.R')
```
The `NetworkDifferences` aspect tracks the differences of two networks, represented as RCX-objects. First, two RCX-objects `left` and `right` are created that will be used as examples later.
```{r left right}
left <- RCX::createRCX(
    nodes = RCX::createNodes(id=0:2, name=c("A","B","C"), represents=c("r1","r2","r3")),
    edges = RCX::createEdges(source = c(0, 1, 2), target = c(1, 2, 0), interaction = c("E1", "E2", "E3")),
    nodeAttributes = RCX::createNodeAttributes(propertyOf = c(0, 1), name = rep("type", 2), value = list("w", c("x", "y"))),
    edgeAttributes = RCX::createEdgeAttributes(propertyOf = c(0, 1), name = rep("type", 2), value = c("k", "l")),
    networkAttributes = RCX::createNetworkAttributes(name = c("name", "author"), value = c("left network", "Donald Duck"))
)

right <- RCX::createRCX(
    nodes = RCX::createNodes(name = c("A", "B", "X"), represents = c ("r1", "r4", "r5")),
    edges = RCX::createEdges(source = c(0, 1, 2), target = c(1, 2, 0), interaction = c("E1", "E2", "E3")),
    nodeAttributes = RCX::createNodeAttributes(propertyOf = c(0, 1), name = c("type", "type"),value = list("z", c("x", "y"))),
    edgeAttributes = RCX::createEdgeAttributes(propertyOf = c(0, 1), name = rep("type", 2), value = list("n" , c("l", "m"))),
    networkAttributes = RCX::createNetworkAttributes(name = c("name", "description"), value = c("right network", "sample network"))
)
```
Now, we have two RCX-objects and with the `compareNetworks`-function we can track their differences. To illustrate the difference between `matchByName` set to `TRUE` respectively `FALSE`, we define two RCX-objects called `rcxMatchByNameTRUE` and `rcxMatchByNameFALSE`.
```{r compareNetworks}
rcxMatchByNameTRUE <- compareNetworks(left, right, matchByName = TRUE)
rcxMatchByNameFALSE <- compareNetworks(left, right, matchByName = FALSE)
```

## The compareNetworks-function
The `compareNetworks`-function is provided to track the differences regarding the `nodes`, `nodeAttributes`, `edges`, `edgeAttributes`, and `networkAttributes` and has three parameters: the two RCX-objects `left`, `right`, and the boolean `matchByName`. The names `left` and `right` are based on the join-operation. If `matchByName` is `TRUE`, two nodes are equal when their names are equal; if `matchByName` is `FALSE`, two nodes are equal when their represents are equal.

The function returns an RCX network whereby the `nodes`, `nodeAttributes`, `edges`, and `edgeAttributes` of the right network are appended to the corresponding aspects of the left network. The `networkAttributes` are ignored as it is not possible to append the `networkAttributes` of the right network to the `networkAttributes` of the left network if the `networkAttributes` have the same name. An additional aspect called the `NetworkDifferences` aspect is added to the RCX network. It is a list with the `matchByName`-boolean and five dataframes to track the differences of `nodes`, `nodeAttributes`, `edges`, `edgeAttributes`, and `networkAttributes` of the two RCX objects.

The structure of the returned RCX object is:
```
|---nodes: left nodes, right nodes
|---nodeAttributes: left nodeAttributes, right nodeAttributes
|---edges: left edges, right edges
|---edgeAttributes: left edgeAttributes, right edgeAttributes
|---networkDifferences
|   |---nodes: differences of the nodes
|   |   |---id
|   |   |---name / nameLeft
|   |   |---representLeft / nameRight
|   |   |---representRight / nameLeft
|   |   |---oldIdLeft
|   |   |---oldIdRight
|   |   |---belongsToLeft
|   |   |---belongsToRight
|   |---nodeAttributes: differences of the nodeAttributes
|   |   |---name
|   |   |---propertyOf
|   |   |---belongsToLeft
|   |   |---belongsToRight
|   |   |---dataTypeRight
|   |   |---dataTypeLeft
|   |   |---isListLeft
|   |   |---isListRight
|   |   |---valueLeft
|   |   |---valueRight
|   |---edges: differences of the edges
|   |   |---id
|   |   |---source
|   |   |---target
|   |   |---interaction
|   |   |---oldIdLeft
|   |   |---oldIdRight
|   |   |---belongsToLeft
|   |   |---belongsToRight
|   |---edgeAttributes: differences of the edgeAttributes
|   |   |---name
|   |   |---propertyOf
|   |   |---belongsToLeft
|   |   |---belongsToRight
|   |   |---dataTypeRight
|   |   |---dataTypeLeft
|   |   |---isListLeft
|   |   |---isListRight
|   |   |---valueLeft
|   |   |---valueRight
|   |---networkAttributes: differences of the networkAttributes
|   |   |---name
|   |   |---belongsToLeft
|   |   |---belongsToRight
|   |   |---dataTypeRight
|   |   |---dataTypeLeft
|   |   |---isListLeft
|   |   |---isListRight
|   |   |---valueLeft
|   |   |---valueRight
```

### The combined RCX network
The combined network adds the aspects of the right network to the left network. For the `nodes` it is:
```{r nodes}
rcxMatchByNameTRUE$nodes
```
The dataframe for the `nodeAttributes` has updated values for `propertyOf` for the `nodeAttributes` of the right network.
```{r nodeAttributes}
rcxMatchByNameTRUE$nodeAttributes
```
The dataframe for the `edges` contains updated values for `source` and `target` for the `edges` of the right network.
```{r edges}
rcxMatchByNameTRUE$edges
```
The last aspect are the `edgeAttributes`, again with updated values for `propertyOf` for the `edgeAttributes` of the right network.
```{r edgeAttributes}
rcxMatchByNameTRUE$edgeAttributes
```
### The networkDifferences-aspect
The `NetworkDifferences`-aspect contains the information regarding the differences of the `nodes`, `nodeAttributes`, `edges`, `edgeAttributes`, and `networkÀttributes`.

**The nodes-dataframe**

The `nodes`-dataframe tracks the differences of the `nodes` in eight columns. The names of the columns depend on the `matchByName`-boolean. If `matchByName` is `TRUE` the names of the columns are: `id`, `name`, `representLeft`, `representRight`, `oldIdLeft`, `oldIdRight`, `belongsToLeft`, and `belongsToRight`. If `matchByName` is `FALSE` the names of the columns are: `id`, `name`, `representLeft`, `representRight`, `oldIdLeft`, `oldIdRight`, `belongsToLeft`, and `belongsToRight`.

*Example:* The left network has three nodes called A, B, and C with the represents r1, r2, and r3. 
```{r left nodes}
left$nodes
```
The right network has three nodes called A, B, and X with the represents r1, r4, and r5.
```{r right nodes}
right$nodes
```
If `matchByName` is `TRUE`, the created `nodes`-dataframe is:
```{r mbnTRUE nodes}
rcxMatchByNameTRUE$networkDifferences$nodes
```
If `matchByName` is `FALSE`, the created `nodes`-dataframe is:
```{r mbnFALSE nodes}
rcxMatchByNameFALSE$networkDifferences$nodes
```

**The nodeAttributes-dataframe**

The `nodeAttributes`-dataframes tracks the differences of the `nodeAttributes` in ten columns. The names of the columns are: `propertyOf`, `name`, `belongsToLeft`, `belongsToRight`, `dataTypeLeft`, `dataTypeRight`, `isListLeft`, `isListRight`, `valueLeft`, and `valueRight`. Two `nodeAttributes` are equal if their `names` are equal and if they belong to the same node (defined through `propertyOf`). 

*Example:* The nodes from section 1.2.1 have `nodeAttributes`: In both RCX-objects, the nodes with the id 0 and 1 have the attribute 'type'.
```{r left nodeAttributes}
left$nodeAttributes
```
```{r right nodeAttributes}
right$nodeAttributes
```
If `matchByName` is `TRUE`, the `nodeAttributes`-dataframe is:
```{r mbnTRUE nodeAttributes}
rcxMatchByNameTRUE$networkDifferences$nodeAttributes
```
If `matchByName` is `FALSE`, the `nodeAttributes`-dataframe is:
```{r mbnFALSE nodeAttributes}
rcxMatchByNameFALSE$networkDifferences$nodeAttributes
```

**The edge-dataframe**

The `edges`-dataframe tracks the differences of the `edges` in eight columns. The names of the columns are: `id`, `source`, `target`, `interaction`, `oldIdLeft`, `oldIdRight`, `belongsToLeft`, and `belongsToRight`. Two `edges` are equal if their `source` and `target` are equal (the `edges` are undirected so the `source` and `target` can be switched) and if the `interaction` is equal or `NA` in both cases.

*Example:* Both RCX-objects from section 1.2.1 and 1.2.2 have three edges which have the `interactions` 'E1', 'E2', and 'E3'. 
```{r left edges}
left$edges
```
```{r right edges}
right$edges
```
If `matchByName` is set to `TRUE`, the `edges`-dataframe is:
```{r mbnTRUE edges}
rcxMatchByNameTRUE$networkDifferences$edges
```
If `matchByName` is set to `FALSE`, the `edges`-dataframe is:
```{r mbnFALSE edges}
rcxMatchByNameFALSE$networkDifferences$edges
```

**The edgeAttributes-dataframe**

The `edgeAttributes`-dataframe tracks the differences of the `edgeAttributes` in ten columns. The names of the columns are: `propertyOf`, `name`, `belongsToLeft`, `belongsToRight`, `dataTypeLeft`, `dataTypeRight`, `isListLeft`, `isListRight`, `valueLeft` and `valueRight`. Two `edgeAttributes` are equal if their `names` are equal and if they belong to the same edge (defined through `propertyOf`).

*Example:* The edges from section 1.2.3 have edgeAttributes: In both RCX-objects, the edges with the id 0 and 1 have the attribute 'type'.
```{r left edgeAttributes}
left$edgeAttributes
```
```{r right edgeAttributes}
right$edgeAttributes
```
If `matchByName` is `TRUE`, the `edgeAttributes`-dataframe is:
```{r mbnTRUE edgeAttributes}
rcxMatchByNameTRUE$networkDifferences$edgeAttributes
```
If `matchByName` is `FALSE`, the `edgeAttributes`-dataframe is:
```{r mbnFALSE edgeAttributes}
rcxMatchByNameFALSE$networkDifferences$edgeAttributes
```

**The networkAttributes-dataframe**

The `networkAttributes`-dataframes tracks the differences of the `networkAttributes` in nine columns. The names of the columns are: `name`, `belongsToLeft`, `belongsToRight`, `dataTypeLeft`, `dataTypeRight`, `isListLeft`, `isListRight`, `valueLeft`, and `valueRight`. Two `networkAttributes` are equal if their `names` are equal. 

*Example:* The left and right RCX-objects have networkAttributes: the left RCX-object has a name 'left network' and an author 'Donald Duck'. 
```{r left networkAttributes}
left$networkAttributes
```
The right RCX-object has a name, too, 'right network' and a description 'sample network'.
```{r right networkAttributes}
right$networkAttributes
```
The `networkAttributes`-dataframe is:
```{r mbn networkAttributes}
rcxMatchByNameTRUE$networkDifferences$networkAttributes
```

## The JSON-Conversion
The aspect can be converted to JSON and back in order to share the object. For the conversion to JSON the `rcxToJSON`-function is provided and returns a string of the json-conversion.
```{r rcxToJSON}
json = toCX(rcxMatchByNameTRUE, verbose = TRUE)
json
```
The reconversion is the responsibility of the function `jsonToRCX`. The json-string has to be parsed and this parsed string can be reconverted to an RCX object with a `NetworkDifferences` aspect. This RCX object is printed and is identical to the original RCX object.
```{r JSONToRcx}
jsonParsed = RCX:::parseJSON(json)
rcx = RCX:::processCX(jsonParsed, verbose = TRUE)
rcx
```