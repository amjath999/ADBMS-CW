
set serveroutput on;
declare
  num number:=0;
begin

case
when num>0 then 
dbms_output.put_line(num ||' is a positive number');
when num = 0 then 
dbms_output.put_line(num ||' is a zero number');

else
dbms_output.put_line(num ||' invalid number');
end case;
end;
