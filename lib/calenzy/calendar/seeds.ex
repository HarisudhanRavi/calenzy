defmodule Calenzy.Calendar.Seeds do
  def provide_seed_data() do
    [
      %{
        name: "Team Standup",
        description: "Daily sync-up with the dev team to discuss progress and blockers."
      },
      %{
        name: "Client Meeting",
        description: "Presentation of the new feature roadmap to the client stakeholders."
      },
      %{
        name: "Code Review",
        description: "Review recent pull requests and discuss improvements."
      },
      %{
        name: "Product Brainstorming",
        description: "Creative session to ideate on upcoming product features."
      },
      %{
        name: "Lunch with Mentor",
        description: "Catch-up lunch and career guidance discussion."
      },
      %{
        name: "Quarterly Planning",
        description: "High-level strategy and goal setting for the next quarter."
      },
      %{
        name: "Yoga Session",
        description: "Relax and recharge with a guided yoga session."
      },
      %{
        name: "Design Review",
        description: "Walkthrough of new UI designs with the design team."
      },
      %{
        name: "Hackathon Kickoff",
        description: "Start of internal hackathon with team formations and project ideas."
      },
      %{
        name: "Project Retrospective",
        description:
          "Reflect on the last sprint and discuss what went well and what could improve."
      }
    ]
    |> Enum.map(fn event -> {Date.add(Date.utc_today(), Enum.random([-1, 0, 1])), event} end)
  end
end
