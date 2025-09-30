class MastersController < ApplicationController
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  layout 'master'

  before_action :authenticate_administracao_master!
end
