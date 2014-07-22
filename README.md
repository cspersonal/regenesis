regenesis
=========

API for the german regional statistics site (https://www.regionalstatistik.de) via pudos scrape (http://regenesis.pudo.org/regional/index.html)

You can install the package in R with devtools:

```r
# installing
require(devtools)
install_github('regenesis', 'cspersonal')

# loading
require(regenesis)

# example
# search static db shipped with regenesis
rgSearch("domain")

# download data using the id from the search results
data<-rgGetData("99221kj001")
```

