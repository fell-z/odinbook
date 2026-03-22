module Pageable
  extend ActiveSupport::Concern

  MAX_ITEMS_PER_PAGE = 10

  included do
    scope :page, ->(page_number) { offset(MAX_ITEMS_PER_PAGE * (page_number - 1)).limit(MAX_ITEMS_PER_PAGE) }
  end

  class_methods do
    def maximum_pages
      (unscope(:offset, :limit).count / MAX_ITEMS_PER_PAGE.to_f).ceil
    end
  end
end
