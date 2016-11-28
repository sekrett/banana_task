module GlyphiconsHelper
  def admin_icon(action)
    case action
      when :edit
        glyphicon_tag(:mi, 'edit')
      when :destroy
        glyphicon_tag(:fa, 'trash')
      when :plus
        glyphicon_tag(:bs, 'plus')
      else
        raise ArgumentError, 'Unknown icon'
    end
  end

  private
  def glyphicon_tag(library, icon, options = {})
    klass =
        case library
          when :bs # Bootstrap
            "glyphicon glyphicon-#{icon} "
          when :fa # Font Awesome
            "fa fa-#{icon}"
          when :mi # Material Icon
            "mi #{icon}"
          when :io # Ionicons
            "ionicons ion-#{icon}"
          when :im # IcoMoon
            "icomoon icon-#{icon}"
          when :fl # Font Linux
            "fl-#{icon}"
          else
            raise ArgumentError, 'Unknown glyphicon library'
        end
    options[:class] = "icon #{klass} #{options[:class]}".strip
    content_tag(:span, '', options)
  end
end
