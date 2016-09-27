class Reply

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
  end

  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    return nil unless reply.length > 0

    reply.map { |q| Reply.new(q) }
  end

  def self.find_by_user_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL

    # ErrorHandleable.handle_error(reply)
    return nil if reply.empty?

    reply.map { |q| Reply.new(q) }
  end

  def self.find_by_question_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    # ErrorHandleable.handle_error(reply)
    return nil if reply.empty?

    reply.map { |q| Reply.new(q) }
  end

  def self.find_by_reply_id(id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        reply_id = ?
    SQL
    return nil if replies.empty?

    replies.map { |r| Reply.new(r) }
  end

  attr_accessor :body, :question_id, :user_id, :reply_id

  def initialize(options)
    @id = options['id']
    @body = options['body']
    @question_id = options['question_id']
    @user_id = options['user_id']
    @reply_id = options['reply_id']
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    return nil if @reply_id.nil?
    Reply.find_by_id(@reply_id)
  end

  def child_replies
    Reply.find_by_reply_id(@id)
  end

end
