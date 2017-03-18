defmodule Gymcalc.PageController do
  use Gymcalc.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
