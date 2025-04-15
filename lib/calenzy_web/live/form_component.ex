defmodule CalenzyWeb.FormComponent do
  use CalenzyWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <.modal id="form-modal">
        This is a modal
      </.modal>
    </div>
    """
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
