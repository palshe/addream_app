module ApplicationHelper

  def full_title(title = "")
    if title.nil?
      "Admine"
    else
      "#{title} | Admine"
    end
  end

  def comment
  end

  #<p> <%= @resource.email %>様</p>

#<p>パスワード再設定の申請を受け付けました。以下のURLよりパスワードの再設定の手続きを行ってください。</p>

#<p><%= link_to 'パスワードを変更する', edit_user_password_url(@resource, reset_password_token: @token) %></p>

#<p>パスワード再発行の手続きをした覚えのない場合、こちらのメールは無視してください。</p>

  
end
