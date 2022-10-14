defmodule HelloWeb.PageController do
  use HelloWeb, :controller

  def show(conn, _params) do
    page = %{title: "foo"}

    render(conn, "show.json", page: page)
  end

  def index(conn, _params) do
    pages = [%{title: "foo"}, %{title: "bar"}]

    render(conn, "index.json", pages: pages)
  end

  # def index(conn, _params) do
  #   conn
  #   |> put_status(202)
  #   |> render("index.html")
  # end
end
