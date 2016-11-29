module LinksHelper
  def link_to_new(controller, parent_object = nil)
    if can?(controller, :create)
      link_to [:new, parent_object, controller.to_s.singularize].compact, class: 'btn btn-new btn-primary' do
        admin_icon(:plus) + '&nbsp;'.html_safe + t("actions.#{controller}.create")
      end
    end
  end

  def link_to_back(path)
    content_tag(:p, link_to(t('site.back'), path, class: 'btn btn-sm btn-default'))
  end

  def link_to_edit(path)
    link_to(admin_icon(:edit), [:edit, path].flatten, class: 'btn btn-success', title: t('site.edit'), 'data-toggle': 'tooltip')
  end

  def link_to_destroy(path)
    link_to(admin_icon(:destroy), path, 'data-confirm': t('site.confirm'), method: :delete,
            class: 'btn btn-danger', title: t('site.destroy'), 'data-toggle': 'tooltip')
  end

  def link_to_with_icon(text, href, icon, options = {})
    link_to((admin_icon(icon) + '&nbsp;'.html_safe + text).html_safe, href, options)
  end
end
