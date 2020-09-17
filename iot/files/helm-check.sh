#!/bin/bash
# Check whether helm init was done properly
R=$(helm list 2>&1)
RC=$?
if [ $RC == 0 ]
then
  echo "Helm OK"
else
  echo "Helm not OK: Verify whether helm was properly initialized."
  echo "RC: $RC"
  echo "DETAILS: $R"
fi
# Signal OK/not OK
exit $RC
