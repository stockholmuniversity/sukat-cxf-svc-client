#!/bin/bash
#

SERVERURL=`echo "$1" | sed -e "s/\/*$//"`
if [ -z ${SERVERURL}  ]
     then 
     echo "usage: $0 <serverurl>"
     echo "example: $0 https://myserver.su.se/"
     exit 10
 fi

#space seperated list of wsdl files"
WSDLFILES="CardAdminService.wsdl CardInfoService.wsdl EntitlementService.wsdl ServiceService.wsdl AccountService.wsdl EnrollmentService.wsdl RoleService.wsdl Status.wsdl WebServiceAdmin.wsdl"

for file in $WSDLFILES; do
  base=`basename $file .wsdl`
  curl -k -o  src/main/wsdl/$file --negotiate -u : $SERVERURL/$base?wsdl
  if [ $? -ne 0 ]; then
    echo "Error: $0 can't download $SERVERURL/$base?wsdl"
    exit 1
  fi
done
