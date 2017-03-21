Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'signin', sign_out: 'signout'}
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  root 'visitors#index'

  resources :audit_reports do
    get 'download_usage', on: :member

    resource :display,
             only: [:edit, :update, :show],
             controller: 'display_reports' do
      collection do
        put :change_template
        put :preview
      end
    end

    resources :field_values, only: [:update]
    resources :original_structure_field_values, only: [:update]
  end

  scope 'audit_reports/:audit_report_id', as: 'audit_report' do
    resources :measure_selections, only: [:new, :create, :update, :destroy]
  end

  resources :users, only: [:edit, :update]

  scope 'measure_selections/:measure_selection_id', as: 'measure_selection' do
    resources :structure_changes, only: [:new, :create, :destroy]
    resources :field_values, only: [:update]
  end

  resources :report_templates, except: [:show] do
    put :preview, on: :collection
  end

  scope 'structures/:structure_id', as: 'structure' do
    resources :field_values, only: [:update]
  end

  resources :structures, only: [:update]
end
