--Update the name of alert type which code is 'HARDWARE'(Alert Type Id = 3) from 'HW w/o HW LPAR' to 'SOM1a: HW WITH HOSTNAME'
update ALERT_TYPE set NAME = 'SOM1a: HW WITH HOSTNAME' where CODE = 'HARDWARE';

--Update the name of alert type which code is 'HWCFGDTA'(Alert Type Id = 37) from 'SOM1b: HW Box Critical Configuration Data Populated' to 'SOM1b: HW BOX CRITICAL CONFIGURATION DATA POPULATED'
update ALERT_TYPE set NAME = 'SOM1b: HW BOX CRITICAL CONFIGURATION DATA POPULATED' where CODE = 'HWCFGDTA';

--Update the name of alert type which code is 'HW_LPAR'(Alert Type Id = 4) from 'HW LPAR w/o SW LPAR' to 'SOM2a: HW LPAR WITH SW LPAR'
update ALERT_TYPE set NAME = 'SOM2a: HW LPAR WITH SW LPAR' where CODE = 'HW_LPAR';

--Update the name of alert type which code is 'SW_LPAR'(Alert Type Id = 5) from 'SW LPAR w/o HW LPAR' to 'SOM2b: SW LPAR WITH HW LPAR'
update ALERT_TYPE set NAME = 'SOM2b: SW LPAR WITH HW LPAR' where CODE = 'SW_LPAR';

--Update the name of alert type which code is 'EXP_SCAN'(Alert Type Id = 6) from 'OUTDATED SW LPAR' to 'SOM2c: UNEXPIRED SW LPAR'
update ALERT_TYPE set NAME = 'SOM2c: UNEXPIRED SW LPAR' where CODE = 'EXP_SCAN';

--Update the name of alert type which code is 'SWISCOPE'(Alert Type Id = 57) from 'SOM3: SW Instances with Defined Contract Scope' to 'SOM3: SW INSTANCES WITH DEFINED CONTRACT SCOPE'
update ALERT_TYPE set NAME = 'SOM3: SW INSTANCES WITH DEFINED CONTRACT SCOPE' where CODE = 'SWISCOPE';

--Update the name of alert type which code is 'SWIBM'(Alert Type Id = 7) from 'SOM4a: IBM SW Instances Reviewed' to 'SOM4a: IBM SW INSTANCES REVIEWED'
update ALERT_TYPE set NAME = 'SOM4a: IBM SW INSTANCES REVIEWED' where CODE = 'SWIBM';

--Update the name of alert type which code is 'SWISVPR'(Alert Type Id = 58) from 'SOM4b: Priority ISV SW Instances Reviewed' to 'SOM4b: PRIORITY ISV SW INSTANCES REVIEWED'
update ALERT_TYPE set NAME = 'SOM4b: PRIORITY ISV SW INSTANCES REVIEWED' where CODE = 'SWISVPR';

--Update the name of alert type which code is 'SWISVNPR'(Alert Type Id = 59) from 'SOM4c: ISV SW Instances Reviewed' to 'SOM4c: ISV SW INSTANCES REVIEWED'
update ALERT_TYPE set NAME = 'SOM4c: ISV SW INSTANCES REVIEWED' where CODE = 'SWISVNPR';