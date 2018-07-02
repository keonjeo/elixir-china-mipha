defmodule MiphaWeb.Router do
  use MiphaWeb, :router

  pipeline :browser do
    plug Ueberauth
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug MiphaWeb.Plug.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug :put_layout, {MiphaWeb.LayoutView, :admin}
  end

  scope "/auth", MiphaWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  scope "/", MiphaWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/join", SessionController, :new, as: :join
    post "/join", SessionController, :create, as: :join
    get "/login", AuthController, :login
    get "/logout", AuthController, :delete, as: :logout

    resources "/topics", TopicController
    resources "/notifications", NotificationController
  end

  scope "/admin", MiphaWeb.Admin, as: :admin do
    pipe_through ~w(browser admin)a

    get "/", PageController, :index
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", MiphaWeb do
  #   pipe_through :api
  # end
end