class CompanyModule::EventPagesController < CompaniesController
  skip_before_action :authenticate_admin!

  layout 'event_page'

  def index; end

  def show
    @event = Event.find_by_slug(params[:event_name])
  end
end
