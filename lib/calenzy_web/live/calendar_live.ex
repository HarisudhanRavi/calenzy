defmodule CalenzyWeb.CalendarLive do
  use CalenzyWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>Year: {@year}</div>
    <div>Month: {@month}</div>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:year, nil)
      |> assign(:month, nil)

    {:ok, socket}
  end

  def handle_params(%{"year" => year, "month" => month}, _uri, socket) do
    {start_date, _end_date} = Calenzy.get_date_range(year, month)

    {
      :noreply,
      socket
      |> assign(:year, year)
      |> assign(:month, Timex.month_name(start_date.month))
    }
  end

  def handle_params(_params, _uri, socket) do
    today = Date.utc_today()

    {:noreply, push_patch(socket, to: fetch_url_with_params(today.year, today.month))}
  end

  defp fetch_url_with_params(year, month) do
    "/calendar?year=#{year}&month=#{month}"
  end
end
