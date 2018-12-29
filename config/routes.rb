Rails.application.routes.draw do
  
  devise_for :users
  get 'projects/mytasks' => "projects#mytasks"
  get 'projects/completed' => "projects#completed"
  #get 'tasks/reminder' => "tasks#reminder"
  resources :projects do
  resources :tasks do 
    resources :comments
    member do
      
      get :task_done
      put :task_done
      get :task_complete
      put :task_complete
      
      resources :responsibles
    end
  end
  resources :comments do
    resources :comments
  end
end
root 'projects#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
