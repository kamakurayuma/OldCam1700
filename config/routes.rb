Rails.application.routes.draw do
  root "static_pages#top"

  # ユーザー関連のルーティング
  resources :users, only: %i[new create show]

  # 投稿関連のルーティング
  resources :boards, only: %i[index show new create edit update destroy] do
    collection do
      get 'search', to: 'boards#search'
      get :autocomplete
      get 'by_camera_make', to: 'boards#by_camera_make'  # カメラメーカーでフィルタリング
    end
  end
  
  # その他のリソース
  resources :cameras, only: [:create]
  resource :profile, only: %i[show edit update]

  # ログイン関連のルーティング
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  # カメラメーカーやモデルのルーティング
  get 'camera_make/:make', to: 'boards#by_camera_make', as: :by_camera_make
  get 'camera_model/:model', to: 'boards#by_camera_model', as: :by_camera_model

  # その他の検索関連のルーティング
  get 'cameras/search', to: 'cameras#search'
  get 'boards/search', to: 'boards#search'
  get 'autocomplete', to: 'boards#autocomplete'

  # トップページのルーティング
  get 'top', to: 'static_pages#top', as: 'static_pages_top'

  post 'save_camera_model', to: 'camera_models#save'
end
