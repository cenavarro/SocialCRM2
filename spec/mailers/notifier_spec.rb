require "spec_helper"

describe Notifier do
  describe "gmail_message" do
    let(:mail) { Notifier.gmail_message }

    it "renders the headers" do
      mail.subject.should eq("Gmail message")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
