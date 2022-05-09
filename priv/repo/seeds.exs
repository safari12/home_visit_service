# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     HomeVisitService.Repo.insert!(%HomeVisitService.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias HomeVisitService.Accounts
alias HomeVisitService.HomeCare

HomeCare.create_default_plans()

Accounts.create_user(%{
  email: "pal@test.com",
  first_name: "test",
  last_name: "test",
  password: "blah69blah",
  roles: [:pal],
  health_plan_id: "basic"
})
|> IO.inspect()

Accounts.create_user(%{
  email: "member@test.com",
  first_name: "test",
  last_name: "test",
  password: "blah69blah",
  roles: [:member],
  health_plan_id: "immediate"
})

Accounts.create_user(%{
  email: "both@test.com",
  first_name: "both",
  last_name: "both",
  password: "blah69blah",
  roles: [:member, :pal],
  health_plan_id: "advance"
})
