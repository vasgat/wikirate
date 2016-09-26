def virtual?
  true
end

format :html do
  include Set::Abstract::Filter::HtmlFormat
  def filter_categories
    []
  end

  def filter_active?
    Env.params.keys.any? { |key| filter_categories.include? key }
  end

  def content_view
    :content_left_col
  end

  def default_button_formgroup_args args
    args[:buttons] = [
      button_formgroup_reset_button,
      button_tag("Filter", situation: "primary", disable_with: "Filtering")
    ].join
  end

  def button_formgroup_reset_button
    link_to_card card.cardname.left, "Reset",
                 path: { view: content_view },
                 remote: true, class: "slotter btn btn-default margin-8"
  end

  def default_filter_header args
    args[:filter_title] ||= "Filter & Sort"
  end

  view :filter_header do |args|
    <<-HTML
      <div class="filter-header">
        <span class="glyphicon glyphicon-filter"></span>
          #{args[:filter_title]}
        <span class="filter-toggle">
          <span class="glyphicon glyphicon-triangle-right"></span>
        </span>
      </div>
    HTML
  end

  view :core do |args|
    action = card.cardname.left_name.url_key
    filter_active = filter_active? ? "block" : "none"
    <<-HTML
    <div class="filter-container">
        #{_render_filter_header(args)}
        <div class="filter-details" style="display: #{filter_active};">
          <form action="/#{action}?view=#{content_view}" method="GET" data-remote="true" class="slotter">
            #{filter_form_content(args)}
          </form>
        </div>
    </div>
    HTML
  end

  def filter_form_content _args
    "fill me"
  end
end
