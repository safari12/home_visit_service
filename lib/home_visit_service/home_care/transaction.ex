defmodule HomeVisitService.HomeCare.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [
    :member_id,
    :pal_id,
    :visit_id
  ]

  schema "transactions" do
    belongs_to :member, HomeVisitService.Accounts.User
    belongs_to :pal, HomeVisitService.Accounts.User
    belongs_to :visit, HomeVisitService.HomeCare.Visit
  end

  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:member)
    |> assoc_constraint(:pal)
    |> assoc_constraint(:visit)
  end
end
