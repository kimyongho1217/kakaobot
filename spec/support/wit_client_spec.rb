shared_examples "a wit client" do
#  before :each do
#    stub_request(:any, /https:\/\/api\.wit\.ai*+/)
#    .to_return(:status => 200, :body => {}.to_s, :headers => {})
#  end

  it "has valid class" do
    expect(wit_client_class).to be_valid
  end

  context "when name changes" do
    let(:new_name) { "IMANEWNAME" }
    before :each do
      @old_name = wit_client_class.name
      wit_client_class.name = new_name
      wit_client_class.save
    end

    it "removes exsting value" do
      expect(WebMock).to have_requested(
        :delete,
        "https://api.wit.ai/entities/#{wit_client_class.class.name}/values/#{@old_name}"
      ).once
    end

    it "adds new value" do
      expect(WebMock).to have_requested(
        :post,
        "https://api.wit.ai/entities/#{wit_client_class.class.name}/values"
      ).with(body: {value: new_name, expressions:[]}).once
    end
  end

  context "when synonyms changes" do
    let(:new_synonym) { "NEWSYNONYM" }
    before :each do
      @old_synonyms = wit_client_class.synonyms
      wit_client_class.synonyms << new_synonym
      wit_client_class.save
    end

    it "removes exsting value" do
      expect(WebMock).to have_requested(
        :delete,
        "https://api.wit.ai/entities/#{wit_client_class.class.name}/values/#{wit_client_class.name}"
      ).once
    end

    it "adds new value" do
      expect(WebMock).to have_requested(
        :post,
        "https://api.wit.ai/entities/#{wit_client_class.class.name}/values"
      ).with(body: {value: wit_client_class.name, expressions: [new_synonym]}).once
    end
  end

  context "when class is destroyed" do
    it "removes exsting value" do
      wit_client_class.destroy
      expect(WebMock).to have_requested(
        :delete,
        "https://api.wit.ai/entities/#{wit_client_class.class.name}/values/#{wit_client_class.name}"
      ).once
    end
  end
end
