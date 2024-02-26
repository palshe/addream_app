module UsersHelper
  def name_may_be_blank
    if @user.name.blank?
      ""
    else
      "#{@user.name}さん"
    end
  end
end
