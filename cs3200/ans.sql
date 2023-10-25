
-- a) Which user has the most followers? Output just the user_id of that user, and the number of followers.
 select user_id , count(follower_user_id) as follower_count  from follower 
 group by user_id  order by count(user_id)  desc limit 1 ;


-- b For one user, list the five most recent tweets by that user, from newest to oldest. Include only tweets
-- containing the hashtag “#NEU”
select * from tweet
where user_id = 1
and content like '%#NEU%'
order by created desc;

-- c
select hashtag.hashtag_id,   
	  hashtag.tag ,
          (  select   count(tweet_id)  total   from hashtagtweet
           WHERE hashtagtweet.hashtag_id = hashtag.hashtag_id
     group by hashtag_id  ) as top_hashtag
FROM  hashtag ;

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
