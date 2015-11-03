--Set IS_DQ column values for all alert type records for Story 33909
update ALERT_TYPE set IS_DQ = 1 where CODE in ('HWNCHP','HWNPRC','NCPMDL','NPRCTYP','NULLTIME','NOCUST','NOLP','NOOS','ZEROPROC','NOSW');
update ALERT_TYPE set IS_DQ = 0 where CODE in ('HARDWARE','HWCFGDTA','HW_LPAR','SW_LPAR','EXP_SCAN','SWISCOPE','SWIBM','SWISVPR','SWISVNPR','NOLIC');