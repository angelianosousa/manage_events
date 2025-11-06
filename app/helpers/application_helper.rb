module ApplicationHelper
  def bootstrap_icon(text: nil, icon: nil, class_name: nil, style: nil)
    tag.i(text, class: "bi #{icon} #{class_name}", style: style)
  end

  def link_to_back(class_name = 'btn-sm')
    content_tag :p do
      link_to :back, class: "btn btn-light #{class_name}" do
        bootstrap_icon(text: ' Voltar', icon: 'bi-arrow-left-circle-fill')
      end
    end
  end

  def link_to_show_resource(text, link, color = 'btn-outline-dark', size: 'btn-sm')
    content_tag :p, class: 'text-right me-1' do
      link_to link, class: "btn #{color} #{size}" do
        bootstrap_icon(text: text, icon: 'bi-list')
      end
    end
  end

  def link_to_new_resource(text, link, color = 'btn-outline-dark', size: 'btn-sm')
    content_tag :p, class: 'text-right me-1' do
      link_to link, class: "btn #{color} #{size}" do
        bootstrap_icon(text: text, icon: 'bi-plus-circle-fill')
      end
    end
  end

  def link_to_edit_resource(text, link, color = 'btn-outline-dark', size: 'btn-sm')
    content_tag :p, class: 'text-right me-1' do
      link_to link, class: "btn #{color} #{size}" do
        bootstrap_icon(text: text, icon: 'bi-pen')
      end
    end
  end

  def link_to_delete_resource(text, link, color = 'btn-outline-dark', size: 'btn-sm')
    content_tag :p, class: 'text-right' do
      button_to link, class: "btn #{color} #{size}", method: :delete, data: { confirm: 'Tem certeza ?' } do
        bootstrap_icon(text: text, icon: 'bi-trash')
      end
    end
  end

  def link_to_toggle_resource(active, link)
    content_tag :p, class: 'text-right' do
      button_to link, class: "btn btn-#{active ? 'success' : 'outline-success'} btn-sm", method: :post do
        bootstrap_icon(icon: 'bi-check-circle')
      end
    end
  end

end
