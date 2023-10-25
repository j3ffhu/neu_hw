

INSERT INTO `mydb`.`like`
(`tweet_id`,
`user_id`)
VALUES 
(3, 1),
(4, 2),
(5, 3),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 5);


INSERT INTO `mydb`.`tweet`
( 
`user_id`,
`content`,
`created`)
VALUES
( 
4,
'What is the meaning of this Symbol?',
now());

INSERT INTO `mydb`.`tweet`
( 
`user_id`,
`content`,
`created`)
VALUES
( 
1,
'Love #NEU',
now());


INSERT INTO `mydb`.`tweet`
( 
`user_id`,
`content`,
`created`)
VALUES
( 
1,
'Fall coming to  #NEU',
now());

INSERT INTO `mydb`.`tweet`
( 
`user_id`,
`content`,
`created`)
VALUES
( 
5,
'It is a good day?',
now());



-- run this dozen time
-- try differnt id
INSERT INTO `mydb`.`tweet`
( 
`user_id`,
`content`,
`created`)
VALUES
( 
4,
'Fall coming to  #NEU',
now());


-- your db may have differnt pls check and replace 1 
SELECT * FROM mydb.hashtag;
INSERT INTO hashtagtweet (hashtag_id, tweet_id)
select 1,  tweet_id from tweet
where   content like '%#NEU%'
