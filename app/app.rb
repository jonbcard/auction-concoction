class AuctionNow < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers
  register CompassInitializer
  register Padrino::Admin::AccessControl
  register Padrino::Rendering
  
  use Rack::Session::Cookie
  ##
  # Application configuration options
  #
  # set :raise_errors, true     # Show exceptions (default for development)
  # set :public, "foo/bar"      # Location for static assets (default root/public)
  # set :reload, false          # Reload application files (default in development)
  # set :default_builder, "foo" # Set a custom form builder (default 'StandardFormBuilder')
  # set :locale_path, "bar"     # Set path for I18n translations (defaults to app/locale/)
  # enable  :sessions           # Disabled by default
  # disable :flash              # Disables rack-flash (enabled by default if sessions)
  # layout  :my_layout          # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
  #
  set :default_builder, 'SimpleFormBuilder'
  set :login_page, "/sessions/new"
  disable :store_location

  access_control.roles_for :any do |role|
    role.protect "/"
    role.allow "/sessions"
  end

  access_control.roles_for :admin do |role|
    role.project_module :auctions, "/auctions"
    role.project_module :accounts, "/accounts"
    role.project_module :parameters, "/parameters"
    role.project_module :customizations, "/customizations"
  end

  access_control.roles_for :clerk do |role|
    role.project_module :auctions, "/auctions"
  end

  ##
  # You can configure for a specified environment like:
  #
  #   configure :development do
  #     set :foo, :bar
  #     disable :asset_stamp # no asset timestamping for dev
  #   end
  #
  #
  ##
  # You can manage errors like:
  #
  #   error 404 do
  #     render 'errors/404'
  #   end
  #
end
