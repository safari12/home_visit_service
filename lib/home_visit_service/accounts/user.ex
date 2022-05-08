defmodule HomeVisitService.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [
    :email,
    :first_name,
    :last_name,
    :roles
  ]

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :roles, {:array, Ecto.Enum}, values: [:member, :pal]
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:first_name, min: 3)
    |> validate_length(:last_name, min: 3)
    |> unique_constraint(:email)
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
