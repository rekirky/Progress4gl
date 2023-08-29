/* Setting up a temp table to read the INPUT csv into */
DEFINE TEMP-TABLE ttAltProducts
    FIELD altProdCode AS CHARACTER
    FIELD altprodGroupcode AS CHARACTER
    FIELD altsearchfld AS CHARACTER
    FIELD altComment AS CHARACTER
    FIELD altDescription AS CHARACTER
    FIELD prodCode AS CHARACTER
    FIELD prodGroup AS CHARACTER.
    
/******************************************************/

/* Defining variable so we can assign a value to it so it can be export to a CSV file */
DEFINE VARIABLE DBUpdate AS LOGICAL INIT YES NO-UNDO.
/**************************************************************************************/

/* Defining the output file location, delimiter type and column headings */
OUTPUT TO VALUE("c:\temp\altProductLog.csv").
    EXPORT DELIMITER ','
    "altProdCode"
    "altprodGroupcode"
    "altsearchfld"
    "altComment"
    "altDescription"
    "prodCode"
    "prodGroup"
    "loggingData".
/*************************************************************************/
  
/* Defining the input file location*/
INPUT FROM "c:\temp\altProductsOrig.csv" NO-ECHO.
/*                                 */

/* Creating a new row record in our temp table for each record in the input file */
REPEAT:
   CREATE ttAltProducts.
   
   IMPORT DELIMITER ","
        ttAltProducts.altProdCode
        ttAltProducts.altprodGroupcode
        ttAltProducts.altsearchfld
        ttAltProducts.altComment
        ttAltProducts.altDescription
        ttAltProducts.prodCode
        ttAltProducts.prodGroup.
END.

INPUT CLOSE.
/********************************************************************************/



FOR EACH ttAltProducts:
    /* Look for all records where the product codes MATCH and log as already existing*/
FIND FIRST crossref WHERE crossref.alt_prod_code = ttAltProducts.altProdCode NO-ERROR.
    IF AVAIL crossref THEN DO:
        EXPORT DELIMITER ','
        ttAltProducts.altProdCode
        ttAltProducts.altprodGroupcode
        ttAltProducts.altsearchfld
        ttAltProducts.altComment
        ttAltProducts.altDescription
        ttAltProducts.prodCode
        ttAltProducts.prodGroup
        "This already exists!".
    END.
    /* Look for all records where the product codes DO NOT MATCH and log as added*/
    IF NOT AVAIL crossref AND ttAltProducts.altProdCode <> "" THEN DO:    

        EXPORT DELIMITER ','
        ttAltProducts.altProdCode
        ttAltProducts.altprodGroupcode
        ttAltProducts.altsearchfld
        ttAltProducts.altComment
        ttAltProducts.altDescription
        ttAltProducts.prodCode
        ttAltProducts.prodGroup
        "This product has been added!".
        IF DBUpdate = YES THEN DO:
            CREATE crossref.
            ASSIGN crossref.alt_prod_code = ttAltProducts.altProdCode
                   crossref.alt_prod_group = ttAltProducts.altprodGroupcode
                   crossref.alt_search_fld = ttAltProducts.altsearchfld
                   crossref.Comment = ttAltProducts.altComment
                   crossref.Description = ttAltProducts.altDescription
                   crossref.prod_code = ttAltProducts.prodCode
                   crossref.prod_group = ttAltProducts.prodGroup.
            END.
        END.
    END.
OUTPUT CLOSE.
