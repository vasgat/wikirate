# include_set Abstract::WikirateTable
# include_set Abstract::Media
# include_set Abstract::BsBadge
include_set Abstract::TwoColumnLayout
include_set Abstract::Thumbnail
include_set Abstract::FilterableBar
include_set Abstract::Delist

card_accessor :vote_count, type: :number, default: "0"
card_accessor :upvote_count, type: :number, default: "0"
card_accessor :downvote_count, type: :number, default: "0"

card_accessor :image, type: :image
card_accessor :subtopic, type: :pointer
card_accessor :supertopic, type: :search_type
# card_accessor :wikirate_company
card_accessor :metric