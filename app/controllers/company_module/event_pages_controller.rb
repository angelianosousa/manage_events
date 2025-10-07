class CompanyModule::EventPagesController < CompaniesController
  layout 'event_page'
  skip_before_action :authenticate_company_admin!
  before_action :set_event, except: :index
  before_action :event_exist?, except: %i[index event_not_found]

  def index
    @company = Company.find_by_slug(params[:company_id])

    @q = @company.events.includes(:tickets, :banner, :address).ransack(params[:q])

    @events = @q.result(distinct: true)
  end

  def show; end

  def purchase_success; end

  def buy_tickets
    @payment = BuyTickets.call(@event, params)

    if @payment.errors.none? && @payment.save
      redirect_to company_purchase_success_path(company_id: params[:company_id]), notice: I18n.t('controller.success', model: 'Ingresso')
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

end
