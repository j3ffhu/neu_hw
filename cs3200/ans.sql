
-- c
select hashtag.hashtag_id,    hashtag.tag, top_hashtag.total
FROM  hashtag
JOIN
     ( select  hashtag_id, count(tweet_id)  total   from hashtagtweet
     group by hashtag_id order by  count(tweet_id) desc ) as top_hashtag
on      hashtag.hashtag_id = top_hashtag.hashtag_id;

-- d
   select count(1) as cnt from (
              select tweet_id  from hashtagtweet group by tweet_id  having count(hashtag_id)  = 1
      )   as   single_hashtag_tweet  ;


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
