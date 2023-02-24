#!/bin/sh -x

htgettoken -a htvault.jlab.org -i jlab -r iri
httokendecode -H
