/* RUN comobj/StartSuper.p ('comobj/propertyMan.p', SESSION).
RUN comobj/StartSuper.p ("comobj/admService.p", SESSION). */

    
OUTPUT TO VALUE ("c:\temp\docOutputRulesNew.csv").
    EXPORT DELIMITER ','
    "Document Type"
    "Object ID"
    "Object Name"
    "Business Object"
    "Assigned Printer"
    "Notes"
    "Docdef_Obj".
    

DEFINE VARIABLE objectId AS CHARACTER NO-UNDO.
DEFINE VARIABLE noteMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE objectType AS CHARACTER NO-UNDO.
DEFINE VARIABLE docType AS CHARACTER NO-UNDO.
DEFINE VARIABLE objectName AS CHARACTER NO-UNDO.

FOR EACH docdef WHERE docdef.output_to = "printer":

        IF AVAIL docdef THEN DO:
            ASSIGN objectId = "".
            ASSIGN noteMsg = "".
            ASSIGN docType = "".
            ASSIGN objectName = "".
            
                FIND FIRST docmast WHERE docdef.docmast_obj = docmast.docmast_obj.
                    ASSIGN objectType = docdef.table_id.
                
                    IF docdef.table_id = "debtor" THEN DO:
                        FIND FIRST debtor WHERE STRING(debtor.deb_id) = docdef.key_id.
                            IF AVAILABLE debtor THEN DO:
                                ASSIGN objectId = debtor.deb_acc.
                                ASSIGN objectName = debtor.NAME.
                            END.
                    END.
                    IF docdef.table_id = "creditor" THEN DO:
                        FIND FIRST creditor WHERE STRING(creditor.cred_id) = docdef.key_id.
                            IF AVAILABLE creditor THEN DO:
                                ASSIGN objectId = creditor.cred_acc.
                                ASSIGN objectName = creditor.NAME.
                            END.
                    END.
                    
                    IF docdef.table_id = "entity" THEN DO:
                        FIND FIRST entity WHERE entity.ent_code = docdef.key_id.
                            IF AVAILABLE entity THEN DO:
                                ASSIGN objectId = entity.ent_code.
                                ASSIGN objectName = entity.NAME.
                            END.
                    END.
                    
                    IF docdef.printer = "" THEN DO:
                        ASSIGN noteMsg = "This document rule is for a printer, but has no printer assigned.".     
                    END.
                    
                    IF docmast.doc_type = "BC" THEN DO:
                        ASSIGN docType = "Barcode Label".
                    END.
                    IF docmast.doc_type = "BP" THEN DO:
                        ASSIGN docType = "Bank Payment".
                    END.
                    IF docmast.doc_type = "CAL" THEN DO:
                        ASSIGN docType = "Customer Address Label".
                    END.
                    IF docmast.doc_type = "CN" THEN DO:
                        ASSIGN docType = "Sales Credit Note".
                    END.                    
                    IF docmast.doc_type = "CPI" THEN DO:
                        ASSIGN docType = "Consolidated Pick List".
                    END.                    
                    IF docmast.doc_type = "CS" THEN DO:
                        ASSIGN docType = "Customer Statement".
                    END.
                    IF docmast.doc_type = "DCI" THEN DO:
                        ASSIGN docType = "Dismantle Register Check In".
                    END.
                    IF docmast.doc_type = "DCR" THEN DO:
                        ASSIGN docType = "Receipt Docket".
                    END.
                    IF docmast.doc_type = "DID" THEN DO:
                        ASSIGN docType = "Dismantle Item Document".
                    END.
                    IF docmast.doc_type = "DRD" THEN DO:
                        ASSIGN docType = "Dismantle Register Item Label".
                    END.
                    IF docmast.doc_type = "DRF" THEN DO:
                        ASSIGN docType = "Refund Docket".
                    END.
                    IF docmast.doc_type = "DRL" THEN DO:
                        ASSIGN docType = "Dismantle Register Item Label".
                    END.
                    IF docmast.doc_type = "DSP" THEN DO:
                        ASSIGN docType = "Despatch".
                    END.
                    IF docmast.doc_type = "IN" THEN DO:
                        ASSIGN docType = "Sales Invoice".
                    END.
                    IF docmast.doc_type = "LS" THEN DO:
                        ASSIGN docType = "Local Shipment".
                    END.
                    IF docmast.doc_type = "PAL" THEN DO:
                        ASSIGN docType = "Prospect Address Label".
                    END.
                    IF docmast.doc_type = "PAS" THEN DO:
                        ASSIGN docType = "Stock Put Away Sheet".
                    END.
                    IF docmast.doc_type = "PDN" THEN DO:
                        ASSIGN docType = "Production Order".
                    END.
                    IF docmast.doc_type = "PO" THEN DO:
                        ASSIGN docType = "Purchase Order".
                    END.
                    IF docmast.doc_type = "QUO" THEN DO:
                        ASSIGN docType = "Customer Quote".
                    END.
                    IF docmast.doc_type = "RA" THEN DO:
                        ASSIGN docType = "Return Authority".
                    END.
                    IF docmast.doc_type = "RCI" THEN DO:
                        ASSIGN docType = "Recipient Created Tax Invoice".
                    END.
                    IF docmast.doc_type = "REM" THEN DO:
                        ASSIGN docType = "Creditor Remittance".
                    END.
                    IF docmast.doc_type = "REP" THEN DO:
                        ASSIGN docType = "MomentumPro Report".
                    END.
                    IF docmast.doc_type = "RFC" THEN DO:
                        ASSIGN docType = "Return For Credit".
                    END.
                    IF docmast.doc_type = "SAL" THEN DO:
                        ASSIGN docType = "Supplier Address List".
                    END.
                    IF docmast.doc_type = "SC" THEN DO:
                        ASSIGN docType = "Customer Sundry Credit Note".
                    END.
                    IF docmast.doc_type = "SCA" THEN DO:
                        ASSIGN docType = "Service call".
                    END.
                    IF docmast.doc_type = "SI" THEN DO:
                        ASSIGN docType = "Customer Sundry Invoice".
                    END.                    
                    IF docmast.doc_type = "SO" THEN DO:
                        ASSIGN docType = "Sales Order".
                    END.                   
                    IF docmast.doc_type = "SSC" THEN DO:
                        ASSIGN docType = "Supplier Sundry Credit Note".
                    END.                    
                    IF docmast.doc_type = "SSI" THEN DO:
                        ASSIGN docType = "Supplier Sundry Invoice".
                    END.                    
                    IF docmast.doc_type = "SVC" THEN DO:
                        ASSIGN docType = "Service Credit Note".
                    END.
                    IF docmast.doc_type = "SVI" THEN DO:
                        ASSIGN docType = "Service Invoice".
                    END.                    
                    IF docmast.doc_type = "SVO" THEN DO:
                        ASSIGN docType = "Service Order".
                    END.                    
                    
                    EXPORT DELIMITER ','
                        docType
                        objectId
                        objectName
                        docdef.table_id
                        docdef.printer
                        noteMsg
                        docdef_obj.
            END.       
END.

