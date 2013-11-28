### Directory contents

[rdata](rdata) Key data sets from MML in RData format

[rscripts](rscripts) Automated scripts that were used to convert [MML](http://www.maanmittauslaitos.fi/aineistot-palvelut/latauspalvelut/avoimien-aineistojen-tiedostopalvelu) GIS data into RData format. 

This repository is associated with the [rOpenGov](http://ropengov.github.io/) project.

### Available data sets in R

Currently these map collections are available as RData files:

2013
=========

 * [Yleiskartta-1000](http://www.maanmittauslaitos.fi/digituotteet/yleiskartta-11-000-000) (converted with [kapsi2rdata.R](rscripts/Kapsi/kapsi2rdata.R)) ([code descriptions PDF](http://www.maanmittauslaitos.fi/sites/default/files/Yleiskartta_1milj_koodit.pdf))
 * [Yleiskartta-4500](http://www.maanmittauslaitos.fi/digituotteet/yleiskartta-14-500-000) (converted with [kapsi2rdata.R](rscripts/Kapsi/kapsi2rdata.R))
 * [Maastotietokanta tiestö 1 (N61)](http://kartat.kapsi.fi/files/maastotietokanta/tiesto_osoitteilla/etrs89/shp/N61.shp.zip) (converted with [kapsi2rdata.R](rscripts/Kapsi/kapsi2rdata.R))
 * [Maastotietokanta tiestö 2 (N62)](http://kartat.kapsi.fi/files/maastotietokanta/tiesto_osoitteilla/etrs89/shp/N62.shp.zip) (converted with [kapsi2rdata.R](rscripts/Kapsi/kapsi2rdata.R))

2012
=========

We also host some older versions of Finnish MML maps:

 * [2012/Yleiskartta-1000](http://www.maanmittauslaitos.fi/digituotteet/yleiskartta-11-000-000) (converted with [mml2rdata.R](rscripts/MML/mml2rdata.R)) ([code descriptions PDF](rdata/2012/1_milj_koodit.txt))
 * [2012/Yleiskartta-4500](http://www.maanmittauslaitos.fi/digituotteet/yleiskartta-14-500-000) (converted with [mml2rdata.R](rscripts/MML/mml2rdata.R)) ([code descriptions PDF](rdata/2012/45_milj_koodit.txt))


We are looking forward to add more when time allows. Your
contributions are welcome. See the [TODO](rscripts/Kapsi/TODO) file.


### License

The data sets are (C) MML 2013. The data is available with an open license. For details, see the [MML site](http://www.maanmittauslaitos.fi/node/6417). All scripts in this directory are available with the FreeBSD (BSD-2-clause) license:

Copyright (c) 2011-2013, Leo Lahti / Louhos
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
