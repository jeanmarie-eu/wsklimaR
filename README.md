# wsklimaR

## eklima service from met.no has shut down. Package wsklimaR becomes then obsolete
## We are working on adapting this package to their new service

[![Build Status](https://travis-ci.org/nexModeling/wsklimaR.svg?branch=master)](https://travis-ci.org/nexModeling/wsklimaR)

wsklimaR is designed to get an easy access to stations registered by the Norwegian Meteorological Institute.

The package connects you to the Klimadata webservice from met.no [wsklima](http://eklima.met.no/wsKlima/start/start_en.html).

No identification is required to use this service.

This service is not so young. Do not send too many requests at a time.

The output of each request is structured as a data.frame. It is easily usable as a matrix and easily convertible into a json file

## Installation

```R
# install.packages("devtools")
devtools::install_github("nexModeling/wsklimaR")
```

## Usage

Get hourly temperature and precipitation at stations # 19710 and # 2650 between 27/12/2015 and 31/12/2015

```R
values <- wsklimaR::getValues(timeserietypeID="2",
                              fromPeriod="20151227",
                              toPeriod="20151231",
                              stations=c("19710","2650"),
                              elements=c("TA","RR_1"))
```
