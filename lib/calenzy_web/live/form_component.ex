defmodule CalenzyWeb.FormComponent do
  use CalenzyWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <.modal id="form-modal" width="max-w-lg">
        <div class="font-semibold mb-2 ml-4">Add an Event</div>
        <form phx-submit="save_event" phx-target={@myself} class="text-center">
          <input type="text" class="input my-4" name="name" placeholder="Name" />
          <input type="text" class="input my-4" name="description" placeholder="Description" />
          <button type="submit" phx-click={hide_modal("form-modal")} class="btn w-28 mt-4">
            Save
          </button>
        </form>
      </.modal>
    </div>
    """
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def handle_event(
        "save_event",
        %{"name" => name, "description" => description},
        %{assigns: %{date: date}} = socket
      ) do
    true = Calenzy.Calendar.Events.save_event(date, %{name: name, description: description})

    send_update(CalenzyWeb.EventsComponent, id: "events", date: date)

    {:noreply, socket}
  end
end
