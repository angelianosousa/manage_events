class MasterModule::CompaniesController < MastersController

  before_action :set_company, except: %i[index new create]

  def index
    @companies = Company.all
  end

  def new
    @company = Company.new
    @company.build_admin_base
  end

  def create
    @company = Company.new(company_params)

    if @company.save
      redirect_to administracao_companies_path, notice: I18n.t('controller.create', model: 'Empresa')
    else
      render :new
    end
  end

  def edit
    @company.build_admin_base unless @company.admin_base.present?
  end

  def update
    if @company.update(company_params)
      redirect_to administracao_companies_path, notice: I18n.t('controller.update', model: 'Empresa')
    else
      render :edit
    end
  end

  def toggle_company_active
    @company.toggle!(:active)

    redirect_to administracao_companies_path, notice: "Empresa #{@company.active? ? 'ativada' : 'desativada'} com sucesso!"
  end

  private

  def set_company
    if params[:company_id].present?
      @company = Company.find params[:company_id]
    else
      @company = Company.find params[:id]
    end
  end

  def company_params
    params.require(:company).permit(
      :name, :email, :site, :phone, :cellphone, :active, admin_base_attributes: %i[name email password password_confirmation]
    )
  end

end
