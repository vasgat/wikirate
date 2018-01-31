event :process_sources, :prepare_to_validate,
      on: :save, when: :standard? do
  if (sources = subfield(:source))
    sources.item_names.each do |source_name|
      if Card.exists? source_name
        add_report_type source_name
        add_company source_name
      else
        errors.add :source, "#{source_name} does not exist."
      end
    end
  elsif action == :create
    errors.add :source, "no source cited"
  end
end

def add_possible_source name, save, duplicate
  return if duplicate && already_suggested?(name)
  new_sources = add_subcard [company, :new_sources], type_id: SessionID
  new_sources.add_item name
  new_sources.save if save # if not in event phase we have to save
end

def already_suggested? name
  suggested_source_ids.include? Card.fetch_id(name)
end

def source_subcards new_source_card
  %i[file text wikirate_link].map { |i| new_source_card.subfield i }
end

def source_in_request?
  sub_source_card = subfield("source")
  return false if sub_source_card.nil? ||
                  sub_source_card.subcard("new_source").nil?
  new_source_card = sub_source_card.subcard("new_source")
  source_subcard_exist?(new_source_card)
end

def source_subcard_exist? new_source_card
  file_card, text_card, link_card = source_subcards new_source_card
  file_card&.attachment.present? ||
    text_card&.content.present? ||
    link_card&.content.present?
end

def add_report_type source_name
  return unless report_type
  report_names = report_type.item_names
  source_card = Card.fetch(source_name).fetch trait: :report_type, new: {}
  report_names.each do |report_name|
    source_card.add_item report_name
  end
  add_subcard source_card
end

def add_company source_name
  source_card = Card.fetch(source_name).fetch trait: :wikirate_company, new: {}
  source_card.add_item company_name
  add_subcard source_card
end

def report_type
  metric_card.fetch trait: :report_type
end

def suggested_sources
  @potential_sources ||= find_suggested_sources
end

def suggested_source_ids
  find_suggested_sources return: :id
end

def find_suggested_sources args={}
  Card.search(
    args.merge(
      type_id: Card::SourceID,
      right_plus: [["company", { refer_to: company }],
                   ["report_type", {
                     refer_to: { referred_to_by: metric + "+report_type" }
                   }]]
    )
  )
end

def new_sources
  Card.fetch([company, :new_sources])&.item_names&.map { |source| Card[source] }
end

format :html do
  delegate :suggested_sources, :new_sources, to: :card

  view :new_sources, cache: :never, tags: :unknown_ok do
    wrap do
      [
        new_sources_listing,
        add_source_form
      ]
    end
  end

  view :source_suggestions, cache: :never, tags: :unknown_ok do
    source_list suggested_sources
  end

  def add_source_form
    params[:company] ||= company
    nest Card.new(type_id: Card::SourceID),
         view: :add_source_to_research,
         answer: card.name
  end

  def new_sources_listing
    return "" unless new_sources.present?
     source_list new_sources
  end

  def source_list source_cards=sources
    return "None" if source_cards.empty?
    with_nest_mode :normal do
      wrap_with :div, class: "relevant-sources" do
        source_cards.compact.map { |source| subformat(source).render_relevant }
      end
    end
  end

  def source
    Env.params[:source]
  end

  def sources
    @sources ||= find_suggested_sources - card.source_card.item_cards
    @sources.push(source_card) if source && (source_card = Card[source])
    @sources
  end


end