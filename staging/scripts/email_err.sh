:
# only process if error exists
if [ -f /tmp/tmp_err.txt ]; then 
	mv /tmp/tmp_err.txt /tmp/email_err.txt
        cat /tmp/email_err.txt |mail -s "Elog Summary GHO" petr_soufek@cz.ibm.com,HDRUST@de.ibm.com,adam.trnka@cz.ibm.com,zhysz@cn.ibm.com,AMTS@cz.ibm.com,tomas.sima@cz.ibm.com,liuhaidl@cn.ibm.com,googer@us.ibm.com,alena.zimolova@cz.ibm.com,ondrej_zivnustka@cz.ibm.com
	rm /tmp/email_err.txt
fi


