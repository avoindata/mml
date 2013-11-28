### Directory contents

This directory contains automated scripts to convert data from [Land Survey Finland](http://www.maanmittauslaitos.fi/aineistot-palvelut/latauspalvelut/avoimien-aineistojen-tiedostopalvelu) (Maanmittauslaitos / MML) into RData format for convenient and light-weight downstream processing in R. 

The data sets are (C) MML 2011-2012 and openly licensed. 

This project is associated with the [rOpenGov](http://ropengov.github.io/) project.


### RData conversions

[mml2rdata.R](nnk2rdata.R) converts MML zip data files into RData
format; Some preprocessing is done to handle special characters and
harmonize ambiguous Finnish/Swedish names. Follow the script for full
details.

The converted data sets are stored in the
[rdata](https://github.com/avoindata/mml/tree/master/rdata/2012) folder.


