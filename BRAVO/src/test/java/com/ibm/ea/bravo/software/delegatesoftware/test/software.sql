CREATE TABLE eaadmin.software 
  ( 
     manufacturer_id, 
     software_category_id, 
     software_id, 
     software_name, 
     VERSION, 
     priority, 
     level, 
     type, 
     change_justification, 
     comments, 
     remote_user, 
     record_time, 
     status, 
     vendor_managed, 
     product_role, 
     pid 
  ) AS 
  (SELECT p.manufacturer_id, 
          pi.software_category_id, 
          p.id, 
          siP.name, 
          CAST(NULL AS VARCHAR(64)), 
          pi.priority           AS priority, 
          CASE 
            WHEN pi.licensable = 1 THEN 'LICENSABLE' 
            ELSE 'UN-LICENSABLE' 
          END, 
          CASE 
            WHEN scP.software_category_name LIKE 'Operating Systems%' THEN 'O' 
            ELSE 'A' 
          END, 
          'SWKBT', 
          'SW_PRODUCT', 
          'SWKBT', 
          kbP.modification_time AS record_time, 
          CASE 
            WHEN kbP.deleted = 1 THEN 'INACTIVE' 
            ELSE 'ACTIVE' 
          END, 
          CASE 
            WHEN Upper(kbP.custom_2) = 'TRUE' THEN 1 
            ELSE 0 
          END, 
          CASE 
            WHEN siP.product_role IS NULL THEN 'SOFTWARE_PRODUCT' 
            ELSE siP.product_role 
          END, 
          CAST(NULL AS VARCHAR(32)) 
   FROM   eaadmin.product p 
          JOIN eaadmin.product_info pi 
            ON pi.id = p.id 
          JOIN eaadmin.software_item siP 
            ON siP.id = p.id 
          JOIN eaadmin.kb_definition kbP 
            ON kbP.id = p.id 
          JOIN eaadmin.software_category scP 
            ON scP.software_category_id = pi.software_category_id 
   UNION ALL 
   SELECT mv.manufacturer_id, 
          mvpi.software_category_id, 
          mv.id, 
          siP.name 
          || ' - ' 
          || siMV.name 
          || ' - V' 
          || Rtrim(CAST(mv.VERSION AS CHAR(64))), 
          Rtrim(CAST(mv.VERSION AS CHAR(64))), 
          mvpi.priority AS priority, 
          CASE 
            WHEN mvpi.licensable = 1 THEN 'LICENSABLE' 
            ELSE 'UN-LICENSABLE' 
          END, 
          CASE 
            WHEN scMV.software_category_name LIKE 'Operating Systems%' THEN 'O' 
            ELSE 'A' 
          END, 
          'TADZ', 
          'MAINFRAME_VERSION', 
          'TADZ', 
          kbMV.modification_time, 
          CASE 
            WHEN kbMV.deleted = 1 THEN 'INACTIVE' 
            ELSE 'ACTIVE' 
          END, 
          CASE 
            WHEN Upper(kbMV.custom_2) = 'TRUE' THEN 1 
            ELSE 0 
          END, 
          CASE 
            WHEN siMV.product_role IS NULL THEN 'SOFTWARE_PRODUCT' 
            ELSE siMV.product_role 
          END, 
          pidMV.pid 
   FROM   eaadmin.mainframe_version mv 
          JOIN eaadmin.software_item siMV 
            ON siMV.id = mv.id 
          JOIN eaadmin.software_item siP 
            ON siP.id = mv.product_id 
          JOIN eaadmin.kb_definition kbMV 
            ON kbMV.id = mv.id 
          JOIN eaadmin.product_info mvpi 
            ON mvpi.id = mv.id 
          JOIN eaadmin.software_category scMV 
            ON scMV.software_category_id = mvpi.software_category_id 
          LEFT OUTER JOIN eaadmin.software_item_pid sipMV 
                       ON sipMV.software_item_id = siMV.id 
          LEFT OUTER JOIN eaadmin.pid pidMV 
                       ON pidMV.id = sipMV.pid_id 
   UNION ALL 
   SELECT mv.manufacturer_id, 
          mfpi.software_category_id, 
          mf.id, 
          siP.name 
          || ' - ' 
          || siMF.name 
          || ' - V' 
          || Rtrim(CAST(mv.VERSION AS CHAR(64))), 
          Rtrim(CAST(mv.VERSION AS CHAR(64))), 
          mfpi.priority          AS priority, 
          CASE 
            WHEN mfpi.licensable = 1 THEN 'LICENSABLE' 
            ELSE 'UN-LICENSABLE' 
          END, 
          CASE 
            WHEN scMF.software_category_name LIKE 'Operating Systems%' THEN 'O' 
            ELSE 'A' 
          END, 
          'TADZ', 
          'MAINFRAME_FEATURE', 
          'TADZ', 
          kbMF.modification_time AS record_time, 
          CASE 
            WHEN kbMF.deleted = 1 THEN 'INACTIVE' 
            ELSE 'ACTIVE' 
          END                    AS status, 
          CASE 
            WHEN Upper(kbMF.custom_2) = 'TRUE' THEN 1 
            ELSE 0 
          END                    AS vendor_managed, 
          CASE 
            WHEN siMF.product_role IS NULL THEN 'SOFTWARE_PRODUCT' 
            ELSE siMF.product_role 
          END, 
          pidMV.pid 
   FROM   eaadmin.mainframe_feature mf 
          JOIN eaadmin.mainframe_version mv 
            ON mf.version_id = mv.id 
          JOIN eaadmin.software_item siMF 
            ON siMF.id = mf.id 
          JOIN eaadmin.software_item siP 
            ON siP.id = mv.product_id 
          JOIN eaadmin.kb_definition kbMF 
            ON kbMF.id = mf.id 
          JOIN eaadmin.product_info mfpi 
            ON mfpi.id = mf.id 
          JOIN eaadmin.software_category scMF 
            ON scMF.software_category_id = mfpi.software_category_id 
          LEFT OUTER JOIN eaadmin.software_item_pid sipMV 
                       ON sipMV.software_item_id = mv.id 
          LEFT OUTER JOIN eaadmin.pid pidMV 
                       ON pidMV.id = sipMV.pid_id) 
DATA initially deferred REFRESH deferred 