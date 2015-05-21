--=========================================
--
--
--DSTBoulder:dst20lp05:/db2prod/2015tony$ more delcd.sql
--
--delete from eaadmin.cause_code c where c.id in  (select cc.id from  eaadmin.cause_code cc join eaadmin.alert_unlicensed_sw aus on cc.alert_id=aus.id  where cc.alert_type_id=17 and aus.installed_so
--ftware_id in 
--(select is.id from eaadmin.software_lpar sl join eaadmin.installed_software is on is.software_lpar_id=sl.id join eaadmin.software s on is.software_id=s.software_id where sl.customer_id = 1303 and 
--( (is.status != 'ACTIVE' and days(current timestamp) - days(is.record_time) > 50)   or (sl.status != 'ACTIVE' and days(current timestamp) - days(sl.record_time) > 50) or  (s.status != 'ACTIVE')  )
--));
--DSTBoulder:dst20lp05:/db2prod/2015tony$ 
--
--===========================please add following  index  and retest again===============================
--
-- LIST OF RECOMMENDED INDEXES
-- ===========================
-- index[1],  209.950MB
   CREATE INDEX "EAADMIN "."IDX1504280213240" ON "EAADMIN "."SOFTWARE_LPAR"
   ("CUSTOMER_ID" ASC, "RECORD_TIME" ASC, "STATUS" ASC,
   "ID" ASC) ALLOW REVERSE SCANS COLLECT SAMPLED DETAILED STATISTICS;
   COMMIT WORK ;
-- index[2],  681.938MB
   CREATE INDEX "EAADMIN "."IDX1504280214510" ON "EAADMIN "."INSTALLED_SOFTWARE"
   ("SOFTWARE_LPAR_ID" ASC, "ID" ASC, "RECORD_TIME" ASC,
   "STATUS" ASC, "SOFTWARE_ID" ASC) ALLOW REVERSE SCANS COLLECT SAMPLED DETAILED STATISTICS;
   COMMIT WORK ;
-- index[3],  234.599MB
   CREATE UNIQUE INDEX "EAADMIN "."IDX1504280214330"
   ON "EAADMIN "."ALERT_UNLICENSED_SW" ("INSTALLED_SOFTWARE_ID"
   ASC) INCLUDE ("ID") ALLOW REVERSE SCANS COLLECT SAMPLED DETAILED STATISTICS;
   COMMIT WORK ;
-- index[4],  404.716MB
   CREATE UNIQUE INDEX "EAADMIN "."IDX1504280214540"
   ON "EAADMIN "."CAUSE_CODE" ("ALERT_ID" ASC, "ALERT_TYPE_ID"
   ASC) INCLUDE ("ID") ALLOW REVERSE SCANS COLLECT SAMPLED DETAILED STATISTICS;
   COMMIT WORK ;


-- LIST OF RECOMMENDED INDEXES                                                                                       
-- ===========================                                                                                       
-- index[1],  234.599MB                                                                                              
   CREATE UNIQUE INDEX "EAADMIN"."IDX1504280740510"                                                                  
   ON "EAADMIN "."ALERT_UNLICENSED_SW" ("INSTALLED_SOFTWARE_ID"                                                      
   ASC) INCLUDE ("ID") ALLOW REVERSE SCANS COLLECT SAMPLED DETAILED STATISTICS;                                      
   COMMIT WORK ;                                                                                                     
-- index[2],  404.716MB                                                                                              
   CREATE UNIQUE INDEX "EAADMIN"."IDX1504280741110"                                                                  
   ON "EAADMIN "."CAUSE_CODE" ("ID" ASC) INCLUDE ("ALERT_ID",                                                        
   "ALERT_TYPE_ID") ALLOW REVERSE SCANS COLLECT SAMPLED DETAILED STATISTICS;                                         
   COMMIT WORK ;                                                                                                     
-- index[3],   38.462MB                                                                                              
   CREATE INDEX "EAADMIN"."IDX1504280741130" ON "EAADMIN "."CAUSE_CODE_H"                                            
   ("CAUSE_CODE_ID" ASC) ALLOW REVERSE SCANS COLLECT SAMPLED DETAILED STATISTICS;                                    
   COMMIT WORK ;                                                                                                     
                                                                                                                     
                                                                                                                     
--                                                                                                                   
--                                                                                                                   
-- RECOMMENDED EXISTING INDEXES                                                                                      
-- ============================                                                                                      
 RUNSTATS ON TABLE "EAADMIN "."SOFTWARE_LPAR" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1504280213240" ;             
 COMMIT WORK ;                                                                                                       
 RUNSTATS ON TABLE "EAADMIN "."ALERT_UNLICENSED_SW" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1504280214330" ;       
 COMMIT WORK ;                                                                                                       
 RUNSTATS ON TABLE "EAADMIN "."INSTALLED_SOFTWARE" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1504280214510" ;        
 COMMIT WORK ;                                                                                                       
 RUNSTATS ON TABLE "EAADMIN "."CAUSE_CODE" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1504280214540" ;                
 COMMIT WORK ;                                                                                                       
 RUNSTATS ON TABLE "EAADMIN "."CAUSE_CODE" FOR SAMPLED DETAILED INDEX "EAADMIN "."PKCAUSECODE" ;                     
 COMMIT WORK ;                                                                                                       
 RUNSTATS ON TABLE "EAADMIN "."CAUSE_CODE_H" FOR SAMPLED DETAILED INDEX "EAADMIN "."PKCAUSECODEH" ;                  
 COMMIT WORK ;                                                                

 RUNSTATS ON TABLE "EAADMIN "."INSTALLED_SOFTWARE" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1312302050590" ;
 COMMIT WORK ; 
 RUNSTATS ON TABLE "EAADMIN "."CAUSE_CODE" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1402061345380" ; 
 COMMIT WORK ;
 RUNSTATS ON TABLE "EAADMIN "."SOFTWARE_LPAR" FOR SAMPLED DETAILED INDEX "EAADMIN "."IF2SOFTWARELPAR" ;
 COMMIT WORK ;
 RUNSTATS ON TABLE "EAADMIN "."ALERT_UNLICENSED_SW" FOR SAMPLED DETAILED INDEX "EAADMIN "."PKALERTUNLICSW" ;
 COMMIT WORK ;
 
 
 
-- DSTBoulder:dst20lp05:/db2prod/2015tony$ vi sel11.sql
--"sel11.sql" [New file] 
--
--select * from ( select rownumber() over() as rownumber_, count(distinct installeds1_.SOFTWARE_ID) as col_0_0_ from eaadmin.ALERT_UNLICENSED_SW alertunlic0_, eaadmin.INSTALLED_SOFTWARE installeds1_
--, eaadmin.SOFTWARE software2_, eaadmin.V_SOFTWARE_LPAR_PROCESSOR vsoftwarel4_ left outer join eaadmin.HW_SW_COMPOSITE vsoftwarel4_1_ on vsoftwarel4_.ID=vsoftwarel4_1_.SOFTWARE_LPAR_ID where alertu
--nlic0_.INSTALLED_SOFTWARE_ID=installeds1_.ID and installeds1_.SOFTWARE_ID=software2_.SOFTWARE_ID and installeds1_.SOFTWARE_LPAR_ID=vsoftwarel4_.ID and vsoftwarel4_.CUSTOMER_ID=16470 and alertunlic
--0_.TYPE='ISV' and alertunlic0_.OPEN=1 ) as temp_ where rownumber_ <=1000
--;
--
--
--=========================
--DSTBoulder:dst20lp05:/db2prod/2015tony$ db2advis -d trailspd -i sel11.sql  -n eaadmin                               
--execution started at timestamp 2015-04-30-03.57.01.362128                                                           
--found [1] SQL statements from the input file                                                                        
--Recommending indexes...                                                                                             
--total disk space needed for initial set [ 200.916] MB                                                               
--total disk space constrained to         [22877.135] MB                                                              
--Trying variations of the solution set.                                                                              
 -- 4  indexes in current solution                                                                                    
-- [76235.0000] timerons  (without recommendations)                                                                   
-- [74449.0000] timerons  (with current solution)                                                                     
-- [2.34%] improvement                                                                                                
--                                                                                                                   
--                                                                                                                   
--                                                                                                                  
--                                                                                                                  
-- LIST OF RECOMMENDED INDEXES                                                                                      
-- ===========================                                                                                      
-- index[1],  200.024MB                                                                                             
   CREATE INDEX "EAADMIN "."IDX1504301002520" ON "EAADMIN "."ALERT_UNLICENSED_SW"                                   
   ("OPEN" ASC, "TYPE" ASC, "INSTALLED_SOFTWARE_ID" ASC)                                                            
   ALLOW REVERSE SCANS COLLECT SAMPLED DETAILED STATISTICS;                                                         
   COMMIT WORK ;                                                                                                    
-- index[2],    0.892MB                                                                                             
   CREATE INDEX "EAADMIN "."IDX1504301002400" ON "EAADMIN "."SOFTWARE"                                              
   ("SOFTWARE_ID" ASC) ALLOW REVERSE SCANS COLLECT SAMPLED DETAILED STATISTICS;                                     
   COMMIT WORK ;                                                                                                    
                                                                                                                    
                                                                                                                    
--                                                                                                                  
--                                                                                                                  
-- RECOMMENDED EXISTING INDEXES                                                                                     
-- ============================                                                                                     
 RUNSTATS ON TABLE "EAADMIN "."INSTALLED_SOFTWARE" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1312281451450" ;       
 COMMIT WORK ;                                                                                                      
 RUNSTATS ON TABLE "EAADMIN "."SOFTWARE_LPAR" FOR SAMPLED DETAILED INDEX "EAADMIN "."IF2SOFTWARELPAR" ;             
 COMMIT WORK ;                                                                                                      
 RUNSTATS ON TABLE "EAADMIN "."ALERT_UNLICENSED_SW" FOR SAMPLED DETAILED INDEX "EAADMIN "."IF3ALERTUNLICSW" ;       
 COMMIT WORK ;                                                                                                      
                                             
--
--=====================================================
--
--DSTBoulder:dst20lp05:/db2prod/2015tony$ vi sel22.sql
--"sel22.sql" [New file] 

--select 'ALERT' as col_0_0_, alertview0_.TYPE as col_1_0_, alertview0_.DISPLAY_NAME as col_2_0_, count(alertview0_.PK) as col_3_0_ from eaadmin.V_ALERTS alertview0_ where alertview0_.CUSTOMER_ID=16
--470 and alertview0_.OPEN=1 group by 1 , alertview0_.TYPE , alertview0_.DISPLAY_NAME order by count(alertview0_.PK) desc  
--;
--
----======================================================================
--
--DSTBoulder:dst20lp05:/db2prod/2015tony$ more sel22.advis                                                                  
--execution started at timestamp 2015-04-30-04.02.12.381781                                                                 
--found [1] SQL statements from the input file                                                                              
--Recommending indexes...                                                                                                   
--total disk space needed for initial set [ 738.492] MB                                                                     
--total disk space constrained to         [22877.135] MB                                                                    
--Trying variations of the solution set.                                                                                    
--Optimization finished.                                                                                                    
--  32  indexes in current solution                                                                                         
-- [225640.0000] timerons  (without recommendations)                                                                        
-- [122500.0000] timerons  (with current solution)                                                                          
-- [45.71%] improvement                                                                                                     
--                                                                                                                         
--                                                                                                                         
--                                                                                                                        
--                                                                                                                        
-- LIST OF RECOMMENDED INDEXES                                                                                            
-- ===========================                                                                                            
-- index[1],  114.021MB                                                                                                   
   CREATE INDEX "EAADMIN "."IDX1504301005460" ON "EAADMIN "."CAUSE_CODE"                                                  
   ("ALERT_CAUSE_ID" ASC, "ALERT_TYPE_ID" ASC, "ALERT_ID"                                                                 
   ASC) ALLOW REVERSE SCANS COLLECT SAMPLED DETAILED STATISTICS;                                                          
   COMMIT WORK ;                                                                                                          
-- index[2],  294.595MB                                                                                                   
   CREATE INDEX "EAADMIN "."IDX1504301006390" ON "EAADMIN "."ALERT_UNLICENSED_SW"                                         
   ("OPEN" ASC, "TYPE" ASC, "ID" ASC, "INSTALLED_SOFTWARE_ID"                                                             
   ASC) ALLOW REVERSE SCANS COLLECT SAMPLED DETAILED STATISTICS;                                                          
   COMMIT WORK ;                                                                                                          
-- index[3],   49.368MB                                                                                                   
   CREATE INDEX "EAADMIN "."IDX1504301006220" ON "EAADMIN "."ALERT_HARDWARE"                                              
   ("OPEN" ASC, "ID" ASC, "HARDWARE_ID" ASC) ALLOW REVERSE                                                                
   SCANS COLLECT SAMPLED DETAILED STATISTICS;                                                                             
   COMMIT WORK ;                                                                                                          
-- index[4],  280.509MB                                                                                                   
   CREATE UNIQUE INDEX "EAADMIN "."IDX1504301007030"                                                                      
   ON "EAADMIN "."INSTALLED_SOFTWARE" ("SOFTWARE_LPAR_ID"                                                                 
   ASC, "ID" DESC) ALLOW REVERSE SCANS COLLECT SAMPLED DETAILED STATISTICS;                                               
   COMMIT WORK ;                                                                                                          
                                                                                                                          
                                                                                                                          
--                                                                                                                        
--                                                                                                                        
-- RECOMMENDED EXISTING INDEXES                                                                                           
-- ============================                                                                                           
RUNSTATS ON TABLE "EAADMIN "."ALERT_TYPE" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1311192013290" ;                      
COMMIT WORK ;                                                                                                             
RUNSTATS ON TABLE "EAADMIN "."CAUSE_CODE" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1311192017030" ;                      
COMMIT WORK ;                                                                                                             
RUNSTATS ON TABLE "EAADMIN "."CUSTOMER" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1312301918030" ;                        
COMMIT WORK ;                                                                                                             
RUNSTATS ON TABLE "EAADMIN "."HARDWARE" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1312301918250" ;                        
COMMIT WORK ;                                                                                                             
RUNSTATS ON TABLE "EAADMIN "."INSTALLED_SOFTWARE" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1312301918460" ;              
COMMIT WORK ;                                                                                                             
RUNSTATS ON TABLE "EAADMIN "."ALERT_UNLICENSED_SW" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1312302041250" ;             
COMMIT WORK ;                                                                                                             
RUNSTATS ON TABLE "EAADMIN "."ALERT_SW_LPAR" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1312302120270" ;                   
COMMIT WORK ;                                                                                                             
RUNSTATS ON TABLE "EAADMIN "."ALERT_CAUSE" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1402061345490" ;                     
COMMIT WORK ;                                                                                                             
RUNSTATS ON TABLE "EAADMIN "."CAUSE_CODE" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1402061348060" ;                      
COMMIT WORK ;                                                                                                             
RUNSTATS ON TABLE "EAADMIN "."ALERT_EXPIRED_SCAN" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1407090559140" ;              
COMMIT WORK ;                                                                                                             
RUNSTATS ON TABLE "EAADMIN "."ALERT_HW_LPAR" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1407090600290" ;                   
COMMIT WORK ;                                                                                                             
RUNSTATS ON TABLE "EAADMIN "."ALERT_HARDWARE" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1407090601050" ;                  
COMMIT WORK ;                                                                                                             
RUNSTATS ON TABLE "EAADMIN "."SOFTWARE_LPAR" FOR SAMPLED DETAILED INDEX "EAADMIN "."IF2SOFTWARELPAR" ;                    
COMMIT WORK ;                                                                                                             
RUNSTATS ON TABLE "EAADMIN "."HARDWARE_LPAR" FOR SAMPLED DETAILED INDEX "EAADMIN "."IF3HARDWARELPAR" ;                    
COMMIT WORK ;                                                                                                             
RUNSTATS ON TABLE "EAADMIN "."ALERT_TYPE_CAUSE" FOR SAMPLED DETAILED INDEX "EAADMIN "."PKALERTTYPECAUSE" ;                
COMMIT WORK ;     

-- RECOMMENDED EXISTING INDEXES
-- ============================
RUNSTATS ON TABLE "EAADMIN "."ALERT_CAUSE_RESPONSIBILITY" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1311192012460" ;
COMMIT WORK ;
RUNSTATS ON TABLE "EAADMIN "."ALERT_TYPE_CAUSE" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1311192013150" ;
COMMIT WORK ;
RUNSTATS ON TABLE "EAADMIN "."ALERT_TYPE" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1311192013290" ;
COMMIT WORK ;
RUNSTATS ON TABLE "EAADMIN "."SOFTWARE_LPAR" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1311192015140" ;
COMMIT WORK ;
RUNSTATS ON TABLE "EAADMIN "."CAUSE_CODE" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1311192017030" ;
COMMIT WORK ;
RUNSTATS ON TABLE "EAADMIN "."ALERT_UNLICENSED_SW" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1311192017050" ;
COMMIT WORK ;
RUNSTATS ON TABLE "EAADMIN "."ALERT_CAUSE" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1402061345490" ;
COMMIT WORK ;
RUNSTATS ON TABLE "EAADMIN "."HARDWARE_LPAR" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1407090600540" ;
COMMIT WORK ;
RUNSTATS ON TABLE "EAADMIN "."HARDWARE" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1407090601250" ;
COMMIT WORK ;
RUNSTATS ON TABLE "EAADMIN "."INSTALLED_SOFTWARE" FOR SAMPLED DETAILED INDEX "EAADMIN "."IDX1504301007030" ;
COMMIT WORK ;
RUNSTATS ON TABLE "EAADMIN "."SOFTWARE_LPAR" FOR SAMPLED DETAILED INDEX "EAADMIN "."IF5SOFTWARELPAR" ;
COMMIT WORK ;
RUNSTATS ON TABLE "EAADMIN "."CUSTOMER" FOR SAMPLED DETAILED INDEX "EAADMIN "."PKCUSTOMER" ;
COMMIT WORK ;                                                                                                                                                                               ==================================================================================================