

-- Users Table to store theirs profiles

CREATE TABLE users (
    "id" INTEGER,
    "username" TEXT NOT NULL UNIQUE,
    "password" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "created_at" DATETIME DEFAUL CURRENT_TIMESTAMP,
    PRIMARY KEY("id")
);

-- User Interest table

CREATE TABLE users_interest (
    "user_id" INTEGER,
    "interest" TEXT NOT NULL,
    PRIMARY KEY ("user_id", "interest"),
    FOREIGN KEY(user_id) REFERENCES users(id)
);
-- Groups Table for the interest

CREATE TABLE groups (
    "id" INTEGER,
    "groupname" TEXT NOT NULL UNIQUE,
    "description" TEXT,
    "creator_id" INTEGER NOT NULL,
    "interest" TEXT NOT NULL,
    "created_at" DATETIME DEFAUL CURRENT_TIMESTAMP,
    PRIMARY KEY("id"),
    FOREIGN KEY(creator_id) REFERENCES users(id),
    CHECK ("description" IS NOT NULL OR "description" = '') -- To allow empty description but not null.
    CHECK ("groupname" GLOB '[a-zA-Z0-9]*') -- only alphanumeric characters allowed in group names
    );

-- Users Groups Table for the relations-- hip between "users" and "groups" as a relation "many-to-many"

CREATE TABLE user_groups (
    "user_id" INTEGER,
    "group_id" INTEGER,
    PRIMARY KEY ("user_id","group_id"),
    FOREIGN KEY("user_id") REFERENCES users("id"),
    FOREIGN KEY("group_id") REFERENCES groups("id"),
    -- Avoid adding same member twice to the same group
    CONSTRAINT "no_duplicate_members" UNIQUE ("user_id","group_id")
    );



        -- Indexes for improve performance of searchs

    CREATE INDEX user_groups_user_id_index ON users("id");
    CREATE INDEX user_groups_group_id_index ON groups("id");

-- Events Table for the information need to orginice the event

CREATE TABLE parties (
    "id" INTEGER,
    "title" TEXT NOT NULL,
    "start_date" DATE NOT NULL,
    "end_date" DATE NOT NULL,
    "location" TEXT,
    "group_id" INTEGER NOT NULL,
    "creator_id" INTEGER NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY(group_id) REFERENCES groups(id),
    FOREIGN KEY(creator_id) REFERENCES users(id),
    CHECK ("start_date" <= "end_date") -- Start date must be before end date
    );

-- User Event Table for the relationship between "users" and "events" as a relation "many-to-many".
    -- This table is used to know who are going to attend an event.

CREATE TABLE user_party (
    "user_id" INTEGER NOT NULL,
    "party_id" INTEGER NOT NULL,
    "status" TEXT NOT NULL CHECK ("status" IN ('pending','accepted','rejected')), -- only could be pending, accepted or rejected
    PRIMARY KEY("user_id","party_id"),
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(party_id) REFERENCES parties(id)
    );
        -- Indexes for improve performance of searchs

    CREATE INDEX user_party_user_idx ON users("id");
    CREATE INDEX user_party_parties_idx ON parties("id");

-- User matches Table to store all the user's matches

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
       -- Indexes for improve performance of searchs

    CREATE INDEX "user_match1_idx" ON user_matches("user1_id");
    CREATE INDEX "user_match2_idx" ON user_matches("user2_id");

--Event comment's table for store the rewiews from users

CREATE TABLE comments (
    "id" integer NOT NULL UNIQUE,
    "text" text NOT NULL,
    "rating" integer NOT NULL CHECK(rating BETWEEN 0 AND 5),
    "created_at" timestamp default current_timestamp,
    "author_id" integer,
    "party_id" integer,
    PRIMARY KEY("id"),
    FOREIGN KEY(author_id) references users(id),
    FOREIGN KEY(party_id) references parties(id)
    );

   -- Indexes for improve performance of searchs

    CREATE INDEX party_comments_parties_id_idx ON comments("party_id");
    CREATE INDEX party_comments_user_id_idx ON comments("user_id");

-- Create a view for the user comments and see how many comment has put each.

CREATE VIEW user_comments_count AS
SELECT u.username AS user_username, u.id AS user_id, COUNT(c.id) AS comment_count
FROM users u
LEFT JOIN comments c ON u.id = c.author_id
GROUP BY u.id
ORDER BY comment_count DESC;

-- Trigger to validate the start and end date of an event

CREATE TRIGGER validate_party_dates
BEFORE UPDATE ON parties
FOR EACH ROW
WHEN NEW.start_date > NEW.end_date
BEGIN
    SELECT RAISE(ABORT, 'Start date must be before end date');
END;
