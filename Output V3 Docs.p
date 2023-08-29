/*Start the session property super */
RUN comobj/StartSuper.p ('comobj/propertyMan.p', SESSION).
/* Start ADM Service Session Super */
RUN comobj/StartSuper.p ("comobj/admService.p", SESSION).


DEF TEMP-TABLE tt{1}docout NO-UNDO RCODE-INFORMATION
    FIELD key_id AS CHAR
    FIELD ent_code AS CHAR
    FIELD docmast_obj AS DEC
    FIELD doctemplate_obj AS DEC
    FIELD doc_type AS CHAR
    FIELD doc_code AS CHAR
    FIELD doc_name AS CHAR
    FIELD output_type AS CHAR
    FIELD output_to AS CHAR
    FIELD page_length AS INT
    FIELD option1 AS CHAR
    FIELD option2 AS CHAR
    FIELD option3 AS CHAR
    FIELD option4 AS CHAR
    FIELD option5 AS CHAR
    /* XML Fields */
    FIELD DocumentControlFile AS CHAR
    FIELD DocumentType AS CHAR
    FIELD DocumentSubType AS CHAR
    FIELD DocumentSource AS CHAR
    FIELD DocumentReprint AS LOG INIT NO
    FIELD DocumentCompany AS CHAR
    FIELD DocumentOrientation AS char
    FIELD PrinterName AS CHAR
    FIELD PrinterLocation AS CHAR
    FIELD PrinterSpool AS CHAR
    FIELD PrinterDevice AS CHAR
    FIELD PrinterNumCopies AS INT INIT 1
    FIELD FaxTo AS CHAR
    FIELD FaxAttention AS CHAR
    FIELD FaxSubject AS CHAR
    FIELD FaxFrom AS CHAR
    FIELD FaxNumber AS CHAR
    FIELD FaxReference AS CHAR
    FIELD FaxSendTime AS DEC
    FIELD FaxSendDate AS DATE INIT TODAY
    FIELD FaxPriority AS INT INIT 5
    FIELD FaxUseCoverSheet AS LOG
    FIELD FaxCoverSheetNote AS CHAR
    FIELD FaxServer AS CHAR
    FIELD FaxPort AS CHAR
    FIELD FaxAccessKey AS CHAR
    FIELD FaxNotifyByEmail AS LOG
    FIELD FaxNotifyEmailAddress AS CHAR
    FIELD FaxUseOnlineFax AS LOG     
    FIELD FaxEmailServer AS CHAR
    FIELD FaxEmailPort AS CHAR
    FIELD FaxOnlineFaxingDomain AS CHAR 
    FIELD FaxOnlineFaxingEmail AS CHAR 
    FIELD EmailTo AS CHAR
    FIELD EmailCC AS CHAR
    FIELD EmailBCC AS CHAR
    FIELD EmailSubject AS CHAR
    FIELD EmailFrom AS CHAR
    FIELD EmailReplyTo AS CHAR  
    FIELD EmailAttachments AS CHAR /* Any file chosen by the user to attach to the email */
    FIELD EmailBody AS CHAR
    FIELD EmailAttachmentName AS CHAR /* Overriden name of document to be emailed */
    FIELD EmailServer AS CHAR
    FIELD EmailPort AS CHAR
    FIELD FileName AS CHAR
    FIELD ExportReference AS CHAR 
    FIELD FileMode AS CHAR
    FIELD SortOrder AS CHAR
    FIELD BusinessObjectKeyID AS CHAR
    FIELD BusinessObjectTableID AS CHARACTER.
        
        DEF VAR hProc AS HANDLE NO-UNDO.
        DEF VAR lStatus AS LOG NO-UNDO.
        DEF VAR cStatusMsg    AS CHAR NO-UNDO.
        //def var i as int no-undo.
    
        //FIND PRINTER WHERE PRINTER.PRINTER = 'production'.
        
        FIND FIRST debinv.
        FIND FIRST quote.
        FIND FIRST debtor.

        RUN SendDoc("in", debinv.invoice, debinv.ent_code_sale).
        RUN SendDoc("quo", quote.q_docnum, quote.ent_code_sale).
        RUN SendDoc("cs", debtor.deb_id, debinv.ent_code_sale).

PROCEDURE SendDoc.

DEFINE INPUT PARAMETER docType AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER docNum AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER docEnt AS CHAR NO-UNDO.

RUN svrobj/docdefex.p("", docType, docNum, docEnt, "", "", "", "", OUTPUT TABLE ttdocout). 

        FIND FIRST ttdocout.
        
        ASSIGN ttdocout.output_to = 'Email' 
            ttdocout.PrinterName = ''
            ttdocout.PrinterSpool = ''
            ttdocout.PrinterDevice = ''
            ttdocout.DocumentReprint = YES
            ttdocout.EmailTo = 'matthew.edwards@markinson.com.au'
            ttdocout.EmailFrom = 'data@autogenerate.com'
            ttdocout.EmailServer = 'mail.markinson.biz'
            ttdocout.EmailPort = '25'
            ttdocout.EmailAttachmentName = 'document.pdf'
            ttdocout.EmailSubject = docType + "_" + docNum
            ttdocout.FaxNumber = ''.
        RELEASE ttdocout.        
        
    
        
            RUN svrobj/docout.p PERSISTENT SET hProc.
            
            RUN Create IN hProc (TABLE ttdocout, OUTPUT lStatus).
            IF lStatus = NO THEN DO:
                MESSAGE 'An error occurred while calling docout.create'
                    VIEW-AS ALERT-BOX.            
            END.
        
            RUN SendAndDestroy IN hProc(OUTPUT lStatus, OUTPUT cStatusMsg).
            IF lStatus = NO THEN DO:
                MESSAGE 'An error occurred while calling docout.SendAndDestroy - ' +
                    cStatusMsg VIEW-AS ALERT-BOX.            
            END.


END PROCEDURE.

        
        /*
        ASSIGN ttdocout.output_to = 'Printer' 
            ttdocout.PrinterName = PRINTER.PRINTER 
            ttdocout.PrinterSpool = PRINTER.printer_spool 
            ttdocout.PrinterDevice = PRINTER.PRINTER_device 
            ttdocout.PrinterNumCopies = 1
            ttdocout.DocumentReprint = YES
            ttdocout.EmailTo = ''
            ttdocout.FaxNumber = ''.*/    
  



