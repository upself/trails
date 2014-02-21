1. Steps to set up the restoring program.

1.1 copy all the jar files in the lib folder to target place. 
e.g. 
[root@tap2 restore]# ls -rtlh
total 7.3M

-rw-r--r--  1 root root  120 Feb 21 03:20 conf.txt
-rw-r--r--  1 root root 7.1K Feb 21 09:31 restore.jar
-rw-r--r--  1 root root 1015 Feb 21  2014 db2jcc_license_cu.jar
-rw-r--r--  1 root root 3.5M Feb 21  2014 db2jcc.jar
	  
1.2 edit conf.txt file for DB connection and password. 
e.g.

driver=com.ibm.db2.jcc.DB2Driver
url=jdbc:db2://dst20lp05.boulder.ibm.com:50000/trailspd
user=eaadmin
password=12345


2. Command to launch the program:
cat /dev/null > log.txt;
nohup java -cp restore.jar:db2jcc_license_cu.jar:db2jcc.jar Restore /home/zyizhang/restore/conf.txt > log.txt & 