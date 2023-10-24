
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggslice

<!-- badges: start -->

<!-- badges: end -->

The goal of ggslice is to …

## Installation

You can install the development version of ggslice from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("EvaMaeRey/ggslice")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(ggslice)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
library(tidyverse)
#> ── Attaching core tidyverse packages ─────────────────── tidyverse 2.0.0.9000 ──
#> ✔ dplyr     1.1.0     ✔ readr     2.1.4
#> ✔ forcats   1.0.0     ✔ stringr   1.5.0
#> ✔ ggplot2   3.4.1     ✔ tibble    3.2.1
#> ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
#> ✔ purrr     1.0.1     
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
z <- 2.75
tolerance <- .7
mtcars %>% 
  filter(drat < z + tolerance & drat > z - tolerance) %>% 
  mutate(closeness = (tolerance - abs(z- drat))/tolerance) %>% 
  ggplot() + 
  aes(wt, qsec) + 
  geom_point(aes(alpha = closeness, color = z)) + 
  labs(title = paste0("z = ", z,"; tolerance = ",  tolerance)) +
  scale_alpha(limits = c(0, 1)) +
  geom_blank(data = mtcars) + 
  scale_color_viridis_c(limits = range(mtcars$drat))
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

``` r
counter <- 1
```

``` r
ggslice <- function(data, z, 
                    z_value = NULL, 
                    tolerance = 1, 
                    tol_value = 3){
  
z_complete <- data %>% pull({{z}})  
  
if(is.null(z_value)){
  
    z_value <- range(z_complete, na.rm = T) %>% quantile(.5)
    
}
  
if(is.null(tol_value)){
  
  tol_value <- (z_complete[2]-z_complete[1])*tolerance
  
}
  
  
data %>% 
  filter({{z}} < z_value + tol_value & {{z}} > z_value - tol_value) %>%
  mutate(closeness = (tol_value - abs(z_value - {{z}}))/tol_value) %>%
  ggplot() + 
  geom_blank(data = data) + 
  # scale_color_viridis_c(limits = range(z_complete, na.rm = T)) + 
  NULL
  
}

ggslice(mtcars, z = drat) + 
  aes(x = wt, y = qsec) + 
  geom_point(aes(alpha = closeness, color = drat)) +
  # labs(title = paste0("z = ", z,"; tolerance = ",  tolerance)) +
  scale_alpha(limits = c(0, 1)) +
  geom_blank(data = mtcars) 
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

``` r
library(tidyverse)
df <- tibble(x = rnorm(1000)) |>
  mutate(y = x + rnorm(1000) , z = .2*x + .3*y + rnorm(1000), 
                 ind = sample(0:1, 1000, replace = T, prob = c(.1, .9)))



ggslice(df, z = z) + 
  aes(x = x, y = y) + 
  geom_point(aes(alpha = closeness, color = ind)) +
  # labs(title = paste0("z = ", z,"; tolerance = ",  tolerance)) +
  scale_alpha(limits = c(0, 1))
```

<img src="man/figures/README-cars-1.png" width="100%" />

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
