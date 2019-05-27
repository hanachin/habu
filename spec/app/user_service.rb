class UserService
  @Inject
  def initialize(user_repository)
    @user_repository = user_repository
  end

  def call(name)
    @user_repository.new(name)
  end
end
