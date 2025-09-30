class CompaniesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  before_action :authenticate_company_admin!

  helper_method :current_company

  def current_company
    current_company_admin.try(:company)
  end

  private

  def record_not_found
    render plain: 'Evento não encontrado', status: 404
  end

  def default_url_options(_options = {})
    if company_admin_signed_in?
      { company: current_company.slug }
    else
      {}
    end
  end
end
