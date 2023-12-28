# Meet People Data Base
By Francisco José Bretones López

Video overview: <https://youtu.be/N1yTOF-Avuk>

## Scope

* This project is focused on creating a database for the "MeetPeople" app.
* Which allows users to connect with other people who share similar interests.
* They can make groups with the same interest, orginize parties for meet each other.

## Schema and Entities

### User's Table

- `id` : Integer. Unique. Indentifies each user. (Primary key)
- `username` : Text. Unique.Not null. Indentifies user name.
- `email` : Text. Not null. User's email address.
- `password` : Text. Hashed password for authentication purposes.
- `created_at` : Timestamp of user creation.

### Users_Interest Table
This table links between users and their shared interests.
 - `user_id` :Integer. Unique. Indentifies each user. (Primary key)
 - `interest` : Indentifies interest of each user.

 - Foreing Key:

    - `user_id` references `User.id`.


### Groups Table

- `id`: Integer. Unique identifier for groups. (Primary key)
- `groupname`: Text. Name of group.
- `description`: Text. Description of group.
- `creator_id` : Integer. Indentifies each user that created the group(Foreing Key references `users(id)` on users table.)
- `created_at` : Timestamp of group creation.

- In this table also have two "CHECK":
    - To allow empty `description` but not null.
    - only alphanumeric characters allowed in `groupnames`.

- Foreing keys:
    - `creator_id` references `users(id)` on users table.

### User_Groups Relation Table

- This is a many-to-many relationship between Users and Groups tables.
- It allows to assign multiple users to one group and vice versa.
- It allows us to know which users belong to which groups.

- `user_id`: Integer. Not null. References the user who joined the group.
- `group_id`: Integer. Not null. References the group that the user joined.

- Foreing keys:

    - `user_id` references `id` on `users` table.
    - `group_id` references `id` on `groups` table.

### Parties Table

- `id`: Integer. Unique. identify party. (Primary Key)
- `title` : Text. Name of party.
- `start_date`  : Date. Start Date of party.
- `end_date` : Date. End date of party.
- `location` : Text. Location of party.
- `group_id` : Integer. Not null. References the group associated with the party.(Foreign Key referencing `groups(id)`.)
- `creator_id` : Integer. Not null. User creator of party (Foreign Key referencing `users(id)`.)

- In this table also have one "CHECK", `Start_date` must be before `end_date`.

### User_Party Relation Table.

- The purpose of this table is to represent a many-to-many relation between Users and Parties.
- This way we can keep track of all the parties each user has attended or will attend.

- `party_id` : Integer. Not null. References the user who is attending the party, Not null.
- `user_id` : Integer. Not null. References the event that the user is attending, Not null.
- `status`: Text. Not null. Reference if the party is acepted, rejected or panding aprove. (Check: only alows text pending,acepted or rejected), also it can't be null

- Foreing Keys:
   - `party_id` References `parties(id)`.
   - `user_id` references `users(id)`.

### Users_matches Relation Table

- This table represents the matches between two users.
- If there are no entries for a given pair then it means they haven't been matched yet.
- This is a many-to-many relationship between two users.

- `id` : Integer. Not null. Identifies each match. (Primary key)
- `user1_id`, `user2_id`: Integer. Not null.  Represents the two users involved in the match. They should always be different, both can't be null.
- `created_at`:Timestamp of match creation.
- `match_score`: Integer. The score of the match based on interest.
- Foreing Keys:
    - Both `user1_id` & `user2_id` reference `users(id)`.

### Comments Table
- A simple comment section where users can post comments about parties.

- `id`: Integer. Not null. Identifies each party. (Primary key)
- `text`: Text. Not null. Content of the comment.
- `rating` : Integer. Only values between 0 and 5.
- `created_at`: Timestamp of content creation.
- `author_id`: Integer. Not null. Author of the comment.
- `party_id` : Integer. Not null. Make reference to the party that users attended.

- Foreing Key:
    - `author_id` referencing `users(id)`
    - `party_id` referencing `parties(id)`


### Relationships

Below is an ER Diagram for MeetPeople database

![Imgur](https://i.imgur.com/61UzxRp.png)



## Optimizations

- Indexes for improve performance of searchs:

* For `users` and `groups`:
```sql
   CREATE INDEX user_groups_user_id_index ON users("id");
   CREATE INDEX user_groups_group_id_index ON groups("id");
```

 * On `parties` table:

```sql
    CREATE INDEX user_party_user_idx ON users("id");
    CREATE INDEX user_party_parties_idx ON parties("id");
```

 * On `comments` table:

```sql
 CREATE INDEX "user_match1_idx" ON user_matches("user1_id");
CREATE INDEX "user_match2_idx" ON user_matches("user2_id");
```

- TRIGGERS:
    * `validate_party_dates`:
 ```sql
CREATE TRIGGER validate_party_dates
BEFORE UPDATE ON parties
FOR EACH ROW
WHEN NEW.start_date > NEW.end_date
BEGIN
    SELECT RAISE(ABORT, 'Start date must be before end date');
END;
```

 - This trigger is designed to ensure data integrity within the parties table by validating the relationship
    between the start and end dates of an event before an update operation.
    The primary purpose of this trigger is to prevent updates that would result in an event having a start date later than its end date. Such a condition would violate the logical consistency of the data.

    - Trigger Logic
        - Event Trigger: The trigger is set to execute BEFORE UPDATE operations on the parties table.

    - Condition Check: For each row being updated, the trigger checks if the new start date (NEW.start_date)
        is greater than the new end date (NEW.end_date).

    - Error Handling: If the condition is met (i.e., the start date is later than the end date), the trigger raises an error using RAISE(ABORT, 'Start date must be before end date').

    - Usage: To use this trigger effectively, ensure the following:
        · When updating an event in the parties table, the start date must always be earlier than or equal to the end date.
    - Example: -- Attempting to update an event with an invalid date range will trigger an error



- VIEWS:

    - `user_comments_count`: Show the number of comment for each user.
        The purpose of this view is to simplify the retrieval of information regarding the number of comments made by each user. It provides a convenient way to analyze and understand user comment activity.

```sql
CREATE VIEW user_comments_count AS
SELECT u.username AS user_username, u.id AS user_id, COUNT(c.id) AS comment_count
FROM users u
LEFT JOIN comments c ON u.id = c.author_id
GROUP BY u.id
ORDER BY comment_count DESC;
```


## Limitations

- While the database desing is generally well-structured and suitable for representing various aspects of the social platform "Meet People", there are certain scenarios and requirements for which it might not be the most optimal choice.
- Here are same of these limitations:

    * Limited `users` Interaction Tracking: The current desing captures users interactions through comments and parties attendance. If we needed more granular tracking it's possible that i would be necesary additional tables.

    * Limited `groups` Functionality: if we want to support more advanced funcionalities (e.g., file sharing) we might to expand the schema.

    * Limited `comments` Details : it would be necessary expand the schema if we want more datails about `comments`.

