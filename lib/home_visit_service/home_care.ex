defmodule HomeVisitService.HomeCare do
  alias HomeVisitService.Accounts.User
  alias HomeVisitService.HomeCare.{Visit, HealthPlan, Transaction}
  alias HomeVisitService.Repo

  import Ecto.Query, only: [from: 2]

  def request_visit(%User{} = user, attrs) do
    try do
      Repo.transaction(fn repo ->
        visit =
          %Visit{}
          |> Visit.changeset(user, attrs)
          |> Ecto.Changeset.put_assoc(:member, user)
          |> repo.insert!()

        remaining_minutes = user.remaining_minutes - visit.minutes

        Ecto.Changeset.change(user, remaining_minutes: remaining_minutes)
        |> repo.update!()

        %{visit | member: %{visit.member | remaining_minutes: remaining_minutes}}
      end)
    rescue
      e ->
        {:error, e.changeset}
    end
  end

  def fulfill_visit(%User{} = user, visit_id) do
    try do
      Repo.transaction(fn repo ->
        visit = repo.get!(Visit, visit_id)

        if visit.status == :fulfilled do
          %Visit{}
          |> Ecto.Changeset.cast(%{}, [])
          |> Ecto.Changeset.add_error(:visit_already_fulfilled, "Visit is already fulfilled")
          |> repo.rollback()
        end

        if visit.member_id == user.id do
          %Visit{}
          |> Ecto.Changeset.cast(%{}, [])
          |> Ecto.Changeset.add_error(:invalid_fulfilled, "Cant not fulfill your own visit")
          |> repo.rollback()
        end

        %Transaction{}
        |> Transaction.changeset(%{
          member_id: visit.member_id,
          pal_id: user.id,
          visit_id: visit.id
        })
        |> repo.insert!()

        user
        |> Ecto.Changeset.change(
          remaining_minutes:
            (user.remaining_minutes || 0) + round(visit.minutes - visit.minutes * 0.15)
        )
        |> repo.update!()

        visit
        |> Ecto.Changeset.change(status: :fulfilled)
        |> repo.update!()
        |> repo.preload(:transaction)
      end)
    rescue
      e ->
        {:error, e.changeset}
    end
  end

  def get_visits_by_status(status) do
    from(v in Visit, where: v.status == ^status) |> Repo.all()
  end

  def get_all_visits(), do: Repo.all(Visit)

  def create_default_plans() do
    [
      %{
        minutes: 120,
        price: 0.35,
        plan_type: "basic"
      },
      %{
        minutes: 120 * 3,
        price: 0.28,
        plan_type: "immediate"
      },
      %{
        minutes: 120 * 6,
        price: 0.22,
        plan_type: "advance"
      }
    ]
    |> then(
      &Repo.insert_all(HealthPlan, &1, on_conflict: :replace_all, conflict_target: :plan_type)
    )
  end

  def get_supported_health_plans(), do: Repo.all(HealthPlan)
  def get_health_plan(type), do: Repo.get_by(HealthPlan, %{plan_type: type})
end
