include_set Abstract::RightFilterForm
include_set Abstract::FilterFormgroups
include_set Abstract::BookmarkFiltering

def filter_keys
  %i[status year check metric_name wikirate_topic metric_type value updated project
     source research_policy bookmark]
end

def default_filter_hash
  { status: :exists, year: :latest, metric_name: "" }
end

def bookmark_type
  :metric
end

format :html do
  def filter_label field
    field.to_sym == :metric_type ? "Metric type" : super
  end

  def quick_filter_list
    @quick_filter_list ||=
      Card.fetch(:metric, :browse_metric_filter).format.quick_filter_list
  end

  def sort_options
    {
      "Metric Bookmarks": :bookmarked,
      "Metric Designer (Alphabetical)": :metric_name,
      "Metric Title (Alphabetical)": :title_name,
      "Recently Updated": :updated_at
    }
  end
end
