require_relative "user"
require_relative "question"

class QuestionFollow

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
  end

  def self.find_by_id(id)
    question_follow = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL
    return nil unless question_follow.length > 0

    question_follow.map { |q| QuestionFollow.new(q) }
  end

  def self.follower_for_question_id(id)
    users = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        users.*
      FROM
        question_follows
      JOIN
        users
      ON
        question_follows.user_id = users.id
      WHERE
        question_follows.question_id = ?
    SQL
    return nil unless users.length > 0

    users.map { |u| User.new(u) }
  end

  def self.followed_questions_for_user_id(id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        questions.*
      FROM
        question_follows
      JOIN
        questions
      ON
        question_follows.question_id = questions.id
      WHERE
        question_follows.user_id = ?
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
