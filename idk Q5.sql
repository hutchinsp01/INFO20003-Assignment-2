SELECT likepost.post, COUNT(likepost.post) AS count
	FROM likepost
    RIGHT JOIN
    (SELECT COUNT(likepost.post) AS count
		FROM likepost
        GROUP BY likepost.post
        ORDER BY count DESC
        LIMIT 1) L
	ON L.count = count
    GROUP BY likepost.post
    
