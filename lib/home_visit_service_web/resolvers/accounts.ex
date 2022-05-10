defmodule HomeVisitServiceWeb.Resolvers.Accounts do
  alias HomeVisitService.Accounts
  alias HomeVisitServiceWeb.Schema.ChangesetErrors
  alias HomeVisitServiceWeb.AuthToken

  def signin(_, %{email: email, password: password}, _) do
    case Accounts.authenticate(email, password) do
      :error ->
        {:error, "Whoops, invalid credentials!"}

      {:ok, user} ->
        token = AuthToken.sign(user)
        {:ok, %{user: user, token: token}}
    end
  end

  def signup(_, args, _) do
    case Accounts.create_user(args) do
      {:error, changeset} ->
        {
          :error,
          message: "Could not create account", details: ChangesetErrors.error_details(changeset)
        }

      {:ok, user} ->
        token = AuthToken.sign(user)
        {:ok, %{user: user, token: token}}
    end
  end

  def me(_, _, %{context: %{current_user: user}}) do
    {:ok, user}
  end

  def me(_, _, _) do
    {:ok, nil}
  end
end
