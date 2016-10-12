# wsklimaR

wsklimaR is designed to get an easy access to the stations from the Klimadata webservice at met.no [wsklima](http://eklima.met.no/wsKlima/start/start_en.html).

No identification is required to use this service.

This service is not very young. Do not send too many requests at a time.

[Met.no](http://met.no) is spending  hours in order to replace it by a robust service (METAPI). 

Nonetheless METAPI is still under development and can then be interrupted without any warning.

## Installation

```R
# install.packages("devtools")
devtools::install_github("nexmodeling/wsklimaR")
```

## Example

Get the hourly temperature at stations no 19710, 19720, 2650, 19480, 18265, 4870 between 27/12/2015 and 31/12/2015

```R
values <- wsklimaR.getValues(timeserietypeID="2",
                             fromPeriod="20151227",
                             toPeriod="20151231",
                             stations=c("19710","19720","2650","19480","18265","4870"),
                             elements=c("TA"))
```

The results is a data.frame easily convertible into a json file

