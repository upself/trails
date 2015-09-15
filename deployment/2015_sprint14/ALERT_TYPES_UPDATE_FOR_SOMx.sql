--Update the name of alert type which code is 'HARDWARE'(Alert Type Id = 3) from 'HW w/o HW LPAR' to 'SOM1a: HW WITH HOSTNAME'
update ALERT_TYPE set NAME = 'SOM1a: HW WITH HOSTNAME' where CODE = 'HARDWARE';

--Update the name of alert type which code is 'HW_LPAR'(Alert Type Id = 4) from 'HW LPAR w/o SW LPAR' to 'SOM2a: HW LPAR WITH SW LPAR'
update ALERT_TYPE set NAME = 'SOM2a: HW LPAR WITH SW LPAR' where CODE = 'HW_LPAR';

--Update the name of alert type which code is 'SW_LPAR'(Alert Type Id = 5) from 'SW LPAR w/o HW LPAR' to 'SOM2b: SW LPAR WITH HW LPAR'
update ALERT_TYPE set NAME = 'SOM2b: SW LPAR WITH HW LPAR' where CODE = 'SW_LPAR';

--Update the name of alert type which code is 'EXP_SCAN'(Alert Type Id = 6) from 'OUTDATED SW LPAR' to 'SOM2c: UNEXPIRED SW LPAR'
update ALERT_TYPE set NAME = 'SOM2c: UNEXPIRED SW LPAR' where CODE = 'EXP_SCAN';