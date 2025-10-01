class CompanyModule::ProfileController < CompaniesController
  before_action :set_company

  def edit
    @company.build_logo unless @company.logo.present?
  end

  def update
    if @company.update(company_params)
      redirect_to company_profile_path, notice: I18n.t('controller.update', model: 'Perfil')
    else
      render :edit
    end
  end

  private

  def set_company
    @company = Company.friendly.find(params[:company_id])
  end

  def company_params
    params.require(:company).permit(
      :name, :email, :site, :phone, :cellphone, :active, 
      admin_base_attributes: %i[name email password password_confirmation],
      logo_attributes: %i[image]
    )
  end

end
