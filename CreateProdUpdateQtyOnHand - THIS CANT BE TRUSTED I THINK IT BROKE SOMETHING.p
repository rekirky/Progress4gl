/**
CSV File Name: prodData.csv
CSV File Format:
Barcode
Product Code
Description
Product Group
Base Price
Retail Price
Price Per (Price per 100 Unit etc)
Price Code
Warehouse (Entity Code of warehouse you want to update stock at)
QtyOnHand (Value to set the inventory.qty_on_hand to)
**/



RUN comobj/StartSuper.p ('comobj/propertyMan.p', SESSION).
RUN comobj/StartSuper.p ("comobj/admService.p", SESSION).

/** CHANGE THIS TO YES IF YOU WANT COMMIT CHANGES TO DB, ELSE IT WILL JUST GENERATE A LOG FILE **/
DEFINE VARIABLE lUpdate AS LOGICAL INITIAL NO NO-UNDO.
/**/

DEFINE VARIABLE cStatus AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTempStatus AS CHARACTER NO-UNDO.
/* Setting up a temp table to read the INPUT csv into */
DEFINE TEMP-TABLE ttProducts
    FIELD ttBarcode AS CHARACTER
    FIELD ttProdCode AS CHARACTER
    FIELD ttDescription AS CHARACTER
    FIELD ttGroup AS CHARACTER
    FIELD ttBasePrice AS DECIMAL
    FIELD ttRetailPrice AS DECIMAL
    FIELD ttPricePer AS DECIMAL
    FIELD ttProdPriceCode AS CHARACTER
    FIELD ttWarehouse AS CHARACTER
    FIELD ttQtyOnHand AS DECIMAL.
/******************************************************/

OUTPUT TO VALUE("c:\temp\prodDataLoadLog.csv").
    EXPORT DELIMITER ','
    "Barcode"
    "Product Code"
    "Description"
    "Product Group"
    "Base Price"
    "Retail Price"
    "Price Per"
    "Price Code"
    "Warehouse Code"
    "QtyOnHand"
    "Status".


  
/* Defining the input file location*/
INPUT FROM "c:\temp\prodData.csv" NO-ECHO.
/*                                 */

/* Creating a new row record in our temp table for each record in the input file */
REPEAT:
   CREATE ttProducts.
   
   IMPORT DELIMITER ","
        ttProducts.ttBarcode
        ttProducts.ttProdCode
        ttProducts.ttDescription
        ttProducts.ttGroup
        ttProducts.ttBasePrice
        ttProducts.ttRetailPrice
        ttProducts.ttPricePer
        ttProducts.ttProdPriceCode
        ttProducts.ttWarehouse
        ttProducts.ttQtyOnHand
        .
END.

INPUT CLOSE.
/********************************************************************************/

DEFINE BUFFER bProduct FOR product.

/* For every row in our tempary table to do the following*/
FOR EACH ttProducts:

    IF ttProducts.ttBarcode <> ? AND ttProducts.ttBarcode <> "" THEN DO:

        FIND FIRST product WHERE product.barcode = ttProducts.ttBarcode NO-ERROR.
        
        IF AVAILABLE product THEN DO:
        
            RUN AdjustStock(ttProducts.ttWarehouse, ttProducts.ttBarcode, ttProducts.ttQtyOnHand, lUpdate, OUTPUT cTempStatus).
        
            EXPORT DELIMITER ','
                ttProducts.ttBarcode
                ttProducts.ttProdCode
                ttProducts.ttDescription
                ttProducts.ttGroup
                ttProducts.ttBasePrice
                ttProducts.ttRetailPrice
                ttProducts.ttPricePer
                ttProducts.ttProdPriceCode
                ttProducts.ttWarehouse
                ttProducts.ttQtyOnHand
                "Product with matching barcode value exist | " + cTempStatus.    
        END.
        
        IF NOT AVAILABLE product THEN DO:
            
            IF lUpdate THEN DO:
            
                CREATE product.
                    ASSIGN product.active = YES
                           product.barcode = ttProducts.ttBarcode
                           product.base_price = ttProducts.ttBasePrice
                           product.description = ttProducts.ttDescription
                           product.price_per = ttProducts.ttPricePer
                           product.prod_code = ttProducts.ttProdCode
                           product.prod_group = ttProducts.ttGroup
                           product.prod_price_code = ttProducts.ttProdPriceCode
                           product.retail_price = ttProducts.ttRetailPrice.
          
                RUN AdjustStock(ttProducts.ttWarehouse, ttProducts.ttBarcode, ttProducts.ttQtyOnHand, lUpdate, OUTPUT cTempStatus).           
                           
                EXPORT DELIMITER ','
                    ttProducts.ttBarcode
                    ttProducts.ttProdCode
                    ttProducts.ttDescription
                    ttProducts.ttGroup
                    ttProducts.ttBasePrice
                    ttProducts.ttRetailPrice
                    ttProducts.ttPricePer
                    ttProducts.ttProdPriceCode
                    ttProducts.ttWarehouse
                    ttProducts.ttQtyOnHand
                    "Product created | " + cTempStatus.         
            
            END.
            
            IF NOT lUpdate THEN DO:
                RUN AdjustStock(ttProducts.ttWarehouse, ttProducts.ttBarcode, ttProducts.ttQtyOnHand, lUpdate, OUTPUT cTempStatus).
                
                EXPORT DELIMITER ','
                    ttProducts.ttBarcode
                    ttProducts.ttProdCode
                    ttProducts.ttDescription
                    ttProducts.ttGroup
                    ttProducts.ttBasePrice
                    ttProducts.ttRetailPrice
                    ttProducts.ttPricePer
                    ttProducts.ttProdPriceCode
                    ttProducts.ttWarehouse
                    ttProducts.ttQtyOnHand
                    "Product will be created | " + cTempStatus.
            END.
        END.  
    END.
END.

PROCEDURE AdjustStock.
DEFINE INPUT PARAMETER piWarehouse AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER piBarcode AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER piQtyOnHand AS DECIMAL NO-UNDO.
DEFINE INPUT PARAMETER piUpdate AS LOGICAL NO-UNDO.

DEFINE OUTPUT PARAMETER poStatus AS CHARACTER NO-UNDO.

FIND FIRST entity WHERE entity.ent_code = piWarehouse AND entity.warehouse NO-ERROR.

IF NOT AVAILABLE entity THEN DO:
    poStatus = "Invalid Warehouse, can't adjust stock".
END.

IF AVAILABLE entity THEN DO:

    FIND FIRST product WHERE product.barcode = piBarcode NO-ERROR.

    IF AVAILABLE product THEN DO:
        
        FIND FIRST inventory WHERE inventory.sku = product.sku AND inventory.ent_code_ware = piWarehouse EXCLUSIVE NO-ERROR.
        
        IF AVAILABLE inventory THEN DO:
        
            IF piUpdate THEN DO:
                ASSIGN inventory.qty_on_hand = piQtyOnHand.
                RELEASE inventory.
                ASSIGN poStatus = "Qty on hand updated".
            END.
            
            IF NOT piUpdate THEN DO:
                ASSIGN poStatus = "Qty on hand will be updated".
            END.
            
            
        END.
        
        IF NOT AVAILABLE inventory THEN DO:
        
            IF piUpdate THEN DO:
                CREATE inventory.
                    ASSIGN inventory.ent_code_ware = piWarehouse
                           inventory.sku = product.sku
                           inventory.qty_on_hand = piQtyOnHand.
                
                ASSIGN poStatus = "Qty on hand created".
            END.
            
            IF NOT piUpdate THEN DO:
               ASSIGN poStatus = "Qty on hand will be created".            
            END.
        END.
        
        
    END.

    IF NOT AVAILABLE product THEN DO:
        IF piUpdate THEN DO:
            ASSIGN poStatus = "Unable to find product to update qty on hand for".
        END.
        IF NOT piUpdate THEN DO:
            ASSIGN poStatus = "".
        END.
    END.

END.

END PROCEDURE.

/********************************************************/
