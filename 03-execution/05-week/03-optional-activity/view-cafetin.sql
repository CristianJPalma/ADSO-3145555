
create view vista_users AS
select u.username as usuario, r.name as rol, m.name as modulo, v.name as vista
from user_role ur
join "user" u on ur.user_id = u.id
join role r on ur.role_id = r.id
join role_module rm on r.id = rm.role_id
join module m on rm.module_id = m.id
join module_view mv on m.id = mv.module_id
join view v on mv.view_id = v.id;