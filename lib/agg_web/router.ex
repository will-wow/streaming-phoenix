defmodule AggWeb.Router do
  use AggWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", AggWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    resources("/expanded-users", ExpandedUserController, only: [:show])
    get("/users-stream", ExpandedUserController, :users_stream)
  end

  # Other scopes may use custom stacks.
  # scope "/api", AggWeb do
  #   pipe_through :api
  # end
end
