DEFINE VARIABLE filename  AS CHARACTER NO-UNDO.   /* The file to be imported */

DEFINE TEMP-TABLE t NO-UNDO /* The temp table to be created */
    FIELD f1 AS INTEGER     /* Modify fields to match requirements */
    FIELD f2 AS CHARACTER.

DEFINE STREAM strImport.    /* The import process */

  SYSTEM-DIALOG GET-FILE filename /* This block allows user to select a file */
    TITLE   "Choose file to load"
    FILTERS "Comma Seperated Values (*.csv)"   "*.csv" /* Option to limit file type */
    MUST-EXIST
    USE-FILENAME.

INPUT STREAM strImport FROM VALUE (filename). /* Imports file into temp table */
REPEAT:
    CREATE t.
        IMPORT STREAM strImport DELIMITER "," t.
     END.
INPUT CLOSE.
 
FOR EACH t:           /* Querying can now be made on temp table data */
    DISPLAY  t.
END.

