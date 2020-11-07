Rails.application.routes.draw do

  resources :todos do 
    collection do 
      get :check_off
    end
  end

  controller :jinn do 
    get 'jinn' => :index
    get 'jinn/predict'
  end

  resources :saved_blogposts do
    collection do 
      get :more
    end
  end

  devise_for :users, controllers: { sessions: 'users/sessions' }
  
  resources :blogposts do  
    collection do 
      get :more
    end
  end
  root to: "blogposts#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
