class CompanyModule::EventPagesController < CompaniesController
  layout 'event_page'
  skip_before_action :authenticate_company_admin!
  before_action :set_event, except: :index
  before_action :event_not_found

  def index; end

  def show; end

  def purchase_success; end

  def buy_tickets
    @payment = BuyTickets.call(@event, params)

    if @payment.errors.none? && @payment.save
      redirect_to company_purchase_success_path, notice: I18n.t('controller.success', model: 'Ingresso')
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find_by_slug(params[:event_name])
  end

  def event_not_found
    raise ActiveRecord::RecordNotFound unless @event.present?
  end
end
