defmodule HomeVisitService.Repo do
  use Ecto.Repo,
    otp_app: :home_visit_service,
    adapter: Ecto.Adapters.Postgres
end
