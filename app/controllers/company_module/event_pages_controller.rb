class CompanyModule::EventPagesController < CompaniesController
  layout 'event_page'
  skip_before_action :authenticate_company_admin!
  before_action :set_company, only: :index
  before_action :set_event, except: :index
  before_action :set_payment, only: %i[subs_confirm subs_expired subs_cancel subs_success]
  before_action :event_exist?, except: %i[index event_not_found]

  def index
    @q = @company.events.includes(:tickets, :banner, :address).ransack(params[:q])

    @events = @q.result(distinct: true)
  end

  def show; end

  def subs_confirm
    @payment.confirm_sub!
  end

  def subs_success
    @payment.confirm_sub_success!
  end

  def subs_expired
    @payment.expire_sub!
  end

  def subs_cancel
    @payment.cancel_sub!
  end

  def buy_tickets
    @payment = BuyTickets.call(@event, params)

    if @payment&.errors&.none? && @payment.save
      redirect_to company_subs_confirm_path(company_id: params[:company_id], token_pay: @payment.token_pay), notice: I18n.t('controller.success', model: 'Ingresso')
    else
      render :show, status: :unprocessable_entity
    end
  end

  def event_not_found; end

  private

  def event_exist?
    return if @event.present?

    redirect_to company_event_not_found_path(company_id: params[:company_id]), alert: 'Evento não encontrado'
  end

  def set_event
    @event = Event.find_by_slug(params[:event_name])
  end

  def set_company
    @company = Company.find_by_slug(params[:company_id])
  end

  def set_payment
    @payment = Payment.find_by_token_pay(params[:token_pay])
  end

end
