defmodule HomeVisitService.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [
    :email,
    :first_name,
    :last_name,
    :password,
    :roles,
    :health_plan_id
  ]

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :roles, {:array, Ecto.Enum}, values: [:member, :pal]
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    belongs_to :health_plan, HomeVisitService.HomeCare.HealthPlan,
      references: :plan_type,
      type: :string

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:first_name, min: 3)
    |> validate_length(:last_name, min: 3)
    |> unique_constraint(:email)
    |> assoc_constraint(:health_plan)
    |> hash_password()
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end
end
