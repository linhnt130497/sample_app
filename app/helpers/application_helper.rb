module ApplicationHelper
  def full_title page_title = ""
    base_title = t "ru_ap"
    page_title.empty? ? base_title : page_title + " | " + base_title
  end
end
