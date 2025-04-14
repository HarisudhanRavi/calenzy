defmodule Calenzy.Calendar.Events do
  @table_name :calendar_events

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :create_events_table, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def create_events_table(_) do
    :ets.new(@table_name, [:ordered_set, :public, :named_table])
    {:ok, self()}
  end

  def save_event(date, %{name: _name, description: _description} = event) do
    events = fetch_events(date)
    :ets.insert(@table_name, {date, [event | events]})
  end

  def fetch_events(date) do
    case :ets.lookup(@table_name, date) do
      [{_date, events}] -> events
      [] -> []
    end
  end
end
