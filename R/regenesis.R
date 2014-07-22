#' Search regenesis for datasets
#' 
#' \code{rgSearch()} search static regensis-metadatadb shipped with regenesis 
#' @param str String to search for 
#' @param reg Geographic attribute dafault="KREISE". see for more: http://regenesis.pudo.org/regional/index.html
#' @seealso \code{\link{regensis-package}}
rgSearch<-function(str,reg = "KREISE"){
    if(str != ""){
      con <- dbConnect(dbDriver("SQLite"), dbname = paste(.libPaths()[1],"/regenesis/data/regenesis.sqlite",sep=""))
      res <- dbGetQuery(con, paste("SELECT * FROM regenesis_fulllist WHERE (tablabel LIKE '%",str,"%' OR varlabel LIKE '%",str,"%') AND regtyp LIKE '",reg,"%' GROUP BY tabid",sep=""))

      tf<-tempfile("regenesissearch", fileext = c(".html"))
      str<-""
      header<-'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"\n"http://www.w3.org/TR/html4/loose.dtd\n<html>\n<meta http-equiv="content-type" content="text/html; charset=utf-8">\n<head>\n<title>ReGenesis Suchergebnis</title>\n<style>td{padding:3px;} table{margin-top:20px;font-size:12px; width:600px;font-family: Arial, Helvetica, sans-serif;border-collapse:collapse;}.toprow{background-color:lightsteelblue;}tr.botbor td{border-bottom:1px dashed lightgrey;}</style></head>\n<body>\n'
      for(i in 1:length(res$id)){
        str <-paste(str,"<table>\n\t<tr class=\"toprow\">\n\t\t<td style=\"width:150px;\">Id</td>\n\t\t<td>",res$tabid[[i]],"</td>\n</tr>\n",sep="")
        str <-paste(str,"\t<tr class=\"botbor\">\n\t\t<td>Statistik</td>\n\t\t<td>",res$tablabel[[i]]," (<a href=\"http://regenesis.pudo.org",res$staturl[[i]],"\" target=\"_blank\">Info</a>)</td>\n</tr>\n",sep="")
        str <-paste(str,"\t<tr class=\"botbor\">\n\t\t<td>Url</td>\n\t\t<td><a href=\"",res$taburl[[i]],"\">CSV-Datei</a></td>\n</tr>\n",sep="")
        subres <- dbGetQuery(con, paste("SELECT * FROM regenesis_fulllist WHERE tabid='",res$tabid[[i]],"' ORDER BY type ASC",sep=""))
        options(warn=-1)
        for(j in 1:length(subres$id)){
          attr<-""
          if(subres$varlabel[[j]] == "Stichtag"){
            attr<-.getStagValues(res$tabid[[i]])
          }
          if(subres$varlabel[[j]] == "Jahr"){
            attr<-.getJahrValues(res$tabid[[i]])
          }
          if(subres$type[[j]] == "Sachattribut"){
            attr<-.getAttrValues(res$tabid[[i]],subres$varid[[j]])
          }
          str <-paste(str,"\t<tr class=\"botbor\">\n\t\t<td>",subres$type[[j]],"</td>\n\t\t<td>",subres$varlabel[[j]]," (",subres$varid[[j]],")<br>",attr,"</td>\n</tr>\n",sep="")
        }
        options(warn=0)
        str <-paste(str,"</table>\n",sep="")
        cat("......")
      }
      str<-paste(header,str,sep="")
      conOut<-file(tf, encoding="utf-8", open = "a")
      write(str, conOut)
      close(conOut)
      if(Sys.getenv("RSTUDIO") == "1"){
        rstudio::viewer(tf)
      }else{
        browseURL(tf)
      }
      dbDisconnect(con)
    }else{
      cat("No Querystring!")
    }
}

.getStagValues<-function(tab){
  jsonstr<-.readUrl(paste("http://api.regenesis.pudo.org/cube/",tab,"/dimension/stag",sep=""))
  if(jsonstr != FALSE){
    attr<-fromJSON(jsonstr, method = "C", unexpected.escape = "error" )
    attr<-do.call(rbind.data.frame, attr$data)
    attr$stag.text<-as.character(attr$stag.text)
    attr$stag.from<-as.Date(attr$stag.from)
    attr<-attr[order(attr$stag.from),]
    str<-""
    for(k in 1:length(attr$stag.text)){
      str<-paste(str,", ",attr$stag.text[k],sep="")
    }
    return(str)
  }else{
    return(FALSE)
  }
}


.getJahrValues<-function(tab){
  jsonstr<-.readUrl(paste("http://api.regenesis.pudo.org/cube/",tab,"/dimension/jahr",sep=""))
  if(jsonstr != FALSE){
    attr<-fromJSON(jsonstr, method = "C", unexpected.escape = "error" )
    attr<-do.call(rbind.data.frame, attr$data)
    attr$jahr.text<-as.character(attr$jahr.text)
    attr$jahr.from<-as.Date(attr$jahr.from)
    attr<-attr[order(attr$jahr.from),]
    str<-""
    for(k in 1:length(attr$jahr.text)){
      str<-paste(str,", ",attr$jahr.text[k],sep="")
    }
    return(str)
  }else{
    return(FALSE)
  }
}


.getAttrValues<-function(tab,attrstr){
  jsonstr<-.readUrl(paste("http://api.regenesis.pudo.org/cube/",tab,"/dimension/",attrstr,sep=""))
  if(jsonstr != FALSE){
    attr<-fromJSON(jsonstr, method = "C", unexpected.escape = "error" )
    attr<-do.call(rbind.data.frame, attr$data)
    evstr<-paste('names(attr)[names(attr)=="',attrstr,'.label"] <- "attrlabel"',sep="")
    eval(parse(text=evstr))
    evstr<-paste('names(attr)[names(attr)=="',attrstr,'.name"] <- "attrcode"',sep="")
    eval(parse(text=evstr))
    str<-""
    for(k in 1:length(attr$attrlabel)){
      str<-paste(str,"- ",attr$attrlabel[k],"<br>",sep="")
    }
    return(str)
  }else{
    return(FALSE)
  }
}

# function to retrieve data from api and returns FALSE if cube doesn't exist
.readUrl <- function(url="http://api.regenesis.pudo.org/cube/22811kj004/dimension/stag") {
  out <- tryCatch(
    {
      jsonstr<-readLines(paste(url,sep=""))
      return(jsonstr)
    },
    error=function(cond)
    {
      #message(paste("URL does not seem to exist:", url))
      # Choose a return value in case of error
      return(FALSE)
    }
  )    
  return(out)
}

#' Retrieve data from regenesis
#' 
#' \code{rgGetData()} retrieve data from regenesis site
#' @param tabid tabid provided by rgSearch()
#' @seealso \code{\link{regensis-package}}
rgGetData<-function(tabid){
  con <- dbConnect(dbDriver("SQLite"), dbname = paste(.libPaths()[1],"/regenesis/data/regenesis.sqlite",sep=""))
  res1 <- dbGetQuery(con, paste("SELECT * FROM regenesis_fulllist WHERE tabid = '",tabid,"'",sep=""))
  res2 <- dbGetQuery(con, paste("SELECT * FROM regenesis_fulllist WHERE tabid = '",tabid,"' AND type = 'Zeitattribut'",sep=""))
  dbDisconnect(con)
  #res1$taburl[1]
  #res2$varid[1]
  data<-read.table(res1$taburl[1], sep=",", head=T)
  return(data)
}
