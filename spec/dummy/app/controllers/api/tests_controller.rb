class Api::TestsController < ActionController::Base
  apic_action_params new: [:name, :acceptance],
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
end
