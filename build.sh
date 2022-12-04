#!/bin/bash
cd $(cd $(dirname $0) && pwd )
gitbook build
cp _book/gitbook/images/favicon.ico _book
