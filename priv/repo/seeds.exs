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

alias HomeVisitService.Repo
alias HomeVisitService.Accounts
alias HomeVisitService.HomeCare

Accounts.create_user(%{
  email: "pal@test.com",
  first_name: "test",
  last_name: "test",
  password: "blah69blah",
  roles: [:pal]
})

Accounts.create_user(%{
  email: "member@test.com",
  first_name: "test",
  last_name: "test",
  password: "blah69blah",
  roles: [:member]
})

Accounts.create_user(%{
  email: "both@test.com",
  first_name: "both",
  last_name: "both",
  password: "blah69blah",
  roles: [:member, :pal]
})
