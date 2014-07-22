regenesis
=========

API for the german regional statistics site (https://www.regionalstatistik.de) via http://regenesis.pudo.org/regional/index.html.

Friedrich provides a quite sophisticated api using cubes. I've dropped all that and went back to the good old csv-approach. This means that all available data from one statistics are downloaded at once and have to be processed in R for further usage.

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

