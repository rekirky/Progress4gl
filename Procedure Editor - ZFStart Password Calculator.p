DEF VAR ipassword AS CHAR.
DEF VAR itoday AS CHAR.
DEF VAR daylist AS CHAR INIT "S,M,T,W,T,F,S".
DEF VAR icheck AS INT.
DEF VAR isun AS INT.

ASSIGN itoday = STRING(day(today)).
MESSAGE "How many Sundays have passed this month?" SET isun.

ASSIGN icheck = (day(today) * 2) + (isun * 7).
ASSIGN ipassword = entry(weekday(today),daylist).

MESSAGE "Todays password is " + ipassword + " " + string(icheck) view-as alert-box.


/* TO activate ZFSTART add -mdf to MoPro startup shortcut */
/* Log in using this password */
/*Logic:
* first letter = day of week
* space
* sum of (todays date x 2 + number of passed sundays in month * 7)

Monday 18/06/18 = M 57   (18*2 + 3*7 = 57) */

/* Sunday entry is manual until it can be auto calculated */
