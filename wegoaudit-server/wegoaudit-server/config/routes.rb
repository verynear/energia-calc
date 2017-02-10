Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'signin', sign_out: 'signout'}
  # General purpose routes that are used by both the web UI and iOS

  resources :users, only: [:index, :show]


  # Routes that the WegoAudit web UI depends on.
  #
  resources :audits, only: [:index, :create, :show, :destroy] do
     collection do
       post :clone
       get :deleted
     end

     member do
       delete :immediate_delete
       get :undelete
     end
  end
  resources :structure_types, only: [] do
    member do
      get 'subtypes'
    end
  end
  scope 'audits/:audit_id', as: 'audit', module: 'web' do
    resources :buildings, only: [] do
      collection do
        post :search
      end
    end
    resources :fields, only: [:update]
    resources :measures, only: [:update]
    resources :photos, only: [:create, :destroy] do
      member do
        get ':style.jpg' => 'photos#download', as: :download
      end
    end
    resources :sample_groups, only: [:create, :destroy, :show, :update]
    resources :structures, only: [:create, :destroy, :show, :update] do
      collection do
        post :clone
      end

      member do
        post :link
      end
    end
  end

  # Routes that the WegoAudit iOS app depends on.
  #
  get 'download_organizations' => 'organizations#download'
  resources :apartments, only: [:create, :update]
  resources :audit_types, only: [:index]
  resources :audits, only: [:index, :show, :update] do
    member do
      post :lock
      post :unlock
    end
  end
  resources :buildings, only: [:index, :show, :create, :update] do
    member do
      get :download_apartments, to: 'buildings#download_apartments'
      get :download_full, to: 'buildings#download_full_building'
      get :export_full, to: 'buildings#export_full'
    end
  end
  resources :field_enumerations, only: [:index]
  resources :field_values, only: [:index, :create, :update]
  resources :fields, only: [:index]
  resources :groupings, only: [:index]
  resources :measure_values, only: [:index, :create, :update, :show]
  resources :measures, only: [:index]
  resources :meters, only: [:create, :update]
  resources :organizations, only: [:index, :show] do
    member do
      get :download_buildings
    end
  end
  resources :sample_groups, only: [:create, :show, :update]
  resources :structure_types, only: [:index]
  resources :structures, only: [:create, :show, :update] do
    member do
      get :export_full
    end
    resources :photos, only: [:index, :create] do
      member do
        get :download
      end
    end
  end
  resources :substructure_types, only: [:index]

  # Routes that Retrocalc depends on.
  #
  namespace :retrocalc do
    resources :audits, only: [:index, :show]
    resources :measures, only: [:index]
    resources :structure_types, only: [:index]
    resources :fields, only: [:index]
  end

  root to: 'visitors#index'
  mount Sidekiq::Web => 'sidekiq'
end
