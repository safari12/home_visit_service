defmodule HomeVisitServiceWeb.Resolvers.HomeCare do
  alias HomeVisitService.HomeCare
  alias HomeVisitServiceWeb.Schema.ChangesetErrors

  def health_plans(_, _, _), do: HomeCare.get_supported_health_plans()

  def request_visit(_, args, %{context: %{current_user: user}}) do
    case HomeCare.request_visit(user, args) do
      {:error, changeset} ->
        {:error,
         message: "Could not request visit", details: ChangesetErrors.error_details(changeset)}

      {:ok, visit} ->
        {:ok, visit}
    end
  end
end
