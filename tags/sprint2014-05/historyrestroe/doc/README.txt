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
password=<deleted>

1.3 put the history data into path /var/ftp/EMEA/HISTORY_TABLES.txt.

2. Format of the history data. 
2.1 It's tab separated(TSV) . 
2.2. Head of the file. 

Installed Software Id	
Reconcile Type Id	
Id	
Parent Installed Software Id	
Comments	
Remote User	
Record Time	
Machine Level	
Reconcile H	
Manual Break	
H Reconcile Id	
H Used License Id	
Id2	
License Id	
Used Quantity	
Capacity 
Type Id

3. Command to launch the program:
3.1. 
cat /dev/null > log.txt;
nohup java -cp restore.jar:db2jcc_license_cu.jar:db2jcc.jar Restore /home/zyizhang/restore/conf.txt /var/ftp/EMEA/temp/HISTORY_TABLES_2.txt > log2.txt &

There are 3 parameters separated by space. 
java Restore [configure file] [source file] [logging level]

the first 2 parameters are required,
configure file: database configuration information for the program. see 1.2 for reference. 
source file: contains the data need to be recovery. see 2. for reference. 
logging level: empty or -1 - normal, 0 - debug

 