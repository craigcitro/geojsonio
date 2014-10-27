#' Convert many input types with spatial data to geojson specified as a json string
#'
#' @export
#'
#' @param input Input list, data.frame, or spatial class. Inputs can also be dplyr \code{tbl_df}
#' class since it inherits from \code{data.frame}.
#' @param lat Latitude name. Default: latitude
#' @param lon Longitude name. Default: longitude
#' @param polygon If a polygon is defined in a data.frame, this is the column that defines the
#' grouping of the polygons in the \code{data.frame}
#' @param ... Further args passed on to \code{\link[jsonlite]{toJSON}}
#' @param x Ignored
#'
#' @details This function creates a geojson structure as a json character string; it does not
#' write a file using \code{rgdal} - see \code{\link{geojson_write}} for that.
#'
#' @examples \dontrun{
#' # From a numeric vector of length 2
#' geojson_json(c(32.45,-99.74))
#'
#' # From a data.frame
#' library('maps')
#' data(us.cities)
#' geojson_json(us.cities[1:2,], lat='lat', lon='long')
#'
#' # From SpatialPolygons class
#' library('sp')
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
#'    c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
#'    c(30,40,35,30)))), "2")
#' sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' geojson_json(sp_poly)
#' geojson_json(sp_poly, pretty=TRUE)
#' geojson_json(sp_poly, pretty=TRUE, auto_unbox=TRUE)
#'
#' # data.frame to SpatialPolygonsDataFrame
#' library('maps')
#' data(us.cities)
#' geojson_write(us.cities[1:2,], lat='lat', lon='long') %>% as.SpatialPolygonsDataFrame
#'
#' # data.frame to json (via SpatialPolygonsDataFrame)
#' geojson_write(us.cities[1:2,], lat='lat', lon='long') %>% as.json
#' }

geojson_json <- function(...) UseMethod("geojson_json")

#' @export
#' @rdname geojson_json
geojson_json.SpatialPolygons <- function(input, ...) to_json(sppolytogeolist(input), ...)

#' @export
#' @rdname geojson_json
geojson_json.SpatialPolygonsDataFrame <- function(input, ...) to_json(sppolytogeolist(input), ...)

#' @export
#' @rdname geojson_json
geojson_json.SpatialPointsDataFrame <- function(input, ...) to_json(sppolytogeolist(input), ...)

#' @export
#' @rdname geojson_json
geojson_json.numeric <- function(input, polygon=NULL, ...) to_json(num_to_geo_list(input, polygon), ...)

#' @export
#' @rdname geojson_json
geojson_json.data.frame <- function(input, lat = "latitude", lon = "longitude", polygon=NULL, ...){
  res <- df_to_geo_list(input, lat, lon, polygon)
  to_json(res, ...)
}

#' @export
#' @rdname geojson_json
geojson_json.list <- function(input, lat = "latitude", lon = "longitude", polygon=NULL, ...){
  res <- list_to_geo_list(input, lat, lon, polygon)
  to_json(res, ...)
}

#' @export
#' @rdname geojson_json
as.json <- function(x, ...) UseMethod("as.json")

#' @export
#' @rdname geojson_json
as.json.geo_list <- function(x, ...) to_json(unclass(x), ...)

#' @export
#' @rdname geojson_json
as.json.geojson <- function(x, ...) {
  res <- as.SpatialPolygonsDataFrame(x, ...)
  to_json(spdftogeolist(res))
}