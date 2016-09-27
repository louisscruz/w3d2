require 'sqlite3'
require 'singleton'
require_relative 'models/question'
require_relative 'models/reply'
require_relative 'models/user'
require_relative 'models/question_like'
require_relative 'models/question_follow'
require "byebug"

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

# p Question.all
# p Reply.all
# p User.all
# p QuestionFollow.all
# p QuestionLike.all

# p Question.find_by_id(1)
# p QuestionLike.find_by_id(1)
# p User.find_by_id(1)
# p Reply.find_by_id(1)
# p QuestionFollow.find_by_id(1)

# p Question.find_by_author_id(1)
# p Reply.find_by_user_id(1)
# p Reply.find_by_question_id(1)
# p User.find_by_name('Micah', 'Sapitsky')
louis = User.find_by_id(2)
micah = User.find_by_id(1)
# p louis.authored_questions.first.replies
micah.authored_replies
# p louis.authored_replies
# p louis.authored_replies.first.parent_reply
p micah.authored_replies.first.child_replies
