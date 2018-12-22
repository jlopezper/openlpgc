require(ckanr)

ckanr_setup(url = "http://apidatosabiertos.laspalmasgc.es/")

package_list(as = "table", limit = 200)

categories <- group_list(as = "table")

tags <- tag_list(as = 'table')

head(tags, 20)


x <- package_show("ocupacion-calles")

str(x$resources, max.level = 2)

df <- readr::read_csv(x$resources[[1]]$url)
