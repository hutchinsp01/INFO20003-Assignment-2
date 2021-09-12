-- __/\\\\\\\\\\\__/\\\\\_____/\\\__/\\\\\\\\\\\\\\\_____/\\\\\_________/\\\\\\\\\_________/\\\\\\\________/\\\\\\\________/\\\\\\\________/\\\\\\\\\\________________/\\\\\\\\\_______/\\\\\\\\\_____        
--  _\/////\\\///__\/\\\\\\___\/\\\_\/\\\///////////____/\\\///\\\_____/\\\///////\\\_____/\\\/////\\\____/\\\/////\\\____/\\\/////\\\____/\\\///////\\\_____________/\\\\\\\\\\\\\___/\\\///////\\\___       
--   _____\/\\\_____\/\\\/\\\__\/\\\_\/\\\_____________/\\\/__\///\\\__\///______\//\\\___/\\\____\//\\\__/\\\____\//\\\__/\\\____\//\\\__\///______/\\\_____________/\\\/////////\\\_\///______\//\\\__      
--    _____\/\\\_____\/\\\//\\\_\/\\\_\/\\\\\\\\\\\____/\\\______\//\\\___________/\\\/___\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\_________/\\\//_____________\/\\\_______\/\\\___________/\\\/___     
--     _____\/\\\_____\/\\\\//\\\\/\\\_\/\\\///////____\/\\\_______\/\\\________/\\\//_____\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\________\////\\\____________\/\\\\\\\\\\\\\\\________/\\\//_____    
--      _____\/\\\_____\/\\\_\//\\\/\\\_\/\\\___________\//\\\______/\\\______/\\\//________\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\___________\//\\\___________\/\\\/////////\\\_____/\\\//________   
--       _____\/\\\_____\/\\\__\//\\\\\\_\/\\\____________\///\\\__/\\\______/\\\/___________\//\\\____/\\\__\//\\\____/\\\__\//\\\____/\\\___/\\\______/\\\____________\/\\\_______\/\\\___/\\\/___________  
--        __/\\\\\\\\\\\_\/\\\___\//\\\\\_\/\\\______________\///\\\\\/______/\\\\\\\\\\\\\\\__\///\\\\\\\/____\///\\\\\\\/____\///\\\\\\\/___\///\\\\\\\\\/_____________\/\\\_______\/\\\__/\\\\\\\\\\\\\\\_ 
--         _\///////////__\///_____\/////__\///_________________\/////_______\///////////////_____\///////________\///////________\///////_______\/////////_______________\///________\///__\///////////////__

-- Your Name: Paul Hutchins
-- Your Student Number: 1160468
-- By submitting, you declare that this work was completed entirely by yourself.

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q1

SELECT Id AS Lecturer_Id, topic, CreatedBy
FROM forum
WHERE CreatedBy = ClosedBy;

-- END Q1
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q2 

SELECT t1.Id, t1.name, t2.count
FROM
(SELECT lecturer.id, CONCAT(user.firstname, ' ', user.lastname) AS Name
FROM lecturer
JOIN user on lecturer.id = user.id) t1
LEFT JOIN
(Select forum.createdby, COUNT(*) AS Count
FROM forum
GROUP BY CreatedBy) t2
ON t2.createdby = t1.id

-- END Q2
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3

SELECT Id AS userID, Username
FROM user
WHERE user.ID NOT IN (Select PostedBy FROM post WHERE forum IS NOT NULL)

-- END Q3
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q4 Doesnt find no comments

SELECT post.id
FROM post
WHERE post.parentpost IS NULL
AND post.id NOT IN (SELECT likepost.post FROM likepost)

-- END Q4
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q5 

SELECT t1.post, t1.content, t1.count
FROM
(SELECT likepost.post, post.content, COUNT(likepost.post) AS count
	FROM likepost
    JOIN post ON likepost.post = post.Id
	GROUP BY likepost.post) t1
    JOIN
    (SELECT likepost.post, COUNT(likepost.post) as count
        FROM likepost
        GROUP BY likepost.post
        ORDER BY count DESC
        LIMIT 1) t2
	ON t1.post = t2.post

-- END Q5
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q6 

SELECT t1.length, t1.content, t1.topic, t1.Name
FROM
	(SELECT Char_length(post.content) as Length, post.content, forum.topic, CONCAT (user.Firstname, ' ', user.Lastname) as Name 
	FROM post
	JOIN forum ON post.forum = forum.id
	JOIN user on post.PostedBy = user.Id) t1
    JOIN
    (SELECT Char_length(post.content) as length, post.content
	FROM post
    ORDER BY length DESC
    LIMIT 1) t2
    ON t1.content = t2.content

-- END Q6
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q7 

SELECT t1.student1, t1.student2, t1.friendtime * -1 AS FriendshipDays
FROM
	(SELECT student1, student2, datediff(friendof.whenconfirmed, friendof.whenunfriended) AS FriendTime
	FROM friendof
	ORDER BY FriendTime DESC) t1
    JOIN
    (SELECT student1, student2, datediff(friendof.whenconfirmed, friendof.whenunfriended) AS FriendTime
		FROM friendof
        ORDER BY FriendTime DESC
        LIMIT 1) t2
	ON t1.FriendTime = t2.FriendTime

-- END Q7
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q8

SELECT t2.user, t1.count, t1.post FROM
(SELECT likepost.post, (COUNT(likepost.user) - 1) AS Count
FROM likepost
GROUP BY likepost.post) t1
JOIN
(SELECT likepost.user, likepost.post
FROM likepost) t2
ON t1.post = t2.post

-- END Q8
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q9

SELECT friend2 AS userID
FROM
	(SELECT t3.postedby AS MostPop, count(t3.postedby) AS likes
		FROM
		(SELECT t2.postedby 
			FROM
			(SELECT likepost.post
				FROM likepost) t1
			JOIN
				(SELECT post.ID, post.postedby
					FROM post
				INNER JOIN
				(SELECT user.id
					FROM user
					WHERE user.usertype = 's') students
				ON students.id = post.postedby) t2
			ON t1.post = t2.Id) t3
	    GROUP BY t3.postedby
        ORDER BY likes DESC
        LIMIT 1) Mostpop
JOIN
	(SELECT degree1.id AS friend1, degree2.id AS friend2
	    FROM
	    (SELECT friendof.student1, friendof.student2
	        FROM friendof
	        WHERE friendof.whenconfirmed IS NOT NULL
	        AND friendof.whenunfriended IS NULL 
	    UNION ALL
	        SELECT friendof.student2, friendof.student1
	        FROM friendof
	        WHERE friendof.whenconfirmed IS NOT NULL
	        AND friendof.whenunfriended IS NULL) friends
	    JOIN 
	        (SELECT student.Id, student.degree AS degree1
	        FROM student) degree1
	        ON degree1.id = friends.student1
	    JOIN
	        (SELECT student.Id, student.degree AS degree2
	        FROM student) degree2
	        ON degree2.id = friends.student2
	        WHERE degree1 = degree2) degfriends
            ON mostpop = friend1

-- END Q9
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q10

SELECT t3.id, t3.posttime
FROM
(SELECT t1.id, t1.createdby, t2.postedby AS reply, t1.whenposted AS posttime, t2.whenposted AS replytime
FROM
(SELECT post.id, forum.createdby, post.whenposted
FROM post
JOIN forum
ON post.forum = forum.id
WHERE post.parentpost IS NULL
AND post.postedby NOT IN
	(SELECT lecturer.id
    FROM lecturer)) t1
LEFT JOIN
(SELECT post.parentpost, post.postedby, post.whenposted
FROM post) t2
ON t1.id = t2.parentpost) t3
WHERE createdby != reply
OR (replytime - posttime) >= 48


-- END Q10
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- END OF ASSIGNMENT Do not write below this line