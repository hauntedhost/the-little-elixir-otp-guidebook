defmodule Cache do
  use GenServer

  @name CACHE

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: CACHE])
  end

  def read(key) do
    GenServer.call(@name, {:read, key})
  end

  def write(key, value) do
    GenServer.cast(@name, {:write, [key, value]})
  end

  def delete(key) do
    GenServer.cast(@name, {:delete, key})
  end

  def clear do
    GenServer.cast(@name, {:clear})
  end

  def exists?(key) do
    GenServer.call(@name, {:exists?, key})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:read, key}, _from, state) do
    {:reply, state[key], state}
  end

  def handle_call({:exists?, key}, _from, state) do
    {:reply, Map.has_key?(state, key), state}
  end

  def handle_cast({:write, [key, value]}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  def handle_cast({:delete, key}, state) do
    {:noreply, Map.delete(state, key)}
  end

  def handle_cast({:clear}, _state) do
    {:noreply, %{}}
  end
end
