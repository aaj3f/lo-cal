class EventsScraper

  def call
    creation_hash = {}
    ramkat_scraper(creation_hash, "https://www.theramkat.com/events")
    
    create_events(creation_hash)
  end

  def ramkat_scraper(creation_hash, events_url)
    doc = Nokogiri::HTML(open(events_url))

    raw_array = doc.css('div.ramkat-events__wrap a.ramkat-events__event-cta, div.ramkat-events__wrap > script').each.with_object([]) do |node, array|
      if node["href"]
        array << node["href"]
      else
        array << JSON.parse(node.text)
      end
    end

    raw_hash = raw_array.each.with_index.with_object({}) do |(item, index), hash|
      if index % 2 == 0
        hash[item] = {}
      else
        inner_hash = hash[raw_array[(index - 1)]]
        inner_hash[:name] = item["name"]
        inner_hash[:date_and_time] = item["startDate"]
        inner_hash[:location] = item["location"]["name"]
        inner_hash[:organizer] = "The Ramkat"
        inner_hash[:description] = nil
        inner_hash[:event_url] = raw_array[(index - 1)]
      end
    end

    creation_hash.merge!(raw_hash)

  end

  def create_events(creation_hash)
    creation_hash.each do |url_key, event_data|
      Event.create(event_data) unless Event.find_by(event_url: event_data[:event_url])
    end
  end

end
