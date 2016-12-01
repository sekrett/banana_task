module Pagination
  module ControllerExt
    def paginate(relation_or_array, page_num)
      @paginator = Pagination::Engine.new(relation_or_array, page_num)
      @paginator.records
    end
  end
end
