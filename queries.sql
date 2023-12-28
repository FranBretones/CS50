
-- Insert information about new users

INSERT INTO users ("username", "password", "email","created_at")
VALUES  ('Jhonylabios', 'sdafl%&156', 'jlabios@gmail.com', CURRENT_TIMESTAMP),
        ('MariaLopez', 'dsfg4321#$', 'maria.lopez@hotmail', CURRENT_TIMESTAMP),
        ('JohnDoe', 'asdfghjkl7890', 'john.doe@yahoo.es', CURRENT_TIMESTAMP),
        ('AnaGarcia', 'qwertyuiop12345', 'anagarcía@telefonica.es', CURRENT_TIMESTAMP),
        ('JoseMartinez', 'zxcvbnm,./67890', 'josemartinez@movistar.es', CURRENT_TIMESTAMP);

INSERT INTO users ("username", "password", "email","created_at")
VALUES  ('NicolásCano','nicanico123','nicocano@msn.com',CURRENT_TIMESTAMP),
        ('CarlosRodriguez','carlitos123','rodriguezzz@hotmail.com',CURRENT_TIMESTAMP),
        ('MaríaSánchez', 'pepito123' ,'mariasanchez@outlook.com',CURRENT_TIMESTAMP),
        ('AlbertoHernandez','albertohdez123','alberthdz@gmail.com',CURRENT_TIMESTAMP);


-- Insert interest on "users_interest" table

INSERT INTO users_interest (user_id, interest)
VALUEs  (1, 'Hiking'),
        (1, 'Climbing'),
        (1, 'Painting'),
        (2, 'Reading'),
        (2, 'Travel'),
        (2, 'Music'),
        (2, 'Urbex'),
        (3, 'Writting'),
        (3, 'Painting'),
        (3, 'Skating'),
        (3, 'Music'),
        (4, 'Painting'),
        (4, 'Travel'),
        (4, 'Music'),
        (5, 'Coding'),
        (5, 'Writting'),
        (5, 'Photography'),
        (5, 'Art'),
        (6, 'Urbex'),
        (6, 'Skating'),
        (6, 'Hiking'),
        (7, 'Climbing'),
        (7, 'Writting'),
        (7, 'Urbex'),
        (8, 'Skating'),
        (8, 'Science'),
        (8, 'Coding'),
        (9,'Music'),
        (9, 'Art'),
        (9, 'Photography');

INSERT INTO users_interest (user_id, interest)
VALUES  (2,'Art'),
        (3, 'Design'),
        (2, 'Fashion');



-- Insert information about groups

INSERT INTO groups ("groupname","description","creator_id", "interest", "created_at")
VALUES  ('CodingClub', 'Club for coding lovers', 5, 'coding',CURRENT_TIMESTAMP),
        ( 'HIkeLovers', 'A Club for adventure people', 1,'Hiking',CURRENT_TIMESTAMP),
        ('CityExplorers','Club of people who love to travel and discover new places', 3 ,'Urbex', CURRENT_TIMESTAMP),
        ( 'MusicFans', 'The music lovers club', 2 ,'Music', CURRENT_TIMESTAMP);

INSERT INTO groups ("groupname","description","creator_id", "interest", "created_at")
VALUES  ('Art for All', 'Club for all art disciplines', 9, 'Art', CURRENT_TIMESTAMP),
        ('OutdoorAdventures', 'Group to make outdoor activities together', 6, 'Climbing', CURRENT_TIMESTAMP);

-- Insert the information about relationship between users and groups.

INSERT INTO user_groups("user_id", "group_id")
VALUES  (5,1),
        (1,2),
        (2,3),
        (3,4),
        (4,3);


-- Insert information about parties.

INSERT INTO parties ("title","start_date", "end_date", "location", "group_id", "creator_id")
VALUES  ('72hCodeHouse','2021-09-01','2021-09-02', 'Madrid', 1, 5),
        ('SummerMusicParty','2021-08-15','2021-08-17', 'Barcelona', 2, 2),
        ('ChristmasHikerDinner','2021-12-25','2021-12-26', 'Sevilla', 3, 1);

INSERT INTO parties ("title","start_date", "end_date", "location", "group_id", "creator_id")
VALUES ('Urbex Madrid 24H', '2022-11-22','2022-11-23','Madrid', 3, 4);

-- Insert the information about relationship between users and parties.

INSERT INTO user_party ("user_id","party_id","status")
VALUES  (5, 1, 'accepted'),
        (3, 2, 'pending'),
        (1, 3, 'accepted'),
        (2, 1, 'rejected');

-- Insert new comments

INSERT INTO comments ("text", "rating", "created_at", "author_id","party_id")
VALUES  ('An exhilarating coding extravaganza at 72hCodeHouse, where innovation meets collaboration in a non-stop programming marathon!', 4, "2021-09-04", 5, 1),
        ('Get ready to dance under the stars at SummerMusicParty, where the beats are as hot as the weather, and music is the ultimate language of celebration!',5, '2021-08-19', 2 ,2),
        ('Embrace the spirit of adventure and festive flavors at ChristmasHikerDinner, where hiking meets holiday cheer in a unique al fresco dining experience', 3,'2021-12-28',1 ,3),
        ('Amazing secret places at Madrid', 5, '2022-11-24', 4, 4);

INSERT INTO comments ("text", "rating", "created_at", "author_id","party_id")
VALUES ("non stop coding time", 5, "2021-09-04",8 ,1 ),
("Great party with great food!", 5, "2021-09-04", 5, 1);

-- Insert new match

INSERT INTO user_matches ("user1_id", "user2_id", "match_score", "created_at")
VALUES (1, 3, 85, CURRENT_TIMESTAMP);

INSERT INTO user_matches ("user1_id", "user2_id", "match_score", "created_at")
VALUES (3, 2, 75, CURRENT_TIMESTAMP);

INSERT INTO user_matches ("user1_id", "user2_id", "match_score", "created_at")
VALUES (4, 2,100, CURRENT_TIMESTAMP);

-- Change name column on "user_matches" table and set new column as "integer" value
--1) rename original table.

ALTER TABLE user_matches
RENAME TO "tmp_user_matches";

--2) create a new table with the name of old table and the column changed
CREATE TABLE user_matches (
    "id" INTEGER NOT NULL,
    "user1_id" INTEGER NOT NULL,
    "user2_id" INTEGER NOT NULL,
    "match_score" INTEGER NOT NULL,
    "created_at" DATETIME DEFAUL CURRENT_TIMESTAMP,
    PRIMARY KEY("id"),
    FOREIGN KEY(user1_id) REFERENCES users(id),
    FOREIGN KEY(user2_id) REFERENCES users(id)
    );
--3) insert the data form "tmp_user_matches" to new "user_matches" table

INSERT INTO user_matches
SELECT * FROM tmp_user_matches;

--4) Drop "tmp_user_matches"

DROP TABLE tmp_user_matches;

-- Updating the data from column "match score" on user_matches" table.

UPDATE user_matches SET match_score = 75 WHERE id = 1;
UPDATE user_matches SET match_score = 80 WHERE id = 2;
UPDATE user_matches SET match_score = 100 WHERE id = 3;

-- Query to show the information of all user's

SELECT * FROM users;

-- Using SubQuery to indentifies user's id and username that attends one party.
-- example : who attends the party "ChristmasHikerDinner"

SELECT id, username FROM users
WHERE "id" = (
        SELECT party_id
        FROM user_party
        wHERE "user_id" = (
                SELECT id FROM parties
                WHERE "title" = 'ChristmasHikerDinner'
                )
        );

-- Using Joins to find groups a users has joins.
-- Example: Find who join to group "CodingClub"

SELECT users.username, groups.groupname
FROM users
JOIN user_groups ON users.id = user_groups.user_id
JOIN groups ON user_groups.group_id = groups.id
WHERE users.id =(
        SELECT user_id FROM user_groups
        WHERE "group_id" = (
                SELECT id FROM groups
                WHERE "groupname" ='CodingClub'));

-- Using Joins to find who attend to the party.
-- Example: Find who attend  party '72HCodeHouse'

SELECT users.id, users.username, parties.title
FROM users
JOIN user_party ON users.id = user_party.user_id
JOIN parties ON user_party.party_id = parties.id
WHERE party_id = (
        SELECT id FROM parties WHERE title='72hCodeHouse');



-- Showing how many people have same interest as user with ID=4

SELECT COUNT(*) AS "NumberOfUsersWithSameInterest"
FROM users_interest
WHERE interest IN (
        SELECT interest FROM users_interest WHERE user_id = 4);

--Showing which interests does user, searching by name.

SELECT users_interest.interest
FROM users
JOIN users_interest ON users.id = users_interest.user_id
WHERE users.id = (SELECT id FROM users
                WHERE username = 'AlbertoHernandez');

-- Showing which user TOP 3 has most of interest.

SELECT u.username, ui.user_id, COUNT(*) AS NumberofInterests
FROM users_interest ui
JOIN users u ON ui.user_id = u.id
GROUP BY ui.user_id
ORDER BY NumberofInterests DESC
LIMIT 3;

-- Create a view for the user comments and see how many comment has put each.

CREATE VIEW user_comments_count AS
SELECT u.username AS user_username, u.id AS user_id, COUNT(c.id) AS comment_count
FROM users u
LEFT JOIN comments c ON u.id = c.author_id
GROUP BY u.id
ORDER BY comment_count DESC;

        -- USING VIEW
        SELECT * FROM user_comments_count;

-- Trigger to validate the start and end date of an event

CREATE TRIGGER validate_party_dates
BEFORE UPDATE ON parties
FOR EACH ROW
WHEN NEW.start_date > NEW.end_date
BEGIN
    SELECT RAISE(ABORT, 'Start date must be before end date');
END;
