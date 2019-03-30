
<!-- README.md is generated from README.Rmd. Please edit that file -->
openlpgc
========

The goal of openlpgc is to provide an R interface in order to extract data from Las Palmas de Gran Canaria City Council [open data site](http://datosabiertos.laspalmasgc.es/). This package uses the [CKAN API](https://docs.ckan.org/en/2.8/contents.html) and is powered by the [ckanr](https://github.com/ropensci/ckanr) package.

This package is fully inspirated by the [`opendataes`](https://github.com/rOpenSpain/opendataes) package.

Installation
------------

You can install the released version of `openlpgc` from Github with:

``` r
# install.packages("remotes")
remotes::install_github("openlpgc")
```

Example
-------

`openlpgc` has three main functions:

-   `lpgc_categories`: Search for available datasets for each category
-   `lpgc_search`: Search datasets by keyword
-   `lpgc_load`: Load the dataset (specified by its id)

Let's show two examples in order to illustrate what it's been stated above.

### Loading data after keyword search

Let's search all datasets that are related to environment ("medio ambiente", in Spanish). We are supposed to use the `lpgc_search` function for this:

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

Once we have the result, we just need to select the ID we want to load and pass it into `lpgc_load`:

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

`lpgc_load` **always** returns a list with two slots: the first one contains a metadata tibble with information extracted from the site and the second slot is filled with the data, if it was possible to read them.

### Loading data after keyword search
