class PermittedFormBuilder < SimpleForm::FormBuilder
  alias parent_input input

  attr_accessor :authorized_by_assoc, :parent_attribute_name

  def input(attribute_name, options = {}, &block)
    if @authorized_by_assoc
      @authorized_by_assoc = nil
      super
    else
      case field_permission(attribute_name)
        when :editable
          super
        when :show_only
          super
        when :readonly
          super { object[attribute_name].to_s }
        else
          raise 'Unknown permission type'
      end
    end
  end

  def association(attribute_name, options={}, &block)
    case field_permission(attribute_name)
      when :editable
        @authorized_by_assoc = true
        super
      when :show_only
        @authorized_by_assoc = true
        super
      when :readonly
        parent_input(attribute_name, options) do
          attribute = object.send(attribute_name)
          if attribute.class == Array
            attribute.map { |attr| extract_value(attr) }.join(', ')
          else
            extract_value(attribute)
          end
        end
      else
        raise 'Unknown permission type'
    end
  end

  def fields_for(attribute_name, *args, &block)
    field_permission = field_permission(attribute_name)
    @parent_attribute_name = attribute_name
    case field_permission
      when :editable
        ret = super
      when :readonly
        ret = super { object.send(attribute_name).map{ |attr| extract_value(attr) }.join(' ') }
      else
        raise 'Unknown permission type'
    end
    @parent_attribute_name = nil
    ret
  end

  def editable_field?(attribute_name)
    field_permission(attribute_name) == :editable
  end

  private
  def field_permission(attribute_name)
    if check_attr_permission(get_options[:editable_attributes], attribute_name)
      :editable
    elsif check_attr_permission(get_options[:readonly_attributes], attribute_name)
      :readonly
    elsif check_attr_permission(get_options[:show_only_attributes], attribute_name)
      :show_only
    end
  end

  def extract_value(attribute)
    method = SimpleForm.collection_label_methods.find { |m| attribute.respond_to?(m) }
    attribute.send(method)
  end

  def check_attr_permission(collection, attribute_name)
    return false if collection.nil?
    (collection == :all or collection.include?(attribute_name) or test_hash_values(collection, attribute_name))
  end

  def test_hash_values(collection, attribute_name)
    collection.each do |el|
      if el.class == Hash
        parent_attribute_name = options[:parent_builder].try(:parent_attribute_name)
        if el[parent_attribute_name] == :all
          return true
        elsif parent_attribute_name and el.has_key?(parent_attribute_name)
          return el[parent_attribute_name].include?(attribute_name)
        else
          el.each_key { |key| return true if key == attribute_name }
        end
      end
    end
    false
  end

  def get_options
    if options[:parent_builder]
      options[:parent_builder].options
    else
      self.options
    end
  end
end
