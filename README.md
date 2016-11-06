regenesis
=========

R-package to retrieve data from the german regional statistics site (https://www.regionalstatistik.de) via http://regenesis.pudo.org/regional/index.html.

Friedrich provides a quite sophisticated api using cubes. I've dropped all that and went back to the good old csv-approach. This means that all available data from one statistics are downloaded at once and have to be processed in R for further usage.

You can install the package in R with devtools:

```r
# installing
require(devtools)
# install_github('regenesis', 'cspersonal') old code
install_github('cspersonal/regenesis')

# loading
require(regenesis)

# example
# search static db shipped with regenesis
# new statistics have been added to regionalstatistik.de since the creation of the package
# therefore also check Friedrichs page and its table-ids (see e.g. http://regenesis.pudo.org/regional/statistics/erhebung-uber-die-rinderbestande.41312.html)
rgSearch("domain")

# download data using the id from the search results
data<-rgGetData("99221kj001")
```

