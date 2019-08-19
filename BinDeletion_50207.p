/* Definine Variables */
DEFINE VARIABLE lUpdate AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE entCode AS CHARACTER NO-UNDO.
/**********************/
/* USER SETTINGS - UPDATE THESE ACCORDINGLY --------------------------------------------*/
/* Set this to the warehouse to run script against */
ASSIGN entCode = "061".
/* READ THIS CAREFULLY - IMPORTANT */
/* Set this to YES if you want to delete the records + log files, NO for log files only */
ASSIGN lUpdate = NO.
/* END OF USER SETTINGS - DO NOT CHANGE ANYTHING AFTER THIS --------------------------------------------*/
/* Headers for invbin_line_log */
    OUTPUT TO VALUE("c:\temp\invbin_line_log.csv").
        EXPORT DELIMITER ','
            "Bin"
            "bin-type"
            "ent-code-ware"
            "SKU".   
/***************************************/
/* Headers for binmaster_line_log */
    OUTPUT TO VALUE("c:\temp\binmaster_line_log.csv").
        EXPORT DELIMITER ','
            "Bin"
            "Capacity"
            "Comment"
            "Description"
            "ent-code-ware"
            "last-stocktake"
            "SIP"
            "storage-type".        
/*****************************************/
/* Headers for invbinlotalloc_line_log */
    OUTPUT TO VALUE("c:\temp\invbinlotalloc_line_log.csv").
        EXPORT DELIMITER ','
            "Bin"
            "ent_code_ware"
            "invbinlotalloc_id"
            "key_id"
            "lot_serial"
            "qty_allocated"
            "sku"
            "table_id".   
/*****************************************/
/* Headers for invbinlot_line_log */
    OUTPUT TO VALUE("c:\temp\invbinlot_line_log.csv").
        EXPORT DELIMITER ','
            "Bin"
            "cost-avg"
            "Description"
            "ent-code-ware"
            "enter-date"
            "expiry-date"
            "lot-serial"
            "qty-on-hand"            
            "SKU".   
/*****************************************/
/* Dump invbin table (BEFORE) */
OUTPUT TO VALUE("c:\temp\invbin_before.csv").
FOR EACH invbin:
    EXPORT DELIMITER ','
        invbin.
END.
/*************************************************************************/
/* Dump binmaster table (BEFORE) */
OUTPUT TO VALUE("c:\temp\binmaster_before.csv").
FOR EACH binmaster:
    EXPORT DELIMITER ','
        binmaster.
END.
/*************************************************************************/
/* Dump invbinlotalloc table (BEFORE) */
OUTPUT TO VALUE("c:\temp\invbinlotalloc_before.csv").
FOR EACH invbinlotalloc:
    EXPORT DELIMITER ','
        invbinlotalloc.
END.
/*************************************************************************/
/* Dump invbinlot table (BEFORE) */
OUTPUT TO VALUE("c:\temp\invbinlot_before.csv").
FOR EACH invbinlot:
    EXPORT DELIMITER ','
        invbinlot.
END.
/*************************************************************************/
FOR EACH invbin WHERE invbin.ent-code-ware = entCode EXCLUSIVE-LOCK:
        /* Exporting to invbin_line_log.csv */
        OUTPUT TO VALUE("c:\temp\invbin_line_log.csv") APPEND.        
        EXPORT DELIMITER ','
                invbin.Bin
                invbin.bin-type
                invbin.ent-code-ware
                invbin.SKU.
        /***************************/
        OUTPUT CLOSE.
    IF lUpdate THEN DO:
        DELETE invbin.
    END.
END.
FOR EACH binmaster WHERE binmaster.ent-code-ware = entCode EXCLUSIVE-LOCK:
        /* Exporting to binmaster_line_log.csv */
        OUTPUT TO VALUE("c:\temp\binmaster_line_log.csv") APPEND.
        EXPORT DELIMITER ','
                binmaster.Bin
                binmaster.Capacity
                binmaster.Comment
                binmaster.Description
                binmaster.ent-code-ware
                binmaster.last-stocktake
                binmaster.SIP
                binmaster.storage-type.             
        /***************************/
        OUTPUT CLOSE.
    
    FOR EACH invbinlot WHERE invbinlot.ent-code-ware = binmaster.ent-code-ware AND invbinlot.Bin = binmaster.Bin EXCLUSIVE-LOCK:
        /* Exporting to invbinlotalloc_line_log.csv */
        OUTPUT TO VALUE("c:\temp\invbinlot_line_log.csv") APPEND.
        EXPORT DELIMITER ','
                invbinlot.Bin
                invbinlot.cost-avg
                invbinlot.Description
                invbinlot.ent-code-ware
                invbinlot.enter-date
                invbinlot.expiry-date
                invbinlot.lot-serial
                invbinlot.qty-on-hand                
                invbinlot.SKU.
        /***************************/
        OUTPUT CLOSE.
        
        IF lUpdate THEN DO:
            DELETE invbinlot.
        END.
    END.    
    
    FOR EACH invbinlotalloc WHERE invbinlotalloc.ent_code_ware = binmaster.ent-code-ware AND invbinlotalloc.Bin = binmaster.Bin EXCLUSIVE-LOCK:
        /* Exporting to invbinlotalloc_line_log.csv */
        OUTPUT TO VALUE("c:\temp\invbinlotalloc_line_log.csv") APPEND.
        EXPORT DELIMITER ','
                invbinlotalloc.Bin
                invbinlotalloc.ent_code_ware
                invbinlotalloc.invbinlotalloc_id
                invbinlotalloc.key_id
                invbinlotalloc.lot_serial
                invbinlotalloc.qty_allocated
                invbinlotalloc.SKU
                invbinlotalloc.table_id.
        /***************************/
        OUTPUT CLOSE.
        
        IF lUpdate THEN DO:
            DELETE invbinlotalloc.
        END.
    END.    
        
    IF lUpdate THEN DO:
        DELETE binmaster.
    END.      
END.
IF lUpdate THEN DO:
/* Dump invbin table (AFTER) */
OUTPUT TO VALUE("c:\temp\invbin_after.csv").
FOR EACH invbin:
    EXPORT DELIMITER ','
        invbin.
END.
/*************************************************************************/
/* Dump binmaster table (AFTER) */
OUTPUT TO VALUE("c:\temp\binmaster_after.csv").
FOR EACH binmaster:
    EXPORT DELIMITER ','
        binmaster.
END.
/*************************************************************************/
/* Dump invbinlotalloc table (AFTER) */
OUTPUT TO VALUE("c:\temp\invbinlotalloc_after.csv").
FOR EACH invbinlotalloc:
    EXPORT DELIMITER ','
        invbinlotalloc.
END.
/*************************************************************************/
/* Dump invbinlot table (AFTER) */
OUTPUT TO VALUE("c:\temp\invbinlot_after.csv").
FOR EACH invbinlot:
    EXPORT DELIMITER ','
        invbinlot.
END.
/*************************************************************************/
END.