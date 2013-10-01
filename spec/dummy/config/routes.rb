Rails.application.routes.draw do
  root "api/tests#index"
  namespace :api do
    resources :tests, except: [:new, :edit]
  end

  mount Apic::Engine => "/apic"

end
