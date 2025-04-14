defmodule CalenzyWeb.EventsComponent do
  use CalenzyWeb, :live_component

  alias Calenzy.Calendar.Events

  def render(assigns) do
    ~H"""
    <div class="card shadow-xl w-96">
      <div class="card-body">
        <h2 class="card-title">{@date}</h2>
        <ul class="list bg-base-100 rounded-box shadow-md">
          <li :for={event <- @events} class="list-row">
            <div>
              <div>{event.name}</div>
              <div class="text-xs uppercase font-semibold opacity-60">{event.description}</div>
            </div>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  def update(%{date: date} = assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:date, Timex.format!(date, "{0D}-{0M}-{YYYY}"))
      |> assign(:events, Events.fetch_events(date))
    }
  end
end
