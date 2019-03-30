
<!-- README.md is generated from README.Rmd. Please edit that file -->
openlpgc
========

The goal of openlpgc is to provide an R interface in order to extract data from Las Palmas de Gran Canaria City Council [open data site](http://datosabiertos.laspalmasgc.es/). This package uses the [CKAN API](https://docs.ckan.org/en/2.8/contents.html) and is powered by the [ckanr](https://github.com/ropensci/ckanr) package.

Installation
------------

You can install the released version of openlpgc from Github with:

``` r
# install.packages("remotes")
remotes::install_github("openlpgc")
```

Example
-------

This is a basic example which shows you how to solve a common problem:

``` r
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`? You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You'll still need to render `README.Rmd` regularly, to keep `README.md` up-to-date.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don't forget to commit and push the resulting figure files, so they display on GitHub!
