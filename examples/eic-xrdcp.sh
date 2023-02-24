#!/bin/sh -x

htgettoken -a htvault.jlab.org -i eic
export BEARER_TOKEN_FILE=/tmp/bt_u${UID}

hostname > xrdcp-test
date >> xrdcp-test
xrdcp -f xrdcp-test roots://dtn2201.jlab.org//eic/eic2/transfer/

