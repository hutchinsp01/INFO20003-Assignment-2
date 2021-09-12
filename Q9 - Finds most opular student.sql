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