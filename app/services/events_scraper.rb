class EventsScraper

  def call
    creation_hash = {}
    ramkat_scraper(creation_hash, "https://www.theramkat.com/events")
    stevens_scraper(creation_hash, "https://www.uncsa.edu/performances/index.aspx")
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
        hash["#{item}/1"] = {}
      else
        inner_hash = hash["#{raw_array[(index - 1)]}/1"]
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

  def stevens_scraper(creation_hash, events_url)
    base_url = events_url.delete_suffix("/performances/index.aspx")

    doc = Nokogiri::HTML(open(events_url))

    url_array = doc.css("div.grid div a").each.with_object([]) {|node, array| array << node["href"]}

    raw_hash = url_array.each.with_object({}) do |url_suffix, hash|
      url = base_url + url_suffix
      inner_doc = Nokogiri::HTML(open(url))

      inner_doc.css('ul.performance__schedule li').each.with_index(1) do |node, index|
        hash["#{url}/#{index}"] = {}
        hash["#{url}/#{index}"][:name] = inner_doc.css('div.wrap h1').text
        hash["#{url}/#{index}"][:date_and_time] = node.text.strip.gsub(/\s+/, " ")
        hash["#{url}/#{index}"][:location] = inner_doc.css('span.event__location__icon + strong').text
        hash["#{url}/#{index}"][:organizer] = "UNCSA"
        if inner_doc.css('p.p--intro span:first-child').first.values.first
          hash["#{url}/#{index}"][:description] = JSON.parse(inner_doc.css('p.p--intro span:first-child').first.values.first)["2"]
        else
          hash["#{url}/#{index}"][:description] = inner_doc.css('p.p--intro').first.text
        end
        hash["#{url}/#{index}"][:event_url] = url
      end
    end

    creation_hash.merge!(raw_hash)
  end

  def create_events(creation_hash)
    creation_hash.each do |url_key, event_data|
      Event.create(event_data) unless Event.find_by(event_url: event_data[:event_url], date_and_time: event_data[:date_and_time])
    end
  end

end
