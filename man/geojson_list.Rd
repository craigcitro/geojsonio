% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/geojson_list.R
\name{geojson_list}
\alias{geojson_list}
\alias{geojson_list.SpatialGrid}
\alias{geojson_list.SpatialGridDataFrame}
\alias{geojson_list.SpatialLines}
\alias{geojson_list.SpatialLinesDataFrame}
\alias{geojson_list.SpatialPoints}
\alias{geojson_list.SpatialPointsDataFrame}
\alias{geojson_list.SpatialPolygons}
\alias{geojson_list.SpatialPolygonsDataFrame}
\alias{geojson_list.data.frame}
\alias{geojson_list.list}
\alias{geojson_list.numeric}
\title{Convert many input types with spatial data to geojson specified as a list}
\usage{
geojson_list(...)

\method{geojson_list}{SpatialPolygons}(input, ...)

\method{geojson_list}{SpatialPolygonsDataFrame}(input, ...)

\method{geojson_list}{SpatialPoints}(input, ...)

\method{geojson_list}{SpatialPointsDataFrame}(input, ...)

\method{geojson_list}{SpatialLines}(input, ...)

\method{geojson_list}{SpatialLinesDataFrame}(input,
  object = "FeatureCollection", ...)

\method{geojson_list}{SpatialGrid}(input, ...)

\method{geojson_list}{SpatialGridDataFrame}(input, ...)

\method{geojson_list}{numeric}(input, polygon = NULL, ...)

\method{geojson_list}{data.frame}(input, lat = "latitude",
  lon = "longitude", polygon = NULL, object = "FeatureCollection", ...)

\method{geojson_list}{list}(input, lat = "latitude", lon = "longitude",
  polygon = NULL, object = "FeatureCollection", unnamed = FALSE, ...)
}
\arguments{
\item{...}{Ignored}

\item{input}{Input list, data.frame, or spatial class. Inputs can also be dplyr \code{tbl_df}
class since it inherits from \code{data.frame}.}

\item{object}{(character) One of FeatureCollection, or}

\item{polygon}{If a polygon is defined in a data.frame, this is the column that defines the
grouping of the polygons in the \code{data.frame}}

\item{lat}{Latitude name. Default: latitude}

\item{lon}{Longitude name. Default: longitude}

\item{unnamed}{(logical) Is lat/long data unnamed? That is, you can pass in a list of
lat/long pairs as e.g., a polygon or linestring perhaps, and they aren't named. If so, use
\code{unnamed=TRUE}. The default is \code{FALSE}, that is, when a list is passed, this function
looks for lat and lon variable names to parse that data.}
}
\description{
Convert many input types with spatial data to geojson specified as a list
}
\details{
This function creates a geojson structure as an R list; it does not write a file
using \code{rgdal} - see \code{\link{geojson_write}} for that.
}
\examples{
\dontrun{
# from data.frame
library("maps")
data(us.cities)
(res <- geojson_list(us.cities[1:2,], lat='lat', lon='long'))
as.json(res)

# polygons
library("ggplot2")
states <- map_data("state")
head(states)
## make list for input to e.g., rMaps
res <- geojson_list(input=states, lat='lat', lon='long', group='group')

## From a list
mylist <- list(list(latitude=30, longitude=120, marker="red"),
               list(latitude=30, longitude=130, marker="blue"))
geojson_list(mylist)

# From a numeric vector of length 2 to a point
vec <- c(32.45,-99.74)
geojson_list(vec)

# From a list of numeric vectors to a polygon
vecs <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,0.0))
geojson_list(vecs, unnamed=TRUE, polygon=TRUE)

# From SpatialPolygons class
library('sp')
poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
   c(40,50,45,40)))), "1")
poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
   c(30,40,35,30)))), "2")
sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
geojson_list(sp_poly)

# From SpatialPolygonsDataFrame class
sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")
geojson_list(input = sp_polydf)

# From SpatialPoints class
x <- c(1,2,3,4,5)
y <- c(3,2,5,1,4)
s <- SpatialPoints(cbind(x,y))
geojson_list(s)

# From SpatialPointsDataFrame class
s <- SpatialPointsDataFrame(cbind(x,y), mtcars[1:5,])
geojson_list(s)

# From SpatialLines class
library("sp")
c1 <- cbind(c(1,2,3), c(3,2,2))
c2 <- cbind(c1[,1]+.05,c1[,2]+.05)
c3 <- cbind(c(1,2,3),c(1,1.5,1))
L1 <- Line(c1)
L2 <- Line(c2)
L3 <- Line(c3)
Ls1 <- Lines(list(L1), ID = "a")
Ls2 <- Lines(list(L2, L3), ID = "b")
sl1 <- SpatialLines(list(Ls1))
sl12 <- SpatialLines(list(Ls1, Ls2))
geojson_list(sl1)
geojson_list(sl12)
as.json(geojson_list(sl12))
as.json(geojson_list(sl12), pretty=TRUE)

# From SpatialLinesDataFrame class
dat <- data.frame(X = c("Blue", "Green"),
                 Y = c("Train", "Plane"),
                 Z = c("Road", "River"), row.names = c("a", "b"))
sldf <- SpatialLinesDataFrame(sl12, dat)
geojson_list(sldf)
as.json(geojson_list(sldf))
as.json(geojson_list(sldf), pretty=TRUE)

# From SpatialGrid
x <- GridTopology(c(0,0), c(1,1), c(5,5))
y <- SpatialGrid(x)
geojson_list(y)

# From SpatialGridDataFrame
sgdim <- c(3,4)
sg <- SpatialGrid(GridTopology(rep(0,2), rep(10,2), sgdim))
sgdf <- SpatialGridDataFrame(sg, data.frame(val = 1:12))
geojson_list(sgdf)
}
}

