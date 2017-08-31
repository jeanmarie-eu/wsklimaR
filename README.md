# wsklimaR

## Update: access restriction

Because of security reason, the eklima service from met.no has closed the open
[access](https://www.met.no/nyhetsarkiv/var-tjeneste-eklima-har-begrenset-tilgang)

You still can use wsklimaR by contacting MET and providing your IP adress in order to get an identification.

## Description
wsklimaR is designed to get an easy access to stations registered by the Norwegian Meteorological Institute.

The package connects you to the Klimadata webservice from met.no [wsklima](http://eklima.met.no/wsKlima/start/start_en.html).

Send an email to MET with you IP in order to get an identification.

This service is not so young. Do not send too many requests at a time.

The output of each request is structured as a data.frame. It is easily usable as a matrix and easily convertible into a json file

## Installation

```R
# install.packages("devtools")
devtools::install_github("jeanmarie-eu/wsklimaR")
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
