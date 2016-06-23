Solution for this User Story:		
Step 1(Not a deployment step because this step has been finished within webapp level):
 Updates the web app lib jar files with DB2 v10.1.0.4 related jdbc drivers
 
   1. db2jcc.jar
 
   2. db2jcc_license_cu.jar
 
   3. db2jcc4.jar

 Remove the following jar file from web app lib folder
 
   1. db2java.jar			

Step 2(Deploy step at the PROD Trails GUI server side):
  Backup the existing db2jcc.jar in the /usr/lib64/jvm/jre-1.7.1-ibm/lib/ext path to another home folder for example, /home/userid
  Copy the following jars into PROD trails server path: /usr/lib64/jvm/jre-1.7.1-ibm/lib/ext
 
   1. db2jcc.jar
 
   2. db2jcc_license_cu.jar

Step 3(Deploy step at the PROD Trails GUI server side):
  Update the hibernate.properties file in the path /opt/trails/conf using jdbc type 4 connection for trailspd and trailst dbs
 
   1. #pd.url=jdbc:db2:TRAILS
 
   2. pd.url=jdbc:db2://g03acirdb005.ahe.boulder.ibm.com:60084/trailspd
 
   3. #st.url=jdbc:db2:TRAILSST
 
   4. st.url=jdbc:db2://b03acirdb007.ahe.boulder.ibm.com:60084/trailsst"

Step 4:
  Stop and Start Trails GUI Tomcat server to load new jar files

Step 5:
  Login Trails PROD GUI and do some GUI operations based on testing account 35400 to make sure there is no DB error happened afer new jdbc drivers jars files have been deployed.