SELECT
A.PRIMBILL AS "Customer Number",
A.MACHTYPE AS "Type",
A.MODEL AS "Model",
A.SERIAL AS "Serial",
A.MFGSER AS "MFG Serial",
A.DEFN AS "Defn",
A.INSTADD3 AS "Installed Address 3",
A.CMRST AS "State",
A.ASSETTAG AS "Asset Tag",
A.LEASSTRT AS "Lease Start",
A.LEASEND AS "Lease End",
A.COVERAGE AS "IBM Coverage Level",
A.WARRCOVG AS "Warranty Coverage Level",
A.ORDERNO AS "Order Number",
A.SCANDATE AS "Scan Date",
A.SCANCITY AS "Scan City",
A.SCANBLDG AS "Scan Bldg",
A.SCANFLR AS "Scan Floor",
A.SCANRM AS "Scan Room",
A.SCANGRID AS "Scan Grid",
A.HWSTATUS AS "Compliance Mgmt Status",
A.INSTALLD AS "Install Date",
A.WUPGSTRT AS "Warranty Upgrade Start Date",
A.WUPGAMT AS "Warranty Upgrade Amount",
A.MNTSTART AS "Maintenance Start Date",
B.LPAR AS "Hostname(s)"

FROM ATPPROD.MASTER A
left join atpprod.lpar b on (a.machtype=b.machtype and a.serial=b.serial)
--ATPPROD.LPAR B
WHERE A.CNDBACCT IN ('81650','104700')
--  AND A.MACHTYPE=B.MACHTYPE
--  AND A.SERIAL=B.SERIAL
  AND A.INVENTRY='Y'
and ((b.isocntry='US') or (b.isocntry is null))
ORDER BY A.PRIMBILL,A.MACHTYPE,A.SERIAL,B.LPAR;
