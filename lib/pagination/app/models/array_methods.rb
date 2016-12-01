module Pagination
  class ArrayMethods
    def self.get_total_count(array)
      array.size
    end

    def self.get_records(array, offset, limit)
      array[offset, limit]
    end
  end
end
