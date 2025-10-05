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

    tag.span event.status, class: "badge bg-#{classe} rounded-pill}"
  end

  def event_progress(event)
    tickets_sellout            = event.subscribers_sellout
    percentage_tickets_sellout = (tickets_sellout.to_f / event.subscribers_expected.to_f) * 100
    tickets_sell_receipt       = humanized_money_with_symbol(event.total_receipt)
    sell_bar_color             = progress_bar_color(percentage_tickets_sellout)

    <<~HEREDOC
      <p style='display: inline; color: gray;'>#{bootstrap_icon(text: "#{event.tickets_sells_verbose} #{tickets_sell_receipt}", icon: 'bi bi-people')}</p>

      <div class="progress mb-3" role="progressbar" aria-valuenow="#{percentage_tickets_sellout}" aria-valuemin="0" aria-valuemax="100" style="height: 12px;">
        <div class="progress-bar bg-#{sell_bar_color}" style="width: #{percentage_tickets_sellout}%; height: 12px;">#{number_to_percentage(percentage_tickets_sellout, precision: 2)}</div>
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

  def badge_payment_method(method)
    classe = case method
             when 'pix'
               'info'
             when 'cash'
               'success'
             when 'credit'
               'primary'
             when 'debit'
               'warning'
             else
               ''
             end

    tag.span class: "badge bg-#{classe}-subtle border border-#{classe}-subtle text-#{classe}-emphasis rounded-pill" do
      method
    end
  end

  def badge_payment_status(status)
    classe = case status
             when 'pending'
              'danger'
             when 'paid'
              'success'
             when 'overdue'
              'warning'
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
    Payment.payment_methods.map do |key, value|
      [Payment.human_attribute_name("payment_method.#{key}"), value]
    end
  end
end
