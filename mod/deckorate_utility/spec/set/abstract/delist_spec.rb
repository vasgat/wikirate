RSpec.describe Card::Set::Abstract::Delist do
  let(:company) { Card["SPECTRE"] }
  let(:dataset) { Card["Evil Dataset"] }

  it "deletes company from dataset when company is deleted", as_bot: true do
    company.delete!
    expect(dataset.wikirate_company_card.item_names).not_to include("SPECTRE")
  end
end