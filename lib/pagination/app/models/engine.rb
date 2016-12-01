module Pagination
  class Engine
    attr_reader :page, :total_pages, :records

    def initialize(relation_or_array, page_num)
      @object_class = detect_object_type(relation_or_array)

      @per_page = 5
      @total_count = get_total_count(relation_or_array)
      @total_pages = (@total_count.to_f / @per_page).ceil.to_i
      @page = fix_page_num(page_num)

      @records = get_records(relation_or_array)
    end

    private
    def detect_object_type(relation_or_array)
      case relation_or_array
        when ActiveRecord::Relation
          RelationMethods
        when Array
          ArrayMethods
        else
          raise ArgumentError, "Object type not supported: #{relation_or_array.class}. Use Array or ActiveRecord::Relation"
      end
    end

    def get_total_count(relation_or_array)
      @object_class.get_total_count(relation_or_array)
    end

    def get_records(relation_or_array)
      @object_class.get_records(relation_or_array, offset, limit)
    end

    def fix_page_num(page_num)
      page_num = page_num.to_i
      if page_num <= 0
        page_num = 1
      elsif page_num > @total_pages
        page_num = @total_pages
      end
      page_num
    end

    def offset
      (@page - 1) * @per_page
    end

    def limit
      if @total_count - offset < @per_page
        @total_count % @per_page
      else
        @per_page
      end
    end
  end
end
