defmodule SharedElitePool do
  use Agent

  @agent_name __MODULE__

  @spec start_link(any) :: {:error, any} | {:ok, pid}
  def start_link(_opts \\ []) do
    Agent.start_link(fn -> %{} end, name: @agent_name)
  end

  @spec get_elite_pool :: [[integer]]
  def get_elite_pool() do
    Agent.get(@agent_name, fn state -> state end)
    |> Map.values
  end

  @spec save_elite_individual([integer]) :: :ok
  def save_elite_individual(individual) do
    process_pid = self()
    Agent.update(@agent_name, fn existing_state ->
      Map.put(existing_state, process_pid, individual)
    end)
  end

  @spec stop :: :ok
  def stop() do
    Agent.stop(@agent_name)
  end
end
