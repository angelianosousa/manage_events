class CompanyModule::DashboardController < CompaniesController
  def index
    @events = current_company.events
  end
end
