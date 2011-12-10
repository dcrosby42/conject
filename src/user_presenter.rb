class UserPresenter
  built_with :user_model, :user_view

  def setup
    @user_model.when :changed do
      @user_view.name = @user_model.name
    end
  end

end
