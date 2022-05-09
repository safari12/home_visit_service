alias HomeVisitService.Accounts.User
alias HomeVisitService.HomeCare.Visit
alias HomeVisitService.{Accounts, HomeCare}
alias HomeVisitService.Repo

HomeCare.create_default_plans()
pal = Accounts.get_user_by_email("pal@test.com")
member = Accounts.get_user_by_email("member@test.com")

sample_user_attrs = %{
  email: "member@test.com",
  first_name: "member",
  last_name: "member",
  password: "blah69blah",
  roles: [:member],
  health_plan_id: "basic"
}

visit_attrs = %{date: Date.utc_today(), minutes: 40, tasks: [:grocery_shopping, :cooking_meals]}
