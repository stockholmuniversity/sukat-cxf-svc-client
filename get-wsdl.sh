#!/bin/bash
#
# Script to change lpw server from skarp to test or vice versa.
#
# Usage:
# ./change-server.sh skarp OR ./change-server.sh test
#
# $Id: change-server.sh 7343 2009-09-22 06:45:27Z hdrys $
#

SERVER='jqvarlocal.it.su.se'

#space seperated list of wsdl files"
WSDLFILES="CardAdminService.wsdl CardInfoService.wsdl EntitlementService.wsdl ServiceService.wsdl AccountService.wsdl Status.wsdl"

for file in $WSDLFILES; do
  base=`basename $file .wsdl`
  curl -k -o  src/main/wsdl/$file --negotiate -u : https://$SERVER/$base?wsdl
  if [ $? -ne 0 ]; then
    echo "Error: $0 can't download https://$SERVER/$base?wsdl"
    exit 1
  fi
done
