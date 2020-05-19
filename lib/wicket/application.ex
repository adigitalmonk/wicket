defmodule Wicket.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  defp poolboy_config do
    config = Application.get_all_env(:wicket)

    [
      name: {:local, :wicket_worker},
      worker_module: Wicket.Core,
      size: config[:pool_size] || 1,
      max_overflow: config[:max_overflow] || 0
    ]
  end

  def start(_type, _args) do
    children = [
      :poolboy.child_spec(:wicket_worker, poolboy_config())
    ]

    opts = [strategy: :one_for_one, name: Wicket.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
