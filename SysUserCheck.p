DEF VAR piUserCount AS INT.
FOR EACH sysconnect WHERE sysconnect.task_id = "CONNECT":
    /* ignore support users */
    IF sysconnect.connect_name = "support" THEN NEXT.

    ASSIGN piUserCount = piUserCount + 1.
END.

DISP piUserCount .
