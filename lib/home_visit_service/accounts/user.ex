defmodule HomeVisitService.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias HomeVisitService.HomeCare

  @required_fields [
    :email,
    :first_name,
    :last_name,
    :password
  ]

  @optional_fields [
    :health_plan_id
  ]

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :remaining_minutes, :integer, default: 0

    belongs_to :health_plan, HomeVisitService.HomeCare.HealthPlan,
      references: :plan_type,
      type: :string

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:first_name, min: 3)
    |> validate_length(:last_name, min: 3)
    |> unique_constraint(:email)
    |> assoc_constraint(:health_plan)
    |> hash_password()
    |> put_remaining_minutes()
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end

  defp put_remaining_minutes(changeset) do
    with %Ecto.Changeset{valid?: true, changes: %{health_plan_id: health_plan_id}} <-
           changeset,
         health_plan when not is_nil(health_plan) <- HomeCare.get_health_plan(health_plan_id) do
      put_change(changeset, :remaining_minutes, health_plan.minutes)
    else
      _ ->
        changeset
    end
  end
end
