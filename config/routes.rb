if Rails.version < '4.0.0'

  Apic::Engine.routes.draw do
    match "/" => "application#index"
  end
else


  Apic::Engine.routes.draw do
    get "/" => "application#index"
  end
end
