slice_z <- function(data, z, 
                    z_q_range = .5, # middle of the range
                    z_value = NULL, 
                    tolerance = .05, # plus or minus 5% of range
                    tol_value = NULL){
  
z_vector <- data |> pull({{z}})  
z_range <- range(z_vector, na.rm = T)
z_name <- data  |>  select({{z}}) |> names()
  
if(is.null(z_value)){     z_value <-  quantile(z_range, z_q_range)}
if(is.null(tol_value)){ tol_value <- (z_range[2]-z_range[1])*tolerance}

z_min <- z_value - tol_value
z_max <- z_value + tol_value
  
data %>% 
  dplyr::filter({{z}} <= z_max & {{z}} >= z_min) |> 
  dplyr::mutate(closeness = (tol_value - abs(z_value - {{z}}))/tol_value) 

}


#' Title
#'
#' @param data 
#' @param z 
#' @param z_q_range 
#' @param z_value 
#' @param tolerance 
#' @param tol_value 
#'
#' @return
#' @export
#'
#' @examples
ggslice <- function(data, z, 
                    z_q_range = .5, # middle of the range
                    z_value = NULL, 
                    tolerance = .05, # plus or minus 5% of range
                    tol_value = NULL){
  
z_vector <- data |> pull({{z}})  
z_range <- range(z_vector, na.rm = T)
z_name <- data  |>  select({{z}}) |> names()
  
if(is.null(z_value)){z_value <- z_range |> quantile(z_q_range)}
if(is.null(tol_value)){tol_value <- (z_range[2]-z_range[1])*tolerance}

z_min <- z_value - tol_value
z_max <- z_value + tol_value
  
data %>% 
  dplyr::filter({{z}} <= z_max & {{z}} >= z_min) |> 
  dplyr::mutate(closeness = (tol_value - abs(z_value - {{z}}))/tol_value)  ->
sliced
  
sliced |>
  ggplot2::ggplot() + 
  ggplot2::geom_blank(data = data) + 
  ggplot2::labs(subtitle = paste0(z_name, " range = ", 
                                  round(z_value, 2),"\u00B1",  
                                  round(tol_value,2))) +
  # scale_color_viridis_c(limits = range(z_complete, na.rm = T)) + 
  NULL
  
}
