PROPATH = "C:\temp," + PROPATH + ",C:\Program Files (x86)\Markinson\MomentumPro Client\prg".
RUN comobj/StartSuper.p ('comobj/propertyMan.p', SESSION).
RUN comobj/StartSuper.p ('comobj/admService.p', SESSION).
DYNAMIC-FUNCTION('setSessionProperty', 'Username', "support").

RUN svrutl/zcgo.w
         
