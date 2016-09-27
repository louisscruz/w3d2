require_relative "question"
require_relative "reply"
require_relative "question_follow"

class User

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM users")
  end

  def self.find_by_id(id)
    user = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    return nil unless user.length > 0

    # user.map { |q| User.new(q) }
    User.new(user.first)
  end

  def self.find_by_name(fname, lname)
    user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL

    # ErrorHandleable.handle_error(user)
    return nil if user.empty?

    user.map { |q| User.new(q) }
  end

  attr_accessor :fname, :lname

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def followers
    authored_questions.map { |q| QuestionFollow.follower_for_question_id(q.id)}.uniq
  end
end
