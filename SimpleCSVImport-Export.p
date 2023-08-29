/* Setting up a temp table to read the INPUT csv into */
DEFINE TEMP-TABLE ttSuppliers
    FIELD ttSupplierId AS CHARACTER
    FIELD ttTaxType AS CHARACTER.
/******************************************************/

/* Defining variable so we can assign a value to it so it can be export to a CSV file */
DEFINE VARIABLE newTaxType AS CHARACTER.
/**************************************************************************************/

/* Defining the output file location, delimiter type and column headings */
OUTPUT TO VALUE("c:\temp\supplierMaintNew.csv").
    EXPORT DELIMITER ','
    "SupplierID"
    "Provided Type"
    "Tax Type".
/*************************************************************************/
  
/* Defining the input file location*/
INPUT FROM "c:\temp\supplierMaint.csv" NO-ECHO.
/*                                 */

/* Creating a new row record in our temp table for each record in the input file */
REPEAT:
   CREATE ttSuppliers.
   
   IMPORT DELIMITER ","
        ttSuppliers.ttSupplierId
        ttSuppliers.ttTaxType.
END.

INPUT CLOSE.
/********************************************************************************/

/* For every row in our tempary table to do the following*/
FOR EACH ttSuppliers:
    ASSIGN newTaxType = "".
    IF ttSuppliers.ttTaxType = "F" THEN DO:
    ASSIGN newTaxType = "Import".
    END.
    IF ttSuppliers.ttTaxType = "A" THEN DO:
    ASSIGN newTaxType = "Resident".
    END.
        /* Exporting to a CSV file */
        EXPORT DELIMITER ','
                ttSuppliers.ttSupplierId
                ttSuppliers.ttTaxType
                newTaxType.
        /***************************/
END.
/********************************************************/
