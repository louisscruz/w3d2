require_relative "question"

class QuestionLike

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
  end

  def self.find_by_id(id)
    question_like = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL
    return nil unless question_like.length > 0

    question_like.map { |q| QuestionLike.new(q) }
  end

  def self.likers_for_question_id(id)
    users = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_likes
      ON
        question_likes.user_id = users.id
      WHERE
        question_likes.question_id = ?
    SQL

    return nil unless users.length > 0

    users.map { |u| User.new(u) }
  end

  def self.most_liked_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        questions
      JOIN (
        SELECT
          question_id
        FROM
          question_likes
        GROUP BY
          question_id
        ORDER BY
          COUNT(*) DESC) AS most_liked
      ON
        most_liked.question_id = questions.id
      LIMIT ?
    SQL
    return nil if questions.empty?

    questions.map { |q| Question.new(q) }
  end

  def self.num_likes_for_question_id(id)
    num = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        COUNT(*) AS total
      FROM
        users
      JOIN
        question_likes
      ON
        question_likes.user_id = users.id
      WHERE
        question_likes.question_id = ?
    SQL
    num.first["total"]
  end

  def self.liked_questions_for_user_id(id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes
      ON
        question_likes.user_id = questions.user_id
      WHERE
        question_likes.user_id = ?
    SQL
    return nil unless questions.length > 0

    questions.map { |q| Question.new(q) }
  end

  attr_accessor :user_id, :question_id

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

end
