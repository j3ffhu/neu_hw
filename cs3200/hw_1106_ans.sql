 -- HW4: Books that will change your life
-- Instructions: Run the script "hw4_library_setup.sql" in a ROOT connection
-- This will create a new schema called "library"
-- Write a query that answers each question below.
-- Save this file as HW4_YourFullName.sql and submit

-- Questions 1-12 are 8 points each. Question 13 is worth 4 points.


use library;



-- 1. Which book(s) are Science Fiction books written in the 1960's?
-- List title, author, and year of publication

select * from book
where genre_id = 4
 and year between 1960 and 1969;

select * from genre;



-- 2. Which users have borrowed no books?
-- Give name and city they live in
-- Write the query in two ways, once by selecting from only one table
-- and using a subquery, and again by joining two tables together.


-- Method using subquery (4 points)
select user_name, city from user 
where user_id not in (
       select user_id from borrow 
       ) ;


-- Method using a join (4 points)
select user_name, city 
 from user left join borrow
on  user.user_id  = borrow.user_id
where borrow.user_id is null ;


 

-- 3. How many books were borrowed by each user in each month?
-- Your table should have three columns: user_name, month, num_borrowed
-- You may ignore users that didn't borrow any books and months in which no books were borrowed.
-- Sort by name, then month
-- The month(date) function returns the month number (1,2,3,...12) of a given date. This is adequate for output.


   select user_name,   month(borrow_dt) month  , count(1) num_borrowed
    from borrow b, user u 
    where b.user_id = u.user_id
   group by user_name, month(borrow_dt)
   order by 1, 2;


-- 4. How many times was each book checked out?
-- Output the book's title, genre name, and the number of times it was checked out, and whether the book is still in circulation
-- Include books never borrowed
-- Order from most borrowed to least borrowed

   select b.title,  b.in_circulation , g.genre_name, 
         sum( CASE
		    	WHEN brw.book_id is null THEN  0
			    ELSE  1
		      END ) num_borrowed 
    from  book b left join borrow brw 
    on   b.book_id =  brw.book_id 
    join genre g
    on b.genre_id = g.genre_id
    group by b.book_id 
    order by 4 desc;
 
 

-- 5. How many times did each user return a book late?
-- Include users that never returned a book late or never even borrowed a book
-- Sort by most number of late returns to least number of late returns (regardless of HOW late the returns were.)

    select u.user_name ,
         sum( CASE
		    	WHEN brw.due_dt < brw.return_dt THEN  1
			    ELSE  0
		      END ) num_late_return 
    from  user u left join borrow brw 
    on u.user_id = brw.user_id
    group by u.user_id
    order by 2 desc;

 

-- 6. How many books of each genre where published after 1950?
-- Include genres that are not represented by any book in our catalog
-- as well as genres for which there are books but none published after 1950.
-- Sort output by number of titles in each genre (most to least)

   select g.genre_id ,  sum( CASE
		    	WHEN b.book_id is null THEN  0
			    ELSE  1
		      END ) num_books
    from  genre g left join book b
    on  b.genre_id = g.genre_id 
    where b.year >= 1950 or b.genre_id is null
    group by g.genre_id
    order by 2 desc;
 



-- 7. For each genre, compute a) the number of books borrowed and b) the average
-- Includes books never borrowed and genres with no books
-- and in these cases, show zeros instead of null values.
-- Round the averages to one decimal point
-- Sort output in descending order by average
-- Helpful functions: ROUND, IFNULL, DATEDIFF

 
select  g.genre_id , count(  distinct b.book_id ) num_books ,
          case
           WHEN count(  distinct b.book_id )   = 0 then 0 
           WHEN count(  distinct brw.borrow_dt )   = 0 then 0 
           else   ROUND (sum(  DATEDIFF(  brw.return_dt, brw.borrow_dt  ) )/ count(    brw.book_id )  )
           end  average_borrowed_days
    from  genre g  left join book b
    on  b.genre_id = g.genre_id 
      left    join borrow brw
    on b.book_id = brw.book_id  
    group by g.genre_id
    order by 3 desc;
  

-- 8. List all pairs of books published within 10 years of each other
-- Don't include the book with itself
-- Only list (X,Y) pairs where X was published earlier
-- Output the two titles, and the years they were published, the number of years apart they were published
-- Order pairs from those published closest together to farthest

select bfirst.title, b.title, b.year - bfirst.year  as apart  
from  book bfirst , book b
where bfirst.year <  b.year -10 
order by 3 asc



-- 9. Assuming books are returned completely read,
-- Rank the users from fastest to slowest readers (pages per day)
-- include users that borrowed no books (report reading rate as 0.0)

   select u.user_id,  IFNULL(  ROUND(sum(b.pages) / sum( DATEDIFF(  brw.return_dt, brw.borrow_dt  ) ), 1)   , 0.0 )   page_per_day   
    from  user u left join borrow  brw
    on  u.user_id = brw.user_id 
    left join book b
    on brw.book_id  = b.book_id 
    group by u.user_id
    order by 2 desc;
 


-- 10. How many books of each genre were checked out by John?
-- Sort descending by number of books checked out in each genre category.
-- Only include genres where at least two books of that genre were checked out.
-- (Count each time the book was checked out even if the same book was checked out
-- by John more than once.)

 




-- 11. On average how many books are borrowed per user?
-- Output two averages in one row: one average that includes users that
-- borrowed no books, and one average that excludes users that borrowed no books

 
    
       select ROUND ( count(  brw.book_id)  /    count(  distinct u.user_id  ) , 1)  include_avg,    ROUND (  count(  brw.book_id)  /  count(  distinct brw.user_id  ), 1)     exclude_avg
    from  user u left join borrow  brw
    on  u.user_id = brw.user_id ;



 
 
-- 12. How much does each user owe the library. Include users owing nothing
-- Factor in the 10 cents per day fine for late returns and how much they have already paid the library
-- HINTS:
--     The DATEDIFF function takes two dates and counts the number of dates between them
--     The IF function, used in a SELECT clause, might also be helpful.  IF(condition, result_if_true, result_if_false)
--     IF functions can be used inside aggregation functions!

 
           
    select    u.user_id,  sum(  IF(brw.return_dt > brw.due_dt, DATEDIFF(  brw.return_dt, brw.borrow_dt  )*0.1,  0     ) ) fine         
    from  user  u left   join borrow brw
    on  u.user_id = brw.user_id 
    group by u.user_id 
    order by 2 desc ;
       
 

-- 13. (4 points) Which books will change your life?
-- Answer: All books.
-- Select all books.

select * from book;
