
format :html do
  # @param table_type [Symbol] eg. metric, company or topic.
  #   added as html class to the table tag
  # @param [Array<Card>] row_cards one card for every row
  # @param [Array<Symbol>] cell_views one view for every column. Is rendered
  #   for every row card
  # @param [Hash] opts add additional classes and other attributes to your table
  # @option opts [Array<String>] :header an array with a header for every column
  # @option opts [Symbol] :details_view define a view that gets rendered for the
  #   row cards if a row is clicked
  # @option opts [Hash] :td html options for the td tags. You can pass an array
  #   to :classes to assign to every column a html class.
  # @option opts [Hash] :tr html options for tr tags
  # @option opts [Hash] :table html options for table tags
  def wikirate_table table_type, row_cards, cell_views, opts={}
    @table_context = self
    WikirateTable.new(self, table_type, row_cards, cell_views, opts).render
  end

  # see #wikirate_table
  # differences:
  #   - adds td classes "header", "data", and "details"
  #   - adds :details_placeholder to cell_views
  def wikirate_table_with_details table_type, item_cards, cell_views, opts={}
    cell_views << :details_placeholder
    opts.deep_merge! td: { classes: ["header", "data", "details"] }
    wikirate_table table_type, item_cards, cell_views, opts
  end

  def count_with_label_cell count, label
    output [
               wrap_with(:div, count, class: "count"),
               wrap_with(:div, label, class: "label")
           ]
  end
end
