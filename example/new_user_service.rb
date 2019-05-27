class NewUserService
  @Inject
  def initialize(user_repository)
    @user_repository = user_repository
  end

  def call(*params)
    @user_repository.new(*params)
  end
end
