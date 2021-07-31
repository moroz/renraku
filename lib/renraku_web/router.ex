defmodule RenrakuWeb.Router do
  use RenrakuWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug RenrakuWeb.Plugs.VerifyToken
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RenrakuWeb do
    pipe_through :browser

    resources "/case_contacts", ContactController, except: [:index], param: "case_id"
    get "/case_contacts/:case_id/delete", ContactController, :confirm_delete
  end

  scope "/", RenrakuWeb do
    get "/api/heartbeat", Plugs.Heartbeat, :call
  end
end
