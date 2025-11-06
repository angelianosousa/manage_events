module EventsHelper

  def badge_status_event(event)
    classe = case event.status
             when 'active'
               'primary'
             when 'finished'
               'success'
             when 'canceled'
               'danger'
             else
               'secondary'
             end

    tag.span Event.human_attribute_name("status.#{event.status}"), class: "badge bg-#{classe} rounded-pill}"
  end

  def event_progress(event)
    tickets_sold            = event.subscribers_sellout_sum
    percentage_tickets_sold = (tickets_sold.to_f / event.subscribers_expected.to_f) * 100
    tickets_sell_receipt       = humanized_money_with_symbol(event.total_receipt)
    sell_bar_color             = progress_bar_color(percentage_tickets_sold)

    <<~HEREDOC
      <p style='display: inline; color: gray;'>#{bootstrap_icon(text: "#{event.tickets_sells_verbose} #{tickets_sell_receipt}", icon: 'bi bi-people')}</p>

      <div class="progress mb-3" role="progressbar" aria-valuenow="#{percentage_tickets_sold}" aria-valuemin="0" aria-valuemax="100" style="height: 12px;">
        <div class="progress-bar bg-#{sell_bar_color}" style="width: #{percentage_tickets_sold}%; height: 12px;">#{number_to_percentage(percentage_tickets_sold, precision: 2)}</div>
      </div>
    HEREDOC
  end

  def ticket_progress(ticket)
    percentage = ticket.tickets_percentage

    sell_bar_color = progress_bar_color(percentage[:total])
    paid_bar_color = progress_bar_color(percentage[:paid])

    <<~HEREDOC
      <h6>Ingresso #{ticket.name}</h6>

      <div class="d-flex justify-content-between">
        <p class="mb-0">Vendido</p>
        <p class="mb-0">#{number_with_precision(percentage[:total], precision: 2)}%</p>
      </div>

      <div class="progress mb-2" role="progressbar" aria-valuenow="#{percentage[:total]}" aria-valuemin="0" aria-valuemax="100" style="height: 7px;">
        <div class="progress-bar bg-#{sell_bar_color}" style="width: #{percentage[:total]}%; height: 7px;"></div>
      </div>

      <div class="d-flex justify-content-between">
        <p class="mb-0">Pago</p>
        <p class="mb-0">#{number_with_precision(percentage[:paid], precision: 2)}%</p>
      </div>

      <div class="progress" role="progressbar" aria-valuenow="#{percentage[:paid]}" aria-valuemin="0" aria-valuemax="100" style="height: 7px;">
        <div class="progress-bar bg-#{paid_bar_color}" style="width: #{percentage[:paid]}%; height: 7px;"></div>
      </div>
    HEREDOC
  end

  def progress_bar_color(percentage)
    if percentage <= 0
      'secondary'
    elsif percentage <= 25
      'danger'
    elsif percentage <= 50
      'info'
    elsif percentage <= 75
      'primary'
    elsif percentage <= 100
      'success'
    else
      ''
    end
  end

  def badge_payment_status(status)
    classe = case status
             when 'pending'
              'warning'
             when 'paid'
              'success'
             when 'cancelled'
              'danger'
             when 'expired'
              'dark'
             else
              'warning'
             end

    tag.span class: "badge bg-#{classe}" do
      Payment.human_attribute_name "status.#{status}"
    end
  end

  def event_visibility(event)
    visibility = event.visible? ? 'bi-eye' : 'bi-eye-slash'
    color      = event.visible? ? 'info' : 'danger'
    class_name = "badge bg-#{color}-subtle border border-#{color}-subtle text-#{color}-emphasis"

    tag.span class: class_name do
      bootstrap_icon(icon: visibility)
    end
  end

  def payment_methods_for_select
    Payment.payment_methods.map do |key, _value|
      [Payment.human_attribute_name("payment_method.#{key}"), key]
    end
  end

  def event_statuses_for_select
    Event.statuses.map do |key, _value|
      [Event.human_attribute_name("status.#{key}"), key]
    end
  end

  def event_category_list_for_select
    Event.distinct.pluck('UNNEST(categories)').reject(&:empty?).sort
  end
end
