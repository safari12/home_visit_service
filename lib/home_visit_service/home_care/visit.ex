defmodule HomeVisitService.HomeCare.Visit do
  use Ecto.Schema
  import Ecto.Changeset

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

  def changeset(visit, attrs) do
    visit
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:member)
  end
end
