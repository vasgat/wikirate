describe Card::Set::Type::WikirateCompany do
  it "shows the link for view \"missing\"" do
    
    html = render_card :missing,{:type=>"company",:name=>"test"}
    expect(html).to eq(render_card :link,{:type=>"company",:name=>"test"} )
  end
end