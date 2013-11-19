### Directory contents

This directory contains automated scripts to convert GIS data from [Land Survey Finland](http://www.maanmittauslaitos.fi/aineistot-palvelut/latauspalvelut/avoimien-aineistojen-tiedostopalvelu) (Maanmittauslaitos / MML) into RData format for convenient and light-weight downstream processing in R. The data sets are (C) MML 2013 and openly licensed.

Downloading the maps from the original [MML site](http://www.maanmittauslaitos.fi/aineistot-palvelut/latauspalvelut/avoimien-aineistojen-tiedostopalvelu) requires authentication. We hence get the data through [Kapsi](http://kartat.kapsi.fi/http://kartat.kapsi.fi/), allowing direct downloads.

This project is associated with the [rOpenGov](http://ropengov.github.io/) project.


### Kapsi to RData conversions

[kapsi2rdata.R](kapsi2rdata.R) converts key data files from MML into
RData files; it downloads [MML
data](http://www.maanmittauslaitos.fi/aineistot-palvelut/latauspalvelut/avoimien-aineistojen-tiedostopalvelu)
from [Kapsi](http://kartat.kapsi.fi/) and converts it into RData
format. Some preprocessing is done to handle special characters and
harmonize ambiguous Finnish/Swedish names. Follow the script for full
details.

The converted data sets are stored in the
[rdata](https://github.com/avoindata/mml/tree/master/rdata) folder.

