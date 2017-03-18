defmodule Gymcalc.Router do
  use Gymcalc.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Gymcalc do
    src_url = "/gymcalc"
    pipe_through :browser # Use the default browser stack

    get ( src_url <> "" ), PageController, :index
    get ( src_url <> "/intro" ), PageController, :index
    get ( src_url <> "/food" ), PageController, :index
    get ( src_url <> "/infocollection" ), PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Gymcalc do
  #   pipe_through :api
  # end
end
