defmodule HomeVisitServiceWeb.Schema.Schema do
  use Absinthe.Schema

  alias HomeVisitServiceWeb.Resolvers

  import_types(Absinthe.Type.Custom)

  query do
    @desc "Get the currently signed-in user"
    field :me, :user do
      resolve(&Resolvers.Accounts.me/3)
    end
  end

  mutation do
    @desc "Create a user account"
    field :signup, :session do
      arg(:first_name, non_null(:string))
      arg(:last_name, non_null(:string))
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      arg(:health_plan_id, non_null(:string))
      arg(:roles, list_of(:string))
      resolve(&Resolvers.Accounts.signup/3)
    end

    @desc "Sign in a user"
    field :signin, :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolvers.Accounts.signin/3)
    end
  end

  object :user do
    field :email, non_null(:string)
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
    field :roles, list_of(:string)
    field :remaining_minutes, non_null(:integer)
  end

  object :session do
    field :user, non_null(:user)
    field :token, non_null(:string)
  end
end
