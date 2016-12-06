require 'rails_helper'

RSpec.describe Food, type: :model do
  let(:food) { create(:food) }

  context "with wit client" do

    it "has valid class" do
      expect(food).to be_valid
    end

    context "when name changes" do
      let(:new_name) { "IMANEWNAME" }
      before :each do
        @old_name = food.name
        food.name = new_name
        food.save
      end

      it "removes exsting value" do
        expect(WebMock).to have_requested(
          :delete,
          "https://api.wit.ai/entities/#{food.class.name}/values/#{@old_name}"
        ).once
      end

      it "adds new value" do
        expect(WebMock).to have_requested(
          :post,
          "https://api.wit.ai/entities/#{food.class.name}/values"
        ).with(body: {value: new_name, expressions:[]}).once
      end
    end

    context "when synonyms changes" do
      let(:new_synonym) { "NEWSYNONYM" }
      before :each do
        @old_synonyms = food.synonyms
        food.synonyms << new_synonym
        food.save
      end

      it "removes exsting value" do
        expect(WebMock).to have_requested(
          :delete,
          "https://api.wit.ai/entities/#{food.class.name}/values/#{food.name}"
        ).once
      end

      it "adds new value" do
        expect(WebMock).to have_requested(
          :post,
          "https://api.wit.ai/entities/#{food.class.name}/values"
        ).with(body: {value: food.name, expressions: [new_synonym]}).once
      end
    end

    context "when class is destroyed" do
      it "removes exsting value" do
        food.destroy
        expect(WebMock).to have_requested(
          :delete,
          "https://api.wit.ai/entities/#{food.class.name}/values/#{food.name}"
        ).once
      end
    end
  end
end
