
-- f

select * from tweet 
where user_id in (
  select following_user_id from following where user_id = 1 
) order by created desc
