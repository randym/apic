Rails.application.routes.draw do
  root "api/tests#index"
  namespace :api do
    resources :tests
  end

  mount Apic::Engine => "/apic"

end
