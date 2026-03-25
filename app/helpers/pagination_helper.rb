module PaginationHelper
  def page_controls(resources, page_number)
    controller = resources.klass.name.downcase.pluralize.to_sym

    tag.nav id: "page-actions" do
      tag.ul do
        concat previous_link(controller, page_number)
        concat next_link(controller, page_number, resources.maximum_pages)
      end
    end
  end

  private

  def previous_link(controller, page_number)
    return unless page_number > 1

    tag.li do
      link_to "Previous", controller:, action: :index, page_number: page_number - 1
    end
  end

  def next_link(controller, page_number, maximum_pages)
    return unless page_number < maximum_pages

    tag.li do
      link_to "Next", controller:, action: :index, page_number: page_number + 1
    end
  end
end
