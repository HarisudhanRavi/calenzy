defmodule CalenzyWeb.EventsComponent do
  use CalenzyWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="w-[40%] m-12 border-2 border-black rounded-md text-center">
      <div>{@date}</div>
    </div>
    """
  end

  def update(%{date: date} = assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:date, Timex.format!(date, "{0D}-{0M}-{YYYY}"))
    }
  end
end
