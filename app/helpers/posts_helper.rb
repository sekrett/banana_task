module PostsHelper
  def posts_title(tag_name)
    if params[:user_id]
      t('site.my_posts')
    elsif tag_name
      t('headers.posts') + ' (' + tag_name + ')'
    else
      t('headers.posts')
    end
  end
end