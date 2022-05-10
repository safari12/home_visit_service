defmodule HomeVisitService.HomeCare.Visit do
  use Ecto.Schema
  import Ecto.Changeset

  alias HomeVisitService.Accounts.User
  alias HomeVisitService.HomeCare.{Visit, Transaction}

  @required_fields [
    :date,
    :minutes,
    :tasks
  ]

  schema "visits" do
    field :date, :date
    field :minutes, :integer
    field :status, Ecto.Enum, values: [:pending, :fulfilled], default: :pending

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

    belongs_to :member, User
    has_one :transaction, Transaction
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
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{minutes: new_minutes}} ->
        case new_minutes <= user.remaining_minutes do
          true ->
            changeset

          false ->
            Ecto.Changeset.add_error(
              changeset,
              :minutes,
              "The visit you requested surpasses the remaining time in your account"
            )
        end

      changeset ->
        changeset
    end
  end
end
