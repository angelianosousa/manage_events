module ApplicationHelper
  def bootstrap_icon(icon_text, icon_name, style = nil)
    tag.i(icon_text, class: "bi #{icon_name}", style: style)
  end

  def link_to_back(class_name = 'btn-sm')
    content_tag :p do
      link_to :back, class: "btn btn-light #{class_name}" do
        bootstrap_icon(' Voltar', 'bi-arrow-left-circle-fill')
      end
    end
  end

  def link_to_show_resource(text, link, color = 'btn-outline-dark', size: 'btn-sm')
    content_tag :p, class: 'text-right me-1' do
      link_to link, class: "btn #{color} #{size}" do
        bootstrap_icon(text, 'bi-list')
      end
    end
  end

  def link_to_new_resource(text, link, color = 'btn-outline-dark', size: 'btn-sm')
    content_tag :p, class: 'text-right me-1' do
      link_to link, class: "btn #{color} #{size}" do
        bootstrap_icon(text, 'bi-plus-circle-fill')
      end
    end
  end

  def link_to_edit_resource(text, link, color = 'btn-outline-dark', size: 'btn-sm')
    content_tag :p, class: 'text-right me-1' do
      link_to link, class: "btn #{color} #{size}" do
        bootstrap_icon(text, 'bi-pen')
      end
    end
  end

  def link_to_delete_resource(text, link, color = 'btn-outline-dark', size: 'btn-sm')
    content_tag :p, class: 'text-right' do
      button_to link, class: "btn #{color} #{size}", method: :delete, data: { confirm: 'Tem certeza ?' } do
        bootstrap_icon(text, 'bi-trash')
      end
    end
  end

end
