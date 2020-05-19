defmodule Wicket do
  @moduledoc """
  Documentation for `Wicket`.
  """

  alias Wicket.Core

  @doc false
  @spec run(binary()) :: {:ok, term()} | {:err, atom(), binary()}
  def run(func), do: Core.run(func)
end
