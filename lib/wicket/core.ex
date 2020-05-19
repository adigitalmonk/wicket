defmodule Wicket.Core do
  @moduledoc false

  use GenServer
  alias Wicket.Port

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok)
  end

  def run(func) do
    :poolboy.transaction(:wicket_worker, fn pid ->
      GenServer.call(pid, {:run, func})
    end)
  end

  # Internal
  @impl true
  def init(:ok) do
    {:ok, %{port: Port.open(), requests: %{}}}
  end

  def gen_id do
    UUID.uuid4(:hex)
  end

  @impl true
  def handle_call({:run, cmd}, from, state) do
    req_id = gen_id()
    Port.run(state.port, req_id, cmd)
    {:noreply, put_in(state, [:requests, req_id], from)}
  end

  @impl true
  def handle_info({_port, {:data, <<request_id::binary-size(32), response::binary()>>}}, state) do
    case Jason.decode(response) do
      {:ok, payload} ->
        {from, state} = pop_in(state, [:requests, request_id])

        if from != nil do
          GenServer.reply(from, payload)
        end

        {:noreply, state}

      {:error, %Jason.DecodeError{data: raw}} ->
        {from, state} = pop_in(state, [:requests, request_id])

        if from != nil do
          GenServer.reply(from, {:decode_error, request_id, raw})
        end

        {:noreply, state}
    end
  end

  def handle_info({:DOWN, _ref, :port, _object, _reason}, _) do
    # TODO: Telemetry
    {:noreply, %{port: Port.open(), requests: %{}}}
  end
end
