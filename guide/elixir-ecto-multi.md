- Ecto Multi as Business Transaction layer
  - changesets?
    to work with forms
  - ecto multi? - to combine multiple operations into a single one - works also for non-db operations

```elixir
defmodule AlchemyReaction.Sales.CancelOrderManually do
  @moduledoc """
  Cancels an order with the given reason and notifies the client via email.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Multi

  alias AlchemyReaction.Sales.Order

  embedded_schema do
    field :reason
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:reason])
    |> validate_required([:reason])
    |> validate_length(:reason, min: 10)
  end

  def call(%Ecto.Changeset{valid?: true} = changeset, %{order: order, actor: actor} = _deps) do
    data = apply_changes(changeset)

    Multi.new()
    |> Multi.update(:order, Order.changeset(order, %{status: "cancelled"}))
    |> Multi.run(:audit, &cancel_order_audit(&1, &2, data.reason, actor))
    |> Multi.run(:email, &notify_client(&1, &2, actor))
  end

  defp cancel_order_audit(_repo, %{order: order}, reason, actor) do
    # ...
  end

  defp notify_client(_repo, %{order: order}, actor) do
    # ...
  end
end
```
