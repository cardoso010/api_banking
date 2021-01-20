defmodule ApiBanking.Loaders.Commands do
  import Ecto.Query

  alias ApiBanking.Repo

  def get(module, uuid) do
    uuid
    |> Ecto.UUID.cast()
    |> query(module)
  end

  def get!(module, uuid) do
    uuid
    |> Ecto.UUID.cast()
    |> query!(module)
  end

  def all_by_filters(schema, filters) do
    filters
    |> Enum.reduce(base_all_by(schema), &apply_where/2)
  end

  defp query(:error, _module), do: {:error, "invalid UUID"}
  defp query({:ok, uuid}, module), do: Repo.get(module, uuid)

  defp query!(:error, _module), do: {:error, "invalid UUID"}
  defp query!({:ok, uuid}, module), do: Repo.get!(module, uuid)

  defp base_all_by(schema), do: from(s in schema)

  defp apply_where({key, nil}, query), do: from(q in query, where: is_nil(field(q, ^key)))

  defp apply_where({key, {:!=, value}}, query),
    do: from(q in query, where: field(q, ^key) != ^value)

  defp apply_where({key, {:<=, value}}, query),
    do: from(q in query, where: field(q, ^key) <= ^value)

  defp apply_where({key, {:>=, value}}, query),
    do: from(q in query, where: field(q, ^key) >= ^value)

  defp apply_where({key, {:>, value}}, query),
    do: from(q in query, where: field(q, ^key) > ^value)

  defp apply_where({key, {:<, value}}, query),
    do: from(q in query, where: field(q, ^key) < ^value)

  defp apply_where({key, value}, query), do: from(q in query, where: field(q, ^key) == ^value)
end
