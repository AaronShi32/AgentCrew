#!/usr/bin/env python
"""Main entry point — each crew runs independently."""

from crewai.flow.flow import Flow, listen, start

from agent_crew.crews.example_crew.example_crew import ExampleCrew


class AgentCrewFlow(Flow):
    """Flow that orchestrates independent crews.

    Add new crew methods below to register more teams.
    Each method is a standalone entry point — crews don't depend on each other.
    """

    @start()
    def run_example_crew(self):
        """Kick off the example crew."""
        result = (
            ExampleCrew()
            .crew()
            .kickoff(inputs={"topic": "AI Agents in 2026"})
        )
        return result


def kickoff():
    AgentCrewFlow().kickoff()


if __name__ == "__main__":
    kickoff()
