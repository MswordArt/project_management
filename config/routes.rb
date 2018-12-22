Rails.application.routes.draw do
  devise_for :users
  get 'tasks/mytasks' => "tasks#mytasks"
  get 'tasks/completed' => "tasks#completed"
  resources :tasks do 
    resources :comments
    member do
      
      get :task_done
      put :task_done
      resources :responsibles
    end
  end
  resources :comments do
    resources :comments
  end
root 'tasks#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
