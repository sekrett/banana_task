class PermittedParams < Struct.new(:params, :controller, :model)
  delegate :current_user, :can?, to: :controller

  def permitted_params
    if params[model].nil?
      {}
    else
      attrs = permitted_attributes(model)[0]
      if attrs == :all
        params.require(model).permit!
      else
        allow_attrs = []
        attrs.map! do |attr|
          if attr.is_a?(Hash)
            new_hash = {}
            attr.each_pair do |nested_model, array|
              if array == :all
                allow_attrs << nested_model
              elsif array.empty?
                new_hash.merge!(add_associations(model, nested_model).last)
              else
                array.map!{ |el| add_associations(nested_model, el) }.flatten!
                array.concat([:_destroy, :id])
                new_hash["#{nested_model}_attributes".to_sym] = array
              end
            end
            new_hash
          else
            add_associations(model, attr)
          end
        end.flatten!
        p = params.require(model).permit(*attrs)
        allow_attrs.each do |attr|
          value = params[model][attr]
          p[attr] = value unless value.nil?
        end
        p
      end
    end
  end

  def add_associations(model, attr)
    klass = model.to_s.singularize.camelize.constantize
    reflection = klass.try(:reflect_on_association, attr)
    if reflection
      case reflection.macro
        when :belongs_to
          [attr, (reflection.respond_to?(:options) && reflection.options[:foreign_key]) || :"#{reflection.name}_id"]
        else
          [attr, :"#{reflection.name.to_s.singularize}_ids" => []]
      end
    else
      attr
    end
  end

  def permitted_attributes(model)
    case model
      when :post
        [[:title, :content, :published, :published_at, :tag_list], nil, nil]
      when :comment
        [[:content], nil, nil]
      else
        [nil, nil, nil]
    end
  end

  private
  def get_model_name(object)
    object.class.to_s.underscore.to_sym
  end

  def add_fields_on_create(fields, on_create)
    fields += on_create if %w(new create).include?(params[:action])
    fields
  end
end
