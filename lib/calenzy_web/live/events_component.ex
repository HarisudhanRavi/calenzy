defmodule CalenzyWeb.EventsComponent do
  use CalenzyWeb, :live_component

  alias Calenzy.Calendar.Events

  def render(assigns) do
    ~H"""
    <div class="card shadow-xl w-96">
      <div class="card-body">
        <div class="card-title flex justify-center">
          <.icon
            name="hero-chevron-left-mini"
            phx-click="change_date"
            phx-value-change="-1"
            phx-target={@myself}
            class="hover:bg-gray-300 hover:cursor-pointer rounded-md"
          />
          <h2>{Timex.format!(@date, "{0D}-{0M}-{YYYY}")}</h2>
          <.icon
            name="hero-chevron-right-mini"
            phx-click="change_date"
            phx-value-change="+1"
            phx-target={@myself}
            class="hover:bg-gray-300 hover:cursor-pointer rounded-md"
          />
        </div>
        <div :if={@events == []} class="m-8 text-center">
          <span class="badge badge-ghost badge-xl">No Events</span>
        </div>
        <ul :if={@events != []} class="list bg-base-100 rounded-box shadow-md">
          <li :for={event <- @events} class="list-row">
            <div>
              <div>{event.name}</div>
              <div class="text-xs uppercase font-semibold opacity-60">{event.description}</div>
            </div>
          </li>
        </ul>
        <button phx-click={show_modal("form-modal")} class="btn">Add Event</button>
      </div>
    </div>
    """
  end

  def update(%{date: date} = assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:date, date)
      |> assign(:events, Events.fetch_events(date))
    }
  end

  def handle_event("change_date", %{"change" => change}, socket) do
    date = Timex.shift(socket.assigns.date, days: String.to_integer(change))

    send(self(), {:select_date, date})

    {
      :noreply,
      socket
      |> assign(:date, date)
      |> assign(:events, Events.fetch_events(date))
    }
  end
end
