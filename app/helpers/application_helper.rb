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
  
end
