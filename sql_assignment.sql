SELECT q.group_id, COUNT(*), MIN(q.id) as min_id
FROM (
       SELECT *,
              ROW_NUMBER() OVER (PARTITION BY group_id) AS rno,
              ROW_NUMBER() OVER (ORDER BY id) AS rne
       FROM users
     ) q
GROUP BY group_id, rne - rno
ORDER BY min_id;