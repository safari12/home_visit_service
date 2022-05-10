defmodule HomeVisitServiceWeb.Router do
  use HomeVisitServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug HomeVisitServiceWeb.Plugs.SetCurrentUser
  end

  scope "/" do
    pipe_through :api

    forward "/api", Absinthe.Plug, schema: HomeVisitServiceWeb.Schema.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: HomeVisitServiceWeb.Schema.Schema
  end
end
