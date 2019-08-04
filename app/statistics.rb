class Statistics
  attr_accessor :users
  def initialize(users: [])
    @users = users
  end

  def add_object(value)
    @users << value
  end
end
