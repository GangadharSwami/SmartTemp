class Api::V1::EventController < Api::ApiController

  def list_of_events
    @events = Event.select("events.*, to_char(event_date, 'dd/mm/yyyy') as formatted_event_date")
  end
end
