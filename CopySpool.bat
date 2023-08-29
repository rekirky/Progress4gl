@echo off

set INPUT1= "\\EMP-EDM-02\c$\PSD Share\PSD-192 Running Test Cases"
:start
echo Which Company:
echo CNW - SAM - SHE
set COM=
set /P COM=Type input: %=%

echo Which Document?:
echo OA - Order Acknowledgement
echo PO - Purchase Order
echo PRO - Proforma
echo PS - Pick Slip
echo QUO - Quote
echo REM - Remittance
echo RFC - Request for Credit
echo SCN - Sundry Credit Note
echo SIN - Sundry Invoice
echo SECN - Service Credit Note
echo SEIN - Service Invoice
echo STAT - Statement
set DOC=
set /P DOC=Type input: %=%

copy /b %INPUT1%\%COM%\%DOC%\*.xml \\dep01\%COM%spool01\*.spl

copy /b %INPUT1%\%COM%\%DOC%\*.xml "\\emp-edm-02\c$\File Queues\BGW\MasterQueue"

pause

goto start

