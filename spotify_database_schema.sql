--
-- File generated with SQLiteStudio v3.4.20 on Mon Nov 9 20:46:55 2026
--
-- Text encoding used: UTF-8
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: Album
CREATE TABLE IF NOT EXISTS Album (
    album_id  TEXT PRIMARY KEY,
    title     TEXT NOT NULL,
    artist_id TEXT,
    FOREIGN KEY (
        artist_id
    )
    REFERENCES Artist (artist_id) 
);


-- Table: Artist
CREATE TABLE IF NOT EXISTS Artist (
    artist_id TEXT PRIMARY KEY,
    name      TEXT
);


-- Table: RawTracks
CREATE TABLE IF NOT EXISTS RawTracks (
    id               TEXT,
    name             TEXT,
    album            TEXT,
    album_id         TEXT,
    artists          TEXT,
    artist_ids       TEXT,
    track_number     INTEGER,
    disc_number      INTEGER,
    explicit         INTEGER,
    danceability     REAL,
    energy           REAL,
    key              INTEGER,
    loudness         REAL,
    mode             INTEGER,
    speechiness      REAL,
    acousticness     REAL,
    instrumentalness REAL,
    liveness         REAL,
    valence          REAL,
    tempo            REAL,
    duration_ms      INTEGER,
    time_signature   INTEGER,
    year             INTEGER,
    release_date     TEXT
);


-- Table: Release_Info
CREATE TABLE IF NOT EXISTS Release_Info (
    album_id     TEXT    PRIMARY KEY,
    year         INTEGER,
    release_date TEXT,
    FOREIGN KEY (
        album_id
    )
    REFERENCES Album (album_id) 
);


-- Table: Song
CREATE TABLE IF NOT EXISTS Song (
    song_id          TEXT    PRIMARY KEY,
    title            TEXT    NOT NULL,
    artist_id        TEXT,
    album_id         TEXT,
    track_number     INTEGER,
    disc_number      INTEGER,
    explicit         INTEGER,
    danceability     REAL,
    energy           REAL,
    key              INTEGER,
    loudness         REAL,
    mode             INTEGER,
    speechiness      REAL,
    acousticness     REAL,
    instrumentalness REAL,
    liveness         REAL,
    valence          REAL,
    tempo            REAL,
    duration_ms      INTEGER,
    time_signature   INTEGER,
    year             INTEGER,
    release_date     TEXT,
    FOREIGN KEY (
        artist_id
    )
    REFERENCES Artist (artist_id),
    FOREIGN KEY (
        album_id
    )
    REFERENCES Album (album_id) 
);


-- Table: Track_Feature
CREATE TABLE IF NOT EXISTS Track_Feature (
    song_id          TEXT    PRIMARY KEY,
    danceability     REAL,
    energy           REAL,
    loudness         REAL,
    speechiness      REAL,
    acousticness     REAL,
    instrumentalness REAL,
    liveness         REAL,
    valence          REAL,
    tempo            REAL,
    duration_ms      INTEGER,
    time_signature   INTEGER,
    FOREIGN KEY (
        song_id
    )
    REFERENCES Song (song_id) 
);


-- Index: idx_feature_song
CREATE INDEX IF NOT EXISTS idx_feature_song ON Track_Feature (
    song_id
);


-- Index: idx_release_album
CREATE INDEX IF NOT EXISTS idx_release_album ON Release_Info (
    album_id
);


-- Index: idx_release_year
CREATE INDEX IF NOT EXISTS idx_release_year ON Release_Info (
    year
);


-- Index: idx_song_album
CREATE INDEX IF NOT EXISTS idx_song_album ON Song (
    album_id
);


-- Index: idx_song_artist
CREATE INDEX IF NOT EXISTS idx_song_artist ON Song (
    artist_id
);


-- View: Album_Summary
CREATE VIEW IF NOT EXISTS Album_Summary AS
    SELECT Album.title AS album_title,
           Artist.name AS artist_name,
           Release_Info.year,
           COUNT(Song.song_id) AS total_songs,
           SUM(Track_Feature.duration_ms) AS total_album_duration_ms,
           AVG(Track_Feature.energy) AS avg_energy,
           AVG(Track_Feature.danceability) AS avg_danceability,
           AVG(Track_Feature.valence) AS avg_valence
      FROM Album
           JOIN
           Artist ON Album.artist_id = Artist.artist_id
           JOIN
           Song ON Album.album_id = Song.album_id
           JOIN
           Track_Feature ON Song.song_id = Track_Feature.song_id
           JOIN
           Release_Info ON Album.album_id = Release_Info.album_id
     GROUP BY Album.album_id,
              Album.title,
              Artist.name,
              Release_Info.year;


-- View: Listener_Song_Browse
CREATE VIEW IF NOT EXISTS Listener_Song_Browse AS
    SELECT Song.title AS song_title,
           Artist.name AS artist_name,
           Album.title AS album_title,
           Track_Feature.duration_ms,
           Release_Info.year
      FROM Song
           JOIN
           Artist ON Song.artist_id = Artist.artist_id
           JOIN
           Album ON Song.album_id = Album.album_id
           JOIN
           Track_Feature ON Song.song_id = Track_Feature.song_id
           JOIN
           Release_Info ON Album.album_id = Release_Info.album_id;


-- View: Music_Analysis
CREATE VIEW IF NOT EXISTS Music_Analysis AS
    SELECT Song.title AS song_title,
           Artist.name AS artist_name,
           Album.title AS album_title,
           Track_Feature.danceability,
           Track_Feature.energy,
           Track_Feature.valence,
           Track_Feature.tempo,
           Track_Feature.acousticness,
           Track_Feature.instrumentalness
      FROM Song
           JOIN
           Artist ON Song.artist_id = Artist.artist_id
           JOIN
           Album ON Song.album_id = Album.album_id
           JOIN
           Track_Feature ON Song.song_id = Track_Feature.song_id;


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
