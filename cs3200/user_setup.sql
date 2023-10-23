INSERT INTO `mydb`.`user`
(
`login`,
`password`,
`type`,
`fullName`,
`profile`,
`hidden`,
`created`)
VALUES(
'Northeastern',
'4395e1925262339053c4c636d8430897',
'orgnization',
'Northeastern U.',
'Northeastern is a global, experiential, research university built on a tradition of engagement with the world. #LikeAHusky',
0,
'2011-04-03 14:00:45');


INSERT INTO `mydb`.`user`
(
`login`,
`password`,
`type`,
`fullName`,
`profile`,
`hidden`,
`created`)
VALUES(
'elonmusk',
'd9729feb74992cc3482b350163a1a010',
'individual',
'Elon Musk',
'Telsa  X CEO',
0,
'2011-04-03 14:00:45');

INSERT INTO `mydb`.`user`
(
`login`,
`password`,
`type`,
`fullName`,
`profile`,
`hidden`,
`created`)
VALUES(
'MichelleObama',
'504277bafd88ecd972e4550a63abf67c',
'individual',
'Michelle Obama',
'Girl from the South Side and former First Lady. Wife, mother, dog lover. Always hugger-in-chief. #TheLightWeCarry',
0,
'2011-07-03');

INSERT INTO `mydb`.`user`
(
`login`,
`password`,
`type`,
`fullName`,
`profile`,
`hidden`,
`created`)
VALUES(
'taylorswift13',
'7fb9511f94c51a916d0545efb151fb97',
'individual',
'Taylor Swift',
'I\'m the problem, it\'s me',
0,
'2011-07-03');

INSERT INTO `mydb`.`user`
(`login`,
`password`,
`type`,
`fullName`,
`profile`,
`hidden`,
`created`)
VALUES(
'KimDotcom',
'02e647024d6a9eb959bc99eeb3ca1c71',
'individual',
'Kim Dotcom',
'Entrepreneur, Innovator, Gamer, Artist, Internet Freedom Fighter & Father of 6',
0,
'2008-01-03');

-- following and follower
INSERT INTO `mydb`.`follower`
(`user_id`,
`follower_user_id`)
VALUES
(1, 2),
(1, 3),
(1, 4),
(2, 1),
(2, 3),
(2, 4)
;

INSERT INTO `mydb`.`following`
(`user_id`,
`following_user_id`)
VALUES
(1, 2),
(1, 3),
(1, 4),
(2, 1),
(2, 3),
(2, 4)
;
