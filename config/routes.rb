Rails.application.routes.draw do
  resources :items
  post  "/items/upload_image" => "items#upload_image"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
