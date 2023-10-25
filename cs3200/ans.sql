


-- e: What is the most liked tweet?
select * from tweet 
where tweet_id in (
   select tweet_id from (
              select tweet_id  from `like` group by tweet_id  order by count(user_id)  desc  LIMIT 1) 
   as   top_tweet  
) order by created desc;

-- f: home timeline.

select * from tweet 
where user_id in (
  select following_user_id from following where user_id = 1 
) order by created desc
