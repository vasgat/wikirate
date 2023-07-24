module GraphQL
  module Types
    module DeckorateFields

      ENUM_FILTERS = [:country,
                      :value_type,
                      :research_policy,
                      :designer,
                      :metric_type,
                      :company_category,
                      :company_group,
                      :wikirate_topic].freeze

      def lookup_field fieldname, type, codename = nil, is_card = false
        codename ||= fieldname
        plural_fieldname = fieldname.to_s.to_name.vary(:plural).to_sym
        is_card ||= is_card

        plural_field plural_fieldname, codename, type

        define_method plural_fieldname do |limit: 10, offset: 0, **filter|
          lookup_search codename, limit, offset, is_card, filter
        end
      end

      def card_field fieldname, type, codename = nil
        codename ||= fieldname
        singular_field fieldname, type
        define_method(fieldname) { |**mark| ok_card codename, **mark }
      end

      def cardtype_field fieldname, type, codename = nil, is_card = false
        codename ||= fieldname
        plural_fieldname = fieldname.to_s.to_name.vary(:plural).to_sym
        plural_field plural_fieldname, codename, type

        define_method plural_fieldname do |limit: 10, offset: 0, **filter|
          card_search codename, limit, offset, is_card, filter
        end
      end

      def singular_field fieldname, type
        field fieldname, type, null: true do
          argument :name, String, required: false
          argument :id, Integer, required: false
        end
      end

      def plural_field fieldname, codename, type
        field fieldname, [type], null: false do
          argument :limit, Integer, required: false
          argument :offset, Integer, required: false

          codename.card.format.filter_keys.each do |filter|
            filter_type = ENUM_FILTERS.include?(filter) ? GraphQL::Types.const_get("#{filter.to_s.camelize}FilterType"): String
            argument filter, filter_type, required: false
          end
        end
      end

    end
  end
end