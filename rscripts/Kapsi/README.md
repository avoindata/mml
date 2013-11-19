This directory contains automated scripts to convert GIS data from [Land Survey Finland](http://www.maanmittauslaitos.fi/aineistot-palvelut/latauspalvelut/avoimien-aineistojen-tiedostopalvelu) (Maanmittauslaitos / MML) into RData format for convenient and light-weight downstream processing in R. The data sets are (C) MML 2013 and openly licensed.

Downloading the maps from the original [MML site](http://www.maanmittauslaitos.fi/aineistot-palvelut/latauspalvelut/avoimien-aineistojen-tiedostopalvelu) requires authentication. We hence get the data through [Kapsi](http://kartat.kapsi.fi/http://kartat.kapsi.fi/), allowing direct downloads.

This project is associated with the [rOpenGov](http://ropengov.github.io/) project.


### Kapsi to RData conversions

[kapsi2rdata.R](kapsi2rdata.R) converts key data files from MML into RData files

This downloads [MML
data](http://www.maanmittauslaitos.fi/aineistot-palvelut/latauspalvelut/avoimien-aineistojen-tiedostopalvelu)
from [Kapsi](http://kartat.kapsi.fi/) and converts it into RData
format. Some preprocessing is done to handle special characters and
harmonize ambiguous Finnish/Swedish names. Follow the script for full
details.

The converted data sets are stored in the
[rdata](https://github.com/avoindata/mml/tree/master/rdata) folder.

### Available data sets in R

Currently these map collections are available as RData files:

 * [Yleiskartta 1000](http://www.maanmittauslaitos.fi/digituotteet/yleiskartta-11-000-000)
 * [Yleiskartta 4500](http://www.maanmittauslaitos.fi/digituotteet/yleiskartta-14-500-000)

We are looking forward to add more when time allows. Your
contributions are welcome.


### License

The data sets are (C) MML 2013. The data is available with an open license. For details, see the [MML site](http://www.maanmittauslaitos.fi/node/6417). All scripts in this directory are available with the FreeBSD (BSD-2-clause) license:

Copyright (c) 2011-2013, Leo Lahti / Louhos
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
