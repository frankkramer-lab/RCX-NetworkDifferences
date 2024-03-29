% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/compareNetworks.R
\name{.diffQuadrantLayout}
\alias{.diffQuadrantLayout}
\title{Helper-function to calculate the positions of the nodes}
\usage{
.diffQuadrantLayout(nodes, dX = 70, dY = 70, startLayer = 0, sector = 1)
}
\arguments{
\item{nodes}{integer list; contains the nodes ids to which the x- and y-coordinates are assigned}

\item{dX}{integer (optional, default value 70); determines the width of the created circles}

\item{dY}{integer (optional, default value 70); determines the height of the created circles}

\item{startLayer}{integer (optional, default values 0); determines the layer at which the nodes start}

\item{sector}{integer (optional, default value 1); determines the sector in which the nodes are located.
If the sector is greater or equal 4, a modulo 4 operation is performed to map the result to 0, 1, 2 or 3.}
}
\description{
Helper-function to calculate the positions of the nodes
}
