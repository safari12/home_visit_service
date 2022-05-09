defmodule HomeVisitService.HomeCare.Visit do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias HomeVisitService.Accounts.User
  alias HomeVisitService.HomeCare.{Visit, Transaction}
  alias HomeVisitService.Repo

  @required_fields [
    :date,
    :minutes,
    :tasks
  ]

  schema "visits" do
    field :date, :date
    field :minutes, :integer

    field :tasks, {:array, Ecto.Enum},
      values: [
        :housekeeping,
        :laundry_service,
        :grocery_shopping,
        :cooking_meals,
        :running_errands,
        :companionship,
        :conversation
      ]

    belongs_to :member, HomeVisitService.Accounts.User
  end

  def changeset(%Visit{} = visit, %User{} = user, attrs) do
    visit
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_user_is_member(user)
    |> validate_user_plan_balance(user)
    |> assoc_constraint(:member)
  end

  defp validate_user_is_member(changeset, %User{} = user) do
    case :member in user.roles do
      true ->
        changeset

      false ->
        Ecto.Changeset.add_error(changeset, :member, "User must be a member to request a visit")
    end
  end

  defp validate_user_plan_balance(changeset, %User{} = user) do
    %Ecto.Changeset{valid?: true, changes: %{minutes: new_minutes}} = changeset

    minutes_used =
      from(t in Transaction, where: t.member_id == ^user.id)
      |> Repo.preload(:visit)
      |> Repo.all()
      |> Enum.reduce(0, fn t, acc ->
        acc + t.visit.minutes
      end)

    user
    |> Repo.preload(:health_plan)
    |> then(
      &case minutes_used + new_minutes <= &1.health_plan.minutes do
        true ->
          changeset

        false ->
          Ecto.Changeset.add_error(
            changeset,
            :minutes,
            "The visit you requested surpasses the remaining time in your health plan"
          )
      end
    )
  end
end
