class Api::V1::EventController < Api::ApiController

  def list_of_events
    @events = Event.all
  end
end
