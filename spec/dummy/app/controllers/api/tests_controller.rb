class Api::TestsController < ActionController::Base
  before_filter :authenticate, except: :index
  apic_action_params new: [:name, :acceptance],
                     create: [:name, :acceptance],
                     edit: [:name, :acceptance],
                     update: [:name, :acceptance]
  def index
  end

  def new
  end

  def update
  end

  def show
  end

  def update
  end

  def delete
  end

  private
  def authenticate

  end
end
