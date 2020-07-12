defmodule RunStatusAgent do
  @agent_name __MODULE__

  @spec start_link(any) :: {:error, any} | {:ok, pid}
  def start_link(_opts \\ []) do
    Agent.start_link(fn -> %{} end, name: @agent_name)
  end

  @spec get_run_statuses :: [:ok | :done]
  def get_run_statuses() do
    Agent.get(@agent_name, &(&1))
  end

  @spec set_run_status(:running | :done) :: :ok
  def set_run_status(status) do
    pid = self()
    Agent.update(@agent_name, fn state ->
      Map.put(state, pid, status)
    end)
  end
end
