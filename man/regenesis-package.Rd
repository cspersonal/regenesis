\name{regenesis-package}
\alias{regenesis-package}
\alias{regenesis}
\docType{package}
\title{
regenesis
}
\description{
Get data from german regional statistics site via friedich lindenbergs regenesis site (http://regenesis.pudo.org/regional/index.html).
}
\details{
\tabular{ll}{
Package: \tab regenesis\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2014-07-15\cr
License: \tab MIT\cr
}
}
\author{
Stefan Berwing

<berwing@ifm.uni-mannheim.de>
}
\references{
- http://regenesis.pudo.org/regional/index.html\cr
- https://www.regionalstatistik.de/genesis/online/logon
}

\examples{
# Search for datasets within the genesis database
# database is shipped with regenesis therefore changes
# in the genesis database are only documented with updates
# of the regenesis r-package
# search all datasets with the searchstring "Arbeits"
# opens a html-file with results
rgSearch("Arbeits")

# get data from regenesis site
# e.g. data with the counts of domains registered
# in the german kreise
# search for it with rgSearch("domain")
# first line of the search result contains the table-id 99221kj001
rgGetData("99221kj001")

}
