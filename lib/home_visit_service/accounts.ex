defmodule HomeVisitService.Accounts do
  alias HomeVisitService.Repo
  alias HomeVisitService.Accounts.User

  def get_user(id), do: Repo.get(User, id)

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def autenticate(email, password) do
    user = Repo.get_by(User, email: email)

    with %{password_hash: password_hash} <- user,
         true <- Pbkdf2.verify_pass(password, password_hash) do
      {:ok, user}
    else
      _ -> :error
    end
  end
end
