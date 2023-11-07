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





-- 6. How many books of each genre where published after 1950?
-- Include genres that are not represented by any book in our catalog
-- as well as genres for which there are books but none published after 1950.
-- Sort output by number of titles in each genre (most to least)





-- 7. For each genre, compute a) the number of books borrowed and b) the average
-- number of days borrowed.
-- Includes books never borrowed and genres with no books
-- and in these cases, show zeros instead of null values.
-- Round the averages to one decimal point
-- Sort output in descending order by average
-- Helpful functions: ROUND, IFNULL, DATEDIFF





-- 8. List all pairs of books published within 10 years of each other
-- Don't include the book with itself
-- Only list (X,Y) pairs where X was published earlier
-- Output the two titles, and the years they were published, the number of years apart they were published
-- Order pairs from those published closest together to farthest




-- 9. Assuming books are returned completely read,
-- Rank the users from fastest to slowest readers (pages per day)
-- include users that borrowed no books (report reading rate as 0.0)




-- 10. How many books of each genre were checked out by John?
-- Sort descending by number of books checked out in each genre category.
-- Only include genres where at least two books of that genre were checked out.
-- (Count each time the book was checked out even if the same book was checked out
-- by John more than once.)





-- 11. On average how many books are borrowed per user?
-- Output two averages in one row: one average that includes users that
-- borrowed no books, and one average that excludes users that borrowed no books






-- 12. How much does each user owe the library. Include users owing nothing
-- Factor in the 10 cents per day fine for late returns and how much they have already paid the library
-- HINTS:
--     The DATEDIFF function takes two dates and counts the number of dates between them
--     The IF function, used in a SELECT clause, might also be helpful.  IF(condition, result_if_true, result_if_false)
--     IF functions can be used inside aggregation functions!





-- 13. (4 points) Which books will change your life?
-- Answer: All books.
-- Select all books.
