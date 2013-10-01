Apic::Engine.routes.draw do
  #TODO may need to have some rails version switching here
  match "/" => "root#index"
end
