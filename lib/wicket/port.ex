defmodule Wicket.Port do
  @moduledoc false

  defp get_config do
    base_config = Application.get_all_env(:wicket)

    %{
      runtime: System.find_executable(base_config[:runtime] || raise("Missing Port runtime")),
      runner: base_config[:runner] || raise("Missing Port runner"),
      mode: base_config[:mode] || :nouse_stdio,
      args: base_config[:args] || []
    }
  end

  def open do
    config = get_config()

    port =
      Port.open(
        {:spawn_executable, config[:runtime]},
        [
          :binary,
          config[:mode],
          args: [config[:runner] | config[:args]]
        ]
      )

    Port.monitor(port)
    port
  end

  def command(cmd, port) do
    Port.command(port, cmd <> "\n")
  end

  def run(port, req_id, cmd) do
    "#{req_id}#{cmd}"
    |> command(port)
  end
end
