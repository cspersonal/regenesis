regenesis
=========

UPDATE 2018: The package doesn't work anymore, since Friedrich doesn't provide his web services anymore (https://github.com/pudo/regenesis/wiki/ReGENESIS-ist-vorbei) To use the package you've got to run your own reGenesis server https://github.com/pudo/regenesis/blob/master/README.md. However, if you run your own reGenesis service you've got direct access to the database and you don't need this package ;).

AN ALTERNATIVE: If your looking for an api to german regional data you should have a look at the new project Datenland https://prototypefund.de/project/datenland/.


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

