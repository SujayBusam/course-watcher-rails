module ApplicationHelper

  def print_attribute(attribute)
    if attribute
      attribute
    else
      "N/A"
    end
  end

  def get_text(node)
    text = node.text
    if text.nil? || text.empty? || text == "&nbsp"
      return nil
    else
      return text
    end
  end
end
