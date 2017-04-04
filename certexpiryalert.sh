#!/bin/bash
REPORTBEFOREDAYS=45
MAILINGLIST="<yourname>@<domain>.com"
DOMAINS=("www.google.com" "www.yahoo.com") 
MAILCONTENT="<html><body><h2> SSL CERTIFICATES EXPIRING SOON </h2><table border=1px><tr> <td> CERTIFICATE NAME </td> <td> Expiring in Days </td>"
EXPIRED="false"
for DOMAIN in "${DOMAINS[@]}" ; do
  echo "===> checking certificate expiry for certificate" $DOMAIN

  ExpiryDate=$(echo | openssl s_client -servername ${DOMAIN} -connect ${DOMAIN}:443 2>/dev/null | openssl x509 -noout -enddate | awk -F "=" '{print $2}')

  ExpiryMonth=`echo $ExpiryDate | awk -F ' ' '{print $1}'`
  ExpiryDay=`echo $ExpiryDate | awk -F ' ' '{print $2}'`
  ExpiryYear=`echo $ExpiryDate | awk -F ' ' '{print $4}'`

  TARGET=$(date -u -d "$ExpiryMonth $ExpiryDay $ExpiryYear" '+%b %d %Y')
  CRTVALUE=$(date --date="${TARGET}" +%s)
  TDYVALUE=$(date +%s)
  DIFFVALUE=$(( $CRTVALUE - $TDYVALUE ))
  NUMDAYS=$(( $DIFFVALUE / 86400 ))
  if [[ "$NUMDAYS" -gt "$REPORTBEFOREDAYS" ]]; then
     echo "IGNORED -> $NUMDAYS"
  else
     echo "EXPIRED"
     MAILCONTENT+="<tr> <td> $DOMAIN </td> <td> $NUMDAYS </td>"
     EXPIRED="true"
  fi
done
MAILCONTENT+="</table></br> ---------  </br>Please work with approriate engineering group to renew certificate in timely fashion."
if [[ "$EXPIRED" = "true" ]]; then
echo $MAILCONTENT | mail -s "$(echo -e "SSL Certificate Expiring in $REPORTBEFOREDAYS Days\nContent-Type: text/html")" $mailinglist
fi
