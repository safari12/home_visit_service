defmodule HomeVisitServiceWeb.Schema.Schema do
  use Absinthe.Schema

  alias HomeVisitServiceWeb.{Resolvers, Middlewares}

  import_types(Absinthe.Type.Custom)

  enum(:status, values: [:pending, :fulfilled])
  enum(:role, values: [:member, :pal])

  enum(:task,
    values: [
      :housekeeping,
      :laundry_service,
      :grocery_shopping,
      :cooking_meals,
      :running_errands,
      :companionship,
      :conversation
    ]
  )

  query do
    @desc "Get the currently signed-in user"
    field :me, :user do
      resolve(&Resolvers.Accounts.me/3)
    end

    @desc "Get supported health plans"
    field :health_plans, list_of(:health_plan) do
      resolve(&Resolvers.HomeCare.health_plans/3)
    end

    @desc "Get visits by status"
    field :visits, list_of(:visit) do
      arg(:status, non_null(:status))
      resolve(&Resolvers.HomeCare.visits/3)
    end
  end

  mutation do
    @desc "Create a user account"
    field :signup, :session do
      arg(:first_name, non_null(:string))
      arg(:last_name, non_null(:string))
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      arg(:health_plan_id, :string)
      arg(:roles, list_of(:role))
      resolve(&Resolvers.Accounts.signup/3)
    end

    @desc "Sign in a user"
    field :signin, :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolvers.Accounts.signin/3)
    end

    @desc "Request a visit"
    field :request_visit, :visit do
      arg(:date, non_null(:date))
      arg(:minutes, non_null(:integer))
      arg(:tasks, non_null(list_of(:task)))
      middleware(Middlewares.Authenticate)
      resolve(&Resolvers.HomeCare.request_visit/3)
    end

    @desc "Fulfill a visit"
    field :fulfill_visit, :visit do
      arg(:visit_id, non_null(:integer))
      middleware(Middlewares.Authenticate)
      resolve(&Resolvers.HomeCare.fulfilled_visit/3)
    end
  end

  object :user do
    field :email, non_null(:string)
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
    field :roles, list_of(:string)
    field :health_plan_id, :string
    field :remaining_minutes, non_null(:integer)
  end

  object :session do
    field :user, non_null(:user)
    field :token, non_null(:string)
  end

  object :health_plan do
    field :minutes, non_null(:integer)
    field :price, non_null(:float)
  end

  object :visit do
    field :id, non_null(:integer)
    field :date, non_null(:date)
    field :minutes, non_null(:integer)
    field :tasks, list_of(:string)
    field :status, non_null(:status)
    field :member_id, non_null(:integer)
    field :transaction, :transaction
  end

  object :transaction do
    field :member_id, non_null(:integer)
    field :pal_id, non_null(:integer)
    field :visit_id, non_null(:integer)
  end
end
