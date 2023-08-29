DEFINE TEMP-TABLE t NO-UNDO					/* This creates a temp table with 2 columns, repeat next rows as necessary */
    FIELD f1 AS INTEGER
    FIELD f2 AS CHARACTER.

DEFINE STREAM strImport.					/* Imports a csv file (C:\temp\jon.csv) - change as necessary */
DEFINE VARIABLE cCSVFile AS CHARACTER NO-UNDO.

cCSVFile = "C:\temp\jon.csv".

INPUT STREAM strImport FROM VALUE (cCSVFile).
Repeat:
   Create t.
   IMPORT STREAM strImport DELIMITER "," t.
   
   END.
INPUT CLOSE.
								/* Temp Table 't' now exists and can be used for querying. */
FOR EACH t:
FIND FIRST debtor WHERE debtor.deb_id = t.f1.
DISPLAY t.f1 debtor.name.
END.

