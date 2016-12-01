module Pagination
  module Helper
    def paginate
      return nil if @paginator.total_pages == 1
      @pagination ||= content_tag(:nav, 'aria-label': t('site.navigation')) do
        content_tag(:ul, class: 'pagination') do
          (1..@paginator.total_pages).to_a.map do |num|
            content_tag(:li, class: @paginator.page == num ? 'active' : '') do
              link_to(num, { controller: controller_name, action: 'index', page: num })
            end
          end.join.html_safe
        end
      end
    end
  end
end
