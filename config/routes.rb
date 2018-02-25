Rails.application.routes.draw do
  get '/' => 'reports#index'
  post 'reports' => 'reports#flag'
  post 'clear' =>'reports#clear'
end
