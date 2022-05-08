defmodule HomeVisitService.HomeCare do
  alias HomeVisitService.Accounts.User
  alias HomeVisitService.HomeCare.Visit
  alias HomeVisitService.Repo

  def request_visit(%User{} = user, attrs) do
    %Visit{}
    |> Visit.changeset(attrs)
    |> ensure_user_is_member(user)
    |> Ecto.Changeset.put_assoc(:member, user)
    |> Repo.insert()
  end

  defp ensure_user_is_member(changeset, user) do
    case :member in user.roles do
      true ->
        changeset

      false ->
        Ecto.Changeset.add_error(changeset, :member, "User must be a member to request a visit")
    end
  end
end
