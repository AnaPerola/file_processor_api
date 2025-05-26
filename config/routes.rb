Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  post "api/v1/orders" => "api/v1/orders#process_file"
end
