module PageHandler
  extend ActiveSupport::Concern

  included do
    before_action :set_page_number, only: :index
  end

  private

  def set_page_number
    @page_number = params.fetch(:page_number, 1).to_i
    @page_number = 1 if @page_number.zero? || @page_number.negative?
  end
end
