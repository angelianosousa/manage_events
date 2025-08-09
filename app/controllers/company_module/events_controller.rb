class CompanyModule::EventsController < CompaniesController
  before_action :set_event, only: %i[show edit update destroy event_toggle_visibility]

  # GET /events or /events.json
  def index
    @q = current_company.events.ransack(params[:q])

    @events = @q.result(distinct: true).includes(:tickets, :address)
  end

  # GET /events/1 or /events/1.json
  def show; end

  # GET /events/new
  def new
    @event = current_company.events.build
    @event.build_address
    @event.build_banner
  end

  # GET /events/1/edit
  def edit
    @event.build_address unless @event.address.present?
    @event.build_banner  unless @event.banner.present?
  end

  # POST /events or /events.json
  def create
    @event = current_company.events.build(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to company_event_path(@event.id), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to company_event_path(@event.id), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy!

    respond_to do |format|
      format.html { redirect_to company_events_path, status: :see_other, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def event_toggle_visibility
    @event.toggle_visible!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = current_company.events.includes(:tickets, :address, :banner).friendly.find(params[:id], allow_nil: true)
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(
      :id, :name, :description, :date_start, :time_start, :time_end, :status, :category_name, :subs_number, :visible,
      address_attributes: %i[id place_name address_name],
      tickets_attributes: %i[id name description quantity price],
      banner_attributes: %i[id image]
    )
  end
end
