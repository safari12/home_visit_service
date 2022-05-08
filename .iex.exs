alias HomeVisitService.Accounts.User
alias HomeVisitService.HomeCare.Visit
alias HomeVisitService.{Accounts, HomeCare}
alias HomeVisitService.Repo

pal = Accounts.get_user_by_email("pal@test.com")
member = Accounts.get_user_by_email("member@test.com")
visit_attrs = %{date: Date.utc_today(), minutes: 40, tasks: [:grocery_shopping, :cooking_meals]}
