if Rails.version < '4.0.0'

  Apic::Engine.routes.draw do
    match "/" => "#index"
  end
else


  Apic::Engine.routes.draw do
    get "/" => "#index"
  end
end
