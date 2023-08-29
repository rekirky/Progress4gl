/*
    DEF VAR po-so AS INT LABEL "PO>SO Delay".
    DEF VAR so-ps AS INT LABEL "SO>PS Delay".
    CURRENT-WINDOW:WIDTH=280.
    FOR EACH porder WHERE porder.trans-method = "e" AND porder.transmit-time <> 0:
        FIND FIRST sorder WHERE sorder.cust-po = porder.p-order AND sorder.recv-method = "i".
            IF AVAIL sorder THEN DO:
                FIND FIRST debinv OF sorder NO-ERROR.
                    IF AVAIL debinv THEN DO:
                        IF sorder.enter-date <> porder.transmit-date THEN
                            po-so = 0.
                            ELSE 
                        po-so = sorder.enter-time - porder.transmit-time.
                        IF debinv.enter-date <> sorder.enter-date THEN
                            NEXT.
                        ELSE 
                            so-ps = debinv.enter-time - sorder.enter-time.
                        DISPLAY porder.p-order 
                                porder.transmit-date 
                                string(porder.transmit-time,"HH:MM:SS") LABEL "PO Time"
                                sorder.s-order 
                                sorder.enter-date 
                                string(sorder.enter-time,"HH:MM:SS") LABEL "SO Time"
                                po-so
                                debinv.invoice debinv.enter-date 
                                string(debinv.enter-time,"HH:MM:SS") LABEL "PS Time"
                                so-ps
                                WITH WIDTH 280.
                    END.
            END.
    END.
 */

OUTPUT TO VALUE("c:\temp\intdistimedelay.csv").
DEF VAR po-so AS INT LABEL "PO>SO Delay".
    DEF VAR so-ps AS INT LABEL "SO>PS Delay".
    CURRENT-WINDOW:WIDTH=280.
    FOR EACH porder WHERE porder.trans-method = "e" AND porder.transmit-time <> 0:
        FIND FIRST sorder WHERE sorder.cust-po = porder.p-order AND sorder.recv-method = "i".
            IF AVAIL sorder THEN DO:
                FIND FIRST debinv OF sorder NO-ERROR.
                    IF AVAIL debinv THEN DO:
                        IF sorder.enter-date <> porder.transmit-date THEN
                            po-so = 0.
                            ELSE 
                        po-so = sorder.enter-time - porder.transmit-time.
                        IF debinv.enter-date <> sorder.enter-date THEN
                            NEXT.
                        ELSE 
                            so-ps = debinv.enter-time - sorder.enter-time.
                        EXPORT DELIMITER "," porder.p-order 
                                porder.transmit-date 
                                string(porder.transmit-time,"HH:MM:SS") LABEL "PO Time"
                                sorder.s-order 
                                sorder.enter-date 
                                string(sorder.enter-time,"HH:MM:SS") LABEL "SO Time"
                                po-so
                                debinv.invoice debinv.enter-date 
                                string(debinv.enter-time,"HH:MM:SS") LABEL "PS Time"
                                so-ps.
                      END.
            END.
    END.
OUTPUT CLOSE.
