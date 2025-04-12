defmodule CalenzyWeb.CalendarLive do
  use CalenzyWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="w-72 min-h-72 border-2 rounded-lg border-black">
      <div class="flex justify-between w-full p-2 text-center border-b-2 border-black">
        <div
          phx-click="change_month"
          phx-value-change="previous"
          class="hover:bg-gray-300 hover:cursor-pointer"
        >
          <.icon name="hero-chevron-left-mini" />
        </div>
        <div>{@display_month} . {@year}</div>
        <div
          phx-click="change_month"
          phx-value-change="next"
          class="hover:bg-gray-300 hover:cursor-pointer"
        >
          <.icon name="hero-chevron-right-mini" />
        </div>
      </div>
      <div class="grid grid-cols-7 gap-2 text-center">
        <%= for day <- ["S", "M", "T", "W", "T", "F", "S"] do %>
          <div class="font-bold p-1">{day}</div>
        <% end %>

        <%= for week <- @calendar do %>
          <%= for date <- week do %>
            <div class="p-1">
              <%= if date do %>
                {date.day}
              <% end %>
            </div>
          <% end %>
        <% end %>
      </div>
    </div>
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

  def handle_event("change_month", %{"change" => "previous"}, socket) do
    new_start = Timex.shift(socket.assigns.start_date, months: -1)
    {:noreply, push_patch(socket, to: fetch_url_with_params(new_start.year, new_start.month))}
  end

  def handle_event("change_month", %{"change" => "next"}, socket) do
    new_start = Timex.shift(socket.assigns.start_date, months: 1)
    {:noreply, push_patch(socket, to: fetch_url_with_params(new_start.year, new_start.month))}
  end

  defp fetch_url_with_params(year, month) do
    "/calendar?year=#{year}&month=#{month}"
  end
end
