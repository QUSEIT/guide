#!/bin/bash
rm -fr ../docs
make html

#mv static static
#mv sources sources

cd build/html && find . -name "*.html" -exec python2 ../../add-analytics.py {} \; && find . -name "*.html" -exec sed -i -e 's/_static/static/g;s/_images/images/g' {} \; && find . -name "*-e" -exec rm {} \; && mv _static static && mv _images  images

cd ../.. && mv build/html  ../docs && cp CNAME ../docs  && cp favicon.ico  ../docs
