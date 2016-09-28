DROP TABLE if EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR,
  lname VARCHAR
);

DROP TABLE if EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR,
  body TEXT,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES question_follows(user_id)
);

DROP TABLE if EXISTS question_follows;

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE if EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT,
  question_id INTEGER NOT NULL,
  reply_id INTEGER,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
  FOREIGN KEY (reply_id) REFERENCES replies(id)
);

DROP TABLE if EXISTS question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Micah', 'Sapitsky'),
  ('Louis', 'Cruz');

INSERT INTO
  questions(title, body, user_id)
VALUES
  ('WTF?', 'What the hell...', (SELECT id FROM users WHERE fname = 'Louis')),
  ('ROFL', 'SOMETHING', (SELECT id FROM users WHERE fname = 'Micah'));

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Micah'), (SELECT id FROM questions WHERE title = 'WTF?')),
  ((SELECT id FROM users WHERE fname = 'Micah'), (SELECT id FROM questions WHERE title = 'ROFL')),
  ((SELECT id FROM users WHERE fname = 'Louis'), (SELECT id FROM questions WHERE title = 'ROFL'));

INSERT INTO
  replies (body, question_id, reply_id, user_id)
VALUES (
  'IDK', (
    SELECT
      id
    FROM
      questions
    WHERE
      title = 'WTF?'
  ), NULL, (
    SELECT
      id
    FROM
      users
    WHERE
      fname = 'Micah'
  )
), (
  'lol', (
    SELECT
      id
    FROM
      questions
    WHERE
      title = 'WTF?'
  ), 1, (
    SELECT
      id
    FROM
      users
    WHERE
      fname = 'Louis'
  )
);

INSERT INTO
  question_likes(user_id, question_id)
VALUES
  ((
    SELECT
      id
    FROM
      users
    WHERE
      fname = 'Micah'
  ),(
    SELECT
      id
    FROM
      questions
    WHERE
      title = 'WTF?'
  )), (
  (
    SELECT
      id
    FROM
      users
    WHERE
      fname = 'Louis'
  ),(
    SELECT
      id
    FROM
      questions
    WHERE
      title = 'WTF?'
  ));
