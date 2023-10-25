INSERT INTO mydb.hashtag
( 
tag)
VALUES
( 
'#PEACE');

INSERT INTO mydb.hashtag
( 
tag)
VALUES
( 
'#LikeAHusky');

INSERT INTO mydb.hashtag
( 
tag)
VALUES
( 
'#Northeastern');



INSERT INTO mydb.tweet
( 
user_id,
content,
created)
VALUES
( 
1,
'Posting this to my main timeline so more people see it',
now());


INSERT INTO mydb.tweet
( 
user_id,
content,
created)
VALUES
( 
1,
'#PEACE',
now());


INSERT INTO mydb.tweet
( 
user_id,
content,
created)
VALUES
( 
11,
'125 years of #Northeastern.',
now());

INSERT INTO mydb.reply
(
tweet_id,
content,
created)
VALUES
(
2,
'AGREED #PEACE',
now());



INSERT INTO mydb.hashtagtweet
(hashtag_id,
tweet_id)
VALUES
(1,
 4);
 
 
 INSERT INTO mydb.hashtagtweet
(hashtag_id,
tweet_id)
VALUES
(4,
 9);
 
 INSERT INTO mydb.hashtagreply
(hashtag_id,
reply_id)
VALUES
(
1,
1);

