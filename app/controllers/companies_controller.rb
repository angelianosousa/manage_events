class CompaniesController < ApplicationController
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  helper_method :current_company

  def current_company
    current_admin.try(:company)
  end

  private

  def default_url_options(_options = {})
    if admin_signed_in?
      { company: current_company.slug }
    else
      {}
    end
  end
end
