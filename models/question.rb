require_relative 'error_handleable'

class Question
  include ErrorHandleable

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
  end

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    # ErrorHandleable.handle_error(question)
    return nil if question.empty?

    question.map { |q| Question.new(q) }
  end

  def self.find_by_author_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?
    SQL

    # ErrorHandleable.handle_error(question)
    return nil if question.empty?

    question.map { |q| Question.new(q) }
  end

  attr_accessor :title, :body, :user_id

  def initialize(options)
    @id = options['id']
    @title = options["title"]
    @body = options['body']
    @user_id = options['user_id']
  end

  def author
    User.find_by_id(@user_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

end
