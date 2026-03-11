select 
subtotal,
tax,
discount,
total from "order" where id = '13131313-1313-1313-1313-131313131311';

--Funcion para validar el total de la orden
create function CheckTotal 
        (
          subtotal numeric, 
          tax numeric, 
          discount numeric, 
          total numeric
        )
--Devuele un boolean dependiendo si el total es correcto o no
returns boolean
--Lenguaje postgreSQL
language plpgsql


-- $$ indica el inicio y el final del bloque de código de la función
AS $$
begin
  if (subtotal + tax - discount = total) then
   return true;
  end if;

  return false;
  
end;
$$; 


--Uso de la funcion
select 
CheckTotal(subtotal, tax, discount, total)
 as total from "order" where id = '13131313-1313-1313-1313-131313131311';
