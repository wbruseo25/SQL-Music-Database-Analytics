-- Spotify Music Database & Analytics
-- 12 analytical queries | SQLite
-- Source: collaborative Spotify database project


-- Query 1: List all the songs in the dataset of the top 100 artists along with their length 
-- and albums

SELECT
    s.title AS song_title,
    ar.name AS artist_name,
    al.title AS album_title,
    tf.duration_ms
FROM Song s
JOIN Artist ar ON s.artist_id = ar.artist_id
JOIN Album al ON s.album_id = al.album_id
JOIN Track_Feature tf ON s.song_id = tf.song_id
WHERE ar.artist_id IN (
    SELECT s2.artist_id
    FROM Song s2
    GROUP BY s2.artist_id
    ORDER BY COUNT(*) DESC
    LIMIT 100
)
LIMIT 50;


-- Query 2: Find the total number of songs that is associated with each artist, excluding the "various artists" found in the dataset

SELECT
    ar.name AS artist_name,
    COUNT(s.song_id) AS total_songs
FROM Artist ar
JOIN Song s ON ar.artist_id = s.artist_id
WHERE ar.name != 'Various Artists'
GROUP BY ar.artist_id, ar.name
ORDER BY total_songs DESC
LIMIT 50;


-- Query 3: Find the total number of songs that each album contains

-- The dataset contains multi-valued artist attributes stored as comma-separated values,
-- which were not fully decomposed into separate relations due to complexity.

SELECT
    al.title AS album_title,
    ar.name AS artist_name,
    COUNT(s.song_id) AS total_songs
FROM Album al
JOIN Artist ar ON al.artist_id = ar.artist_id
JOIN Song s ON al.album_id = s.album_id
WHERE ar.name != 'Various Artists'
GROUP BY al.album_id, al.title, ar.name
ORDER BY total_songs DESC
LIMIT 50;


-- Query 4: Find the total length of the album based off the length of each song in the albums

SELECT
    al.title AS album_title,
    ar.name AS artist_name,
    COUNT(s.song_id) AS total_songs,
    SUM(tf.duration_ms) AS total_album_duration_ms
FROM Album al
JOIN Artist ar ON al.artist_id = ar.artist_id
JOIN Song s ON al.album_id = s.album_id
JOIN Track_Feature tf ON s.song_id = tf.song_id
GROUP BY al.album_id, al.title, ar.name
ORDER BY total_album_duration_ms DESC
LIMIT 50;


-- Query 5: Find the average danceability and valence of songs released each year listed

SELECT
    ri.year,
    COUNT(s.song_id) AS total_songs,
    AVG(tf.danceability) AS avg_danceability,
    AVG(tf.valence) AS avg_valence
FROM Release_Info ri
JOIN Album al ON ri.album_id = al.album_id
JOIN Song s ON al.album_id = s.album_id
JOIN Track_Feature tf ON s.song_id = tf.song_id
GROUP BY ri.year
ORDER BY ri.year
LIMIT 50;


-- Query 6: Find the albums with the highest energy rating across the songs in them

SELECT
    al.title AS album_title,
    ar.name AS artist_name,
    COUNT(s.song_id) AS total_songs,
    AVG(tf.energy) AS avg_energy
FROM Album al
JOIN Artist ar ON al.artist_id = ar.artist_id
JOIN Song s ON al.album_id = s.album_id
JOIN Track_Feature tf ON s.song_id = tf.song_id
GROUP BY al.album_id, al.title, ar.name
HAVING COUNT(s.song_id) >= 5
ORDER BY avg_energy DESC
LIMIT 50;


-- Query 7:Find the artists who have the highest average danceability

SELECT
    ar.name AS artist_name,
    COUNT(s.song_id) AS total_songs,
    AVG(tf.danceability) AS avg_danceability
FROM Artist ar
JOIN Song s ON ar.artist_id = s.artist_id
JOIN Track_Feature tf ON s.song_id = tf.song_id
GROUP BY ar.artist_id, ar.name
HAVING COUNT(s.song_id) >= 10
ORDER BY avg_danceability DESC
LIMIT 50;


-- Query 8: List songs above a certain energy threshold that came out each year

SELECT
    ri.year,
    COUNT(s.song_id) AS high_energy_song_count,
    AVG(tf.energy) AS avg_energy
FROM Release_Info ri
JOIN Album al ON ri.album_id = al.album_id
JOIN Song s ON al.album_id = s.album_id
JOIN Track_Feature tf ON s.song_id = tf.song_id
WHERE tf.energy >= 0.85
GROUP BY ri.year
ORDER BY high_energy_song_count DESC
LIMIT 50;


-- Query 9: Find the average tempo of songs for each artist

SELECT
    ar.name AS artist_name,
    COUNT(s.song_id) AS total_songs,
    AVG(tf.tempo) AS avg_tempo
FROM Artist ar
JOIN Song s ON ar.artist_id = s.artist_id
JOIN Track_Feature tf ON s.song_id = tf.song_id
GROUP BY ar.artist_id, ar.name
HAVING COUNT(s.song_id) >= 10
ORDER BY avg_tempo DESC
LIMIT 50;


-- Query 10: Find the songs that have a high energy but low acousticness in their songs

SELECT
    s.title AS song_title,
    ar.name AS artist_name,
    al.title AS album_title,
    tf.energy,
    tf.acousticness
FROM Song s
JOIN Artist ar ON s.artist_id = ar.artist_id
JOIN Album al ON s.album_id = al.album_id
JOIN Track_Feature tf ON s.song_id = tf.song_id
WHERE tf.energy >= 0.85
  AND tf.acousticness <= 0.10
ORDER BY tf.energy DESC
LIMIT 50;


-- Query 11: Find the artists whose songs span the greatest number of albums

SELECT
    ar.name AS artist_name,
    COUNT(DISTINCT al.album_id) AS total_albums,
    COUNT(s.song_id) AS total_songs
FROM Artist ar
JOIN Song s ON ar.artist_id = s.artist_id
JOIN Album al ON s.album_id = al.album_id
GROUP BY ar.artist_id, ar.name
ORDER BY total_albums DESC
LIMIT 50;


-- Query 12: Find the songs who have the widest range of energy values

SELECT
    ar.name AS artist_name,
    COUNT(s.song_id) AS total_songs,
    MIN(tf.energy) AS min_energy,
    MAX(tf.energy) AS max_energy,
    MAX(tf.energy) - MIN(tf.energy) AS energy_range
FROM Artist ar
JOIN Song s ON ar.artist_id = s.artist_id
JOIN Track_Feature tf ON s.song_id = tf.song_id
GROUP BY ar.artist_id, ar.name
HAVING COUNT(s.song_id) >= 10
ORDER BY energy_range DESC
LIMIT 50;
