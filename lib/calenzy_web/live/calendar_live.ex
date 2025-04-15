defmodule CalenzyWeb.CalendarLive do
  use CalenzyWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="w-full h-full flex justify-center items-start">
      <div class="min-w-80 min-h-72 max-h-[350px] p-1 border-2 rounded-lg border-black">
        <div class="flex justify-between w-full p-2 text-center border-b-2 border-black">
          <.icon
            name="hero-chevron-left-mini"
            phx-click="change_month"
            phx-value-change="-1"
            class="hover:bg-gray-300 hover:cursor-pointer rounded-md"
          />

          <div>{@display_month} . {@year}</div>
          <.icon
            name="hero-chevron-right-mini"
            phx-click="change_month"
            phx-value-change="+1"
            class="hover:bg-gray-300 hover:cursor-pointer rounded-md"
          />
        </div>
        <div class="grid grid-cols-7 gap-2 text-center">
          <%= for day <- ["S", "M", "T", "W", "T", "F", "S"] do %>
            <div class="font-bold p-1">{day}</div>
          <% end %>

          <%= for week <- @calendar do %>
            <%= for date <- week do %>
              <div
                class={[
                  "p-1 rounded-md",
                  date && "hover:bg-gray-300 hover:cursor-pointer",
                  date == @selected_date && "bg-gray-400"
                ]}
                phx-click="select_date"
                phx-value-date={date}
              >
                <%= if date do %>
                  {date.day}
                <% end %>
              </div>
            <% end %>
          <% end %>
        </div>
        <button phx-click="today" class="btn btn-xs btn-ghost ml-28">Go to Today</button>
      </div>

      <div class="ml-24">
        <.live_component module={CalenzyWeb.EventsComponent} id="events" date={@selected_date} />
      </div>
    </div>

    <.live_component module={CalenzyWeb.FormComponent} id="form-component" date={@selected_date} />
    """
  end

  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:start_date, nil)
      |> assign(:year, nil)
      |> assign(:month, nil)
      |> assign(:display_month, nil)
      |> assign(:selected_date, Date.utc_today())
    }
  end

  def handle_params(%{"year" => year, "month" => month}, _uri, socket) do
    year = String.to_integer(year)
    month = String.to_integer(month)

    {
      :noreply,
      socket
      |> assign(:start_date, Timex.beginning_of_month(year, month))
      |> assign(:year, year)
      |> assign(:month, month)
      |> assign(:display_month, Timex.month_name(month))
      |> assign(:calendar, Calenzy.build_month_calendar(year, month))
    }
  end

  def handle_params(_params, _uri, socket) do
    today = Date.utc_today()

    {:noreply, push_patch(socket, to: fetch_url_with_params(today.year, today.month))}
  end

  def handle_event("change_month", %{"change" => change}, socket) do
    new_start = Timex.shift(socket.assigns.start_date, months: String.to_integer(change))
    {:noreply, push_patch(socket, to: fetch_url_with_params(new_start.year, new_start.month))}
  end

  def handle_event("select_date", %{"date" => date}, socket) do
    {:noreply, assign(socket, :selected_date, Date.from_iso8601!(date))}
  end

  def handle_event("select_date", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("today", _params, socket) do
    today = Date.utc_today()

    {
      :noreply,
      socket
      |> assign(:selected_date, today)
      |> push_patch(to: fetch_url_with_params(today.year, today.month))
    }
  end

  def handle_info({:select_date, selected_date}, socket) do
    {
      :noreply,
      socket
      |> assign(:selected_date, selected_date)
      |> push_patch(to: fetch_url_with_params(selected_date.year, selected_date.month))
    }
  end

  defp fetch_url_with_params(year, month) do
    "/calendar?year=#{year}&month=#{month}"
  end
end
