class Api::TestsController < ActionController::Base
  before_filter :authenticate, except: :index
  apic_action_params new: [:name, :acceptance],
                     create: [:name, :acceptance],
                     edit: [:name, :acceptance],
                     update: [:name, :acceptance]
  def index
  end

  def create
  end

  def show
  end

  def update
  end

  def destroy
  end

  private
  def authenticate
  end
end
