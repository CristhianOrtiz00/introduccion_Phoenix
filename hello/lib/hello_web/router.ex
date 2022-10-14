defmodule HelloWeb.Router do
  use HelloWeb, :router

  pipeline :browser do
    plug :accepts, ["html", "text"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {HelloWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug HelloWeb.Plugs.Locale, "en"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HelloWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/redirect_test", PageController, :redirect_test

    resources "/users", UserController do
      resources "/posts", PostController
    end

    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show
    resources "/reviews", ReviewController
  end

  scope "/admin", HelloWeb.Admin, as: :admin do
    pipe_through :browser

    resources "/images", ImageController
    resources "/reviews", ReviewController
    resources "/users", UserController
  end

  scope "/api", HelloWeb.Api, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/images", ImageController
      resources "/reviews", ReviewController
      resources "/users", UserController
    end
  end

  # Other scopes(ámbitos) pueden utilizar stacks.
  # scope "/api", HelloWeb do
  #   pipe_through :api
  # end

  # Habilita LiveDashboard sólo para el desarrollo
  #
  # Si quieres usar el LiveDashboard en producción, debes ponerlo
  # detrás de la autenticación y permitir que sólo los administradores puedan acceder a ella.
  # Si tu aplicación aún no tiene una sección sólo para administradores,
  # puedes usar Plug.BasicAuth para configurar una autenticación básica
  # siempre y cuando estés usando SSL (lo cual deberías hacer de todos modos).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: HelloWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
