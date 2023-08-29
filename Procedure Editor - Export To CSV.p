&SCOPED-DEFINE TableToExport supprod /* Table To Export */
/* &SCOPED-DEFINE DataExport supprod.supp_prod Filter to apply - select table.field */

DEFINE VARIABLE lv-output-path AS CHARACTER NO-UNDO INITIAL "C:\temp\".  /* Output location */
DEFINE VARIABLE lv-output-type AS CHARACTER NO-UNDO INITIAL "csv".
DEFINE VARIABLE lv-headings    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv-count       AS INTEGER   NO-UNDO.

DEFINE STREAM data-export.

/* Make a list of field-headings */

FOR EACH _file NO-LOCK WHERE _file-name = "{&TableToExport}":
    FOR EACH _field OF _file NO-LOCK BY _field._Order:
        ASSIGN lv-count = 1.
        IF _field._extent = 0 THEN
            ASSIGN lv-headings = lv-headings + "," + _field._field-name.
        ELSE 
            ASSIGN lv-headings = lv-headings + "," + _field._field-name + "[1]".
        DO WHILE lv-count < _field._extent:
            ASSIGN lv-count    = lv-count + 1
                   lv-headings = lv-headings + "," + _field._field-name + "[" + STRING(lv-count) + "]".
        END.
    END.
END.

/* Output the  field-headings */

OUTPUT STREAM data-export TO VALUE(lv-output-path + "{&TableToExport}" + "." + lv-output-type).
PUT STREAM data-export UNFORMATTED LEFT-TRIM(lv-headings, ",") SKIP.

/* Output the table contents */

FOR EACH {&TableToExport} NO-LOCK. /* where {&DataExport} = "PVC10-100S".  Select variable to filter */
    EXPORT STREAM data-export DELIMITER "," {&TableToExport}.
END.

OUTPUT STREAM data-export CLOSE.