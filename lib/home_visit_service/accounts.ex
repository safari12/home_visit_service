defmodule HomeVisitService.Accounts do
  alias HomeVisitService.Repo
  alias HomeVisitService.Accounts.User

  def get_user(id), do: Repo.get(User, id)
  def get_user_by_email(email), do: Repo.get_by(User, %{email: email})

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert_or_update()
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
