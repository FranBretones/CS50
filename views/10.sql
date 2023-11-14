SELECT english_title AS "Top3 Highest Entropy" FROM views
ORDER BY entropy DESC
LIMIT 3;
