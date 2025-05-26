Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      post 'orders/process_file', to: 'orders#process_file'
    end
  end
end
