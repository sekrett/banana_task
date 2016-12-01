module Pagination
  class RelationMethods
    def self.get_total_count(relation)
      relation.klass.count
    end

    def self.get_records(relation, offset, limit)
      relation.offset(offset).limit(limit)
    end
  end
end
