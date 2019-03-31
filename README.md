
<!-- README.md is generated from README.Rmd. Please edit that file -->

# openlpgc

[![Travis build
status](https://travis-ci.org/jlopezper/openlpgc.svg?branch=master)](https://travis-ci.org/jlopezper/openlpgc)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

The goal of openlpgc is to provide an R interface in order to extract
data from Las Palmas de Gran Canaria City Council [open data
site](http://datosabiertos.laspalmasgc.es/). This package uses the [CKAN
API](https://docs.ckan.org/en/2.8/contents.html) and is powered by the
[ckanr](https://github.com/ropensci/ckanr) package.

This package is fully inspirated by the
[`opendataes`](https://github.com/rOpenSpain/opendataes) package.

## Installation

You can install the released version of `openlpgc` from Github with:

``` r
# install.packages("remotes")
remotes::install_github("openlpgc")
```

## Example

`openlpgc` has three main functions:

  - `lpgc_categories`: Search for available datasets for each category
  - `lpgc_search`: Search datasets by keyword
  - `lpgc_load`: Load the dataset (specified by its id)

Let’s show two examples in order to illustrate what it’s been stated
above.

### Loading data after search by keywords

Let’s search all datasets that are related to environment (“medio
ambiente”, in Spanish). We are supposed to use the `lpgc_search`
function for this:

``` r
library(openlpgc)
lpgc_search("medio ambiente")
#> # A tibble: 4 x 6
#>   author      maintainer    id        name        notes          created   
#>   <chr>       <chr>         <chr>     <chr>       <chr>          <date>    
#> 1 Ayuntamien… Unidad Técni… 05a6f959… huertos-ur… La red de hue… 2014-09-24
#> 2 Sociedad d… <NA>          7b750e55… playas      Descripción d… 2016-02-26
#> 3 Ayuntamien… Unidad Técni… a0a2c658… prestamo-b… "El sistema d… 2014-09-18
#> 4 <NA>        <NA>          704bc902… localizaci… Localización … 2018-01-11
```

Once we have the result, we just need to select the ID we want to load
and pass it into `lpgc_load`:

``` r
our_id <- lpgc_search("medio ambiente")$id[[1]]
lpgc_load(id = our_id)
#> $metadata
#> # A tibble: 1 x 6
#>   author       maintainer     id         name   notes            created   
#>   <chr>        <chr>          <chr>      <chr>  <chr>            <date>    
#> 1 Ayuntamient… Unidad Técnic… 05a6f959-… huert… La red de huert… 2014-09-24
#> 
#> $data
#> # A tibble: 9 x 11
#>   HUERTO Latitud Longitud `DIMENSION TOTA… `Nº PARCELAS` `DIMENSION PARC…
#>   <chr>    <dbl>    <dbl>            <int>         <int>            <int>
#> 1 El La…    28.1    -15.4             5220            58               28
#> 2 Siete…    28.1    -15.4             6788            31               21
#> 3 El Po…    28.1    -15.4             1249            18               21
#> 4 La Ma…    28.1    -15.5             3728            35               27
#> 5 Pino …    28.1    -15.4              536            12               25
#> 6 Lucha…    28.1    -15.4              721            16               23
#> 7 El Pa…    28.1    -15.4             2000            40               25
#> 8 Jinám…    28.0    -15.4             2256            46               30
#> 9 El Am…    28.1    -15.4             1874            41                3
#> # … with 5 more variables: `OCUP. COLEC` <int>, `OCUP. PART` <int>, `Nº
#> #   HORTELANOS` <int>, `Nº PARCELAS LIBRES` <int>, IMAGEN <chr>
```

`lpgc_load` **always** returns a list with two slots: the first one
contains a metadata tibble with information extracted from the site and
the second slot is filled with the data, if it was possible to read
them.

### Loading data after search by categories

`lpgc_show_categories` displays a character vector with all the current
available categories. Once you find the category you want to explore,
`lpgc_categories()` shows the datasets related to it. A simple example
to better illustrate it:

``` r
lpgc_show_categories
#>  [1] "ciencia-tecnologia"         "comercio"                  
#>  [3] "cultura-ocio"               "demografia"                
#>  [5] "deporte"                    "economia"                  
#>  [7] "educacion"                  "empleo"                    
#>  [9] "energia"                    "hacienda"                  
#> [11] "industria"                  "legislacion-justicia"      
#> [13] "medio-ambiente"             "medio-rural-pesca"         
#> [15] "salud"                      "sector-publico"            
#> [17] "seguridad"                  "sociedad-bienestar"        
#> [19] "transporte"                 "turismo"                   
#> [21] "urbanismo-infraestructuras" "vivienda"
lpgc_categories("educacion")
#> # A tibble: 12 x 6
#>    author      maintainer   id         name        notes         created   
#>    <chr>       <chr>        <chr>      <chr>       <chr>         <date>    
#>  1 Ayuntamien… Sección de … c5888937-… escuela-mu… Escuela Muni… 2014-08-05
#>  2 <NA>        <NA>         a0aca961-… escuelas-m… Número de us… 2018-01-12
#>  3 Ayuntamien… Sección de … 48270b9f-… escuelas-m… Número de us… 2014-08-05
#>  4 <NA>        <NA>         354f9cab-… talleres-e… Talleres dir… 2018-01-10
#>  5 <NA>        <NA>         7d97a59b-… talleres-e… Talleres dir… 2018-01-10
#>  6 <NA>        <NA>         975cf9b2-… servicio-a… Servicio dir… 2018-01-10
#>  7 <NA>        <NA>         568c0ddc-… servicio-a… Servicio dir… 2018-01-10
#>  8 <NA>        <NA>         8424463a-… actividade… Actividades … 2018-01-09
#>  9 <NA>        <NA>         147f6a19-… talleres-a… Talleres del… 2018-01-09
#> 10 <NA>        <NA>         e21904d3-… actividade… Actividades … 2018-01-08
#> 11 <NA>        <NA>         1bf264fb-… talleres-a… Talleres de … 2018-01-08
#> 12 Ayuntamien… Sección de … 83a3320c-… centros-es… Nivel, nombr… 2014-08-05
```

Then we can pass an ID into `lpgc_load` as explained above.
